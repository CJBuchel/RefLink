// lib/utils/reconnecting_stream.dart
import 'dart:async';
import 'package:grpc/grpc.dart';
import 'package:ref_link/utils/logger.dart';

/// Wraps a gRPC stream with automatic reconnection on failures
class ReconnectingStream<T> {
  final Future<ResponseStream<T>> Function() _createStream;
  final Duration _retryDelay;
  final Duration _maxRetryDelay;

  StreamController<T>? _controller;
  StreamController<bool>? _connectionStateController;
  StreamSubscription<T>? _subscription;
  Timer? _retryTimer;
  Timer? _livenessTimer;
  bool _closed = false;
  bool _isConnected = false;
  int _retryCount = 0;

  final Duration _livenessTimeout;

  ReconnectingStream(
    Future<ResponseStream<T>> Function() createStream, {
    Duration retryDelay = const Duration(seconds: 1),
    Duration maxRetryDelay = const Duration(seconds: 16),
    // The server heartbeats at least every HEARTBEAT_INTERVAL on every stream it serves (see
    // server core::events::with_heartbeat) - a gap this much longer means the stream has gone
    // silently unresponsive without gRPC/TCP raising an error on either side (e.g. a lost
    // WINDOW_UPDATE wedging this one stream's flow-control window; the underlying connection
    // and any brand-new call on it keep working fine, which is why this can hide behind an
    // otherwise "connected" state indefinitely unless something actively watches for silence).
    Duration livenessTimeout = const Duration(seconds: 8),
  }) : _createStream = createStream,
       _retryDelay = retryDelay,
       _maxRetryDelay = maxRetryDelay,
       _livenessTimeout = livenessTimeout;

  Stream<T> get stream {
    _controller ??= StreamController<T>.broadcast(onListen: _connect);
    return _controller!.stream;
  }

  /// Stream that emits true when connected, false when disconnected
  Stream<bool> get connectionState async* {
    // Emit initial state immediately
    yield _isConnected;

    // Ensure controller exists and start connecting
    if (_connectionStateController == null) {
      _connectionStateController = StreamController<bool>.broadcast();

      // Start connecting when first listener attaches
      if (!_closed && _subscription == null && _retryTimer == null) {
        _connect();
      }
    }

    // Then yield all subsequent changes
    await for (final value in _connectionStateController!.stream) {
      yield value;
    }
  }

  /// Current connection status
  bool get isConnected => _isConnected;

  void _setConnectionState(bool connected) {
    if (_isConnected != connected) {
      _isConnected = connected;
      _connectionStateController?.add(connected);
    }
  }

  Future<void> _connect() async {
    if (_closed) return;

    try {
      final grpcStream = await _createStream();
      bool firstDataReceived = false;
      _resetLivenessTimer();
      _subscription = grpcStream.listen(
        (data) {
          if (!_closed) {
            _resetLivenessTimer();
            if (!firstDataReceived) {
              firstDataReceived = true;
              _setConnectionState(true); // Only set connected after first data
            }
            _retryCount = 0; // Reset on successful data
            _controller?.add(data);
          }
        },
        onError: (Object error, StackTrace stackTrace) {
          if (!_closed) {
            logger.w('Stream error: $error');
            _setConnectionState(false);
            _scheduleReconnect();
          }
        },
        onDone: () {
          if (!_closed) {
            logger.i('Stream ended, reconnecting...');
            _setConnectionState(false);
            _scheduleReconnect();
          }
        },
      );
    } catch (e) {
      if (!_closed) {
        logger.e('Failed to connect: $e');
        _setConnectionState(false);
        _scheduleReconnect();
      }
    }
  }

  void _resetLivenessTimer() {
    _livenessTimer?.cancel();
    _livenessTimer = Timer(_livenessTimeout, _handleStaleConnection);
  }

  // The stream never errored or completed - gRPC/TCP has no idea anything is wrong - but
  // nothing has arrived in `_livenessTimeout`, well past the server's heartbeat cadence. Force
  // a reconnect: a fresh call gets a brand-new HTTP/2 stream, sidestepping whatever wedged the
  // old one instead of waiting indefinitely for an error that may never come.
  void _handleStaleConnection() {
    if (_closed) return;

    logger.w('Stream stale (no data for $_livenessTimeout), forcing reconnect');
    _setConnectionState(false);
    _scheduleReconnect();
  }

  void _scheduleReconnect() {
    _subscription?.cancel();
    _retryTimer?.cancel();
    _livenessTimer?.cancel();
    _livenessTimer = null;

    // Exponential backoff: 1s, 2s, 4s, 8s... up to maxRetryDelay
    final delayMs = (_retryDelay.inMilliseconds * (1 << _retryCount)).clamp(
      _retryDelay.inMilliseconds,
      _maxRetryDelay.inMilliseconds,
    );

    _retryCount++;
    logger.d('Reconnecting in ${delayMs}ms...');

    _retryTimer = Timer(Duration(milliseconds: delayMs), _connect);
  }

  void close() {
    _closed = true;
    _setConnectionState(false);
    _retryTimer?.cancel();
    _livenessTimer?.cancel();
    _subscription?.cancel();
    _controller?.close();
    _connectionStateController?.close();
  }
}

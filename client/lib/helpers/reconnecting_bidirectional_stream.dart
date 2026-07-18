import 'dart:async';

import 'package:flutter/material.dart';

/// Maintains a bidirectional gRPC stream and automatically reconnects if the
/// connection is lost.
///
/// ClientT - Message sent from the client to the server.
/// ServerT - Message received from the server.
///
/// This class intentionally does NOT buffer outgoing messages. If the
/// connection is down, calls to [send] are ignored. The owning provider should
/// keep track of the latest application state and republish it when required.
class ReconnectingBidirectionalStream<ClientT, ServerT> {
  ReconnectingBidirectionalStream(
    this._connect, {
    this.retryDelay = const Duration(seconds: 1),
    this.maxRetryDelay = const Duration(seconds: 16),
    this.onConnected,
    this.onDisconnected,
  });

  /// Creates a new gRPC stream.
  ///
  /// Example:
  ///
  /// (outgoing) => client.refereeStream(outgoing)
  final Stream<ServerT> Function(Stream<ClientT> outgoing) _connect;

  /// Called whenever a connection is successfully established. Mutable (not just
  /// constructor-supplied) so a provider that depends on this connection - and so can't be
  /// passed in at construction time without a circular dependency - can still hook into
  /// (re)connects, e.g. to re-announce its current state to the server every time.
  VoidCallback? onConnected;

  /// Called whenever the connection is lost.
  VoidCallback? onDisconnected;

  final Duration retryDelay;
  final Duration maxRetryDelay;

  final StreamController<ServerT> _incoming =
      StreamController<ServerT>.broadcast();

  StreamController<ClientT>? _outgoing;

  StreamSubscription<ServerT>? _subscription;

  Timer? _retryTimer;

  bool _closed = false;
  bool _connecting = false;
  bool _connected = false;

  int _retryCount = 0;

  /// Incoming server messages.
  Stream<ServerT> get stream {
    _ensureConnected();
    return _incoming.stream;
  }

  bool get isConnected => _connected;

  Future<void> _ensureConnected() async {
    if (_closed || _connected || _connecting) {
      return;
    }

    _connecting = true;

    try {
      _outgoing = StreamController<ClientT>();

      final serverStream = _connect(_outgoing!.stream);

      _subscription = serverStream.listen(
        _handleMessage,
        onError: (_, __) => _handleDisconnect(),
        onDone: _handleDisconnect,
        cancelOnError: true,
      );

      _connected = true;
      _retryCount = 0;

      onConnected?.call();
    } catch (_) {
      _handleDisconnect();
    } finally {
      _connecting = false;
    }
  }

  void _handleMessage(ServerT message) {
    if (_closed) {
      return;
    }

    _incoming.add(message);
  }

  /// Sends a message to the server.
  ///
  /// Returns true if the message was accepted by the stream.
  /// Returns false if currently disconnected.
  bool send(ClientT message) {
    if (!_connected || _outgoing == null) {
      return false;
    }

    _outgoing!.add(message);
    return true;
  }

  void _handleDisconnect() {
    if (_closed) {
      return;
    }

    if (_connected) {
      _connected = false;
      onDisconnected?.call();
    }

    _subscription?.cancel();
    _subscription = null;

    _outgoing?.close();
    _outgoing = null;

    _scheduleReconnect();
  }

  void _scheduleReconnect() {
    _retryTimer?.cancel();

    final delay = Duration(
      milliseconds: (retryDelay.inMilliseconds * (1 << _retryCount)).clamp(
        retryDelay.inMilliseconds,
        maxRetryDelay.inMilliseconds,
      ),
    );

    _retryCount++;

    _retryTimer = Timer(delay, _ensureConnected);
  }

  Future<void> close() async {
    _closed = true;

    _retryTimer?.cancel();

    await _subscription?.cancel();
    await _outgoing?.close();
    await _incoming.close();
  }
}

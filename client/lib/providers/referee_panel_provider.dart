import 'package:ref_link/generated/api.pbgrpc.dart';
import 'package:ref_link/helpers/local_storage.dart';
import 'package:ref_link/helpers/protobuf_helper.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:ref_link/helpers/reconnecting_bidirectional_stream.dart';
import 'package:ref_link/providers/grpc_channel_provider.dart';

part 'referee_panel_provider.g.dart';

@Riverpod(keepAlive: true)
RefereePanelServiceClient refereePanelService(Ref ref) {
  final channel = ref.watch(grpcChannelProvider);
  return RefereePanelServiceClient(channel);
}

@Riverpod(keepAlive: true)
ReconnectingBidirectionalStream<RefereeStreamRequest, RefereeStreamResponse>
refereePanelConnection(Ref ref) {
  final client = ref.watch(refereePanelServiceProvider);

  final connection =
      ReconnectingBidirectionalStream<
        RefereeStreamRequest,
        RefereeStreamResponse
      >((outgoing) => client.refereeStream(outgoing));

  ref.onDispose(connection.close);

  return connection;
}

@Riverpod(keepAlive: true)
class RefereePanelServer extends _$RefereePanelServer {
  static const _key = "refereePanelServerState";

  RefereeStreamResponse _getRefereePanelServerState() {
    final buffer = localStorage.getString(_key);
    return buffer != null
        ? ProtobufHelper.decode(buffer, RefereeStreamResponse.fromBuffer)
        : RefereeStreamResponse();
  }

  void _setRefereePanelServerState(RefereeStreamResponse newState) {
    localStorage.setString(_key, ProtobufHelper.encode(newState));
  }

  void _updateState(RefereeStreamResponse newState) {
    if (newState.matchId != state.matchId) {
      // reset the panel if this is a new match (clears old stored local data)
      ref.read(refereePanelProvider.notifier).resetPanel();
    }
    state = newState;
    _setRefereePanelServerState(newState);
  }

  @override
  RefereeStreamResponse build() {
    final connection = ref.read(refereePanelConnectionProvider);

    connection.stream.listen((message) {
      _updateState(message);
    });

    return _getRefereePanelServerState();
  }
}

@Riverpod(keepAlive: true)
class RefereePanel extends _$RefereePanel {
  static const _key = "refereePanelState";
  late final connection = ref.read(refereePanelConnectionProvider);

  @override
  RefereeStreamRequest build() {
    final saved = localStorage.getString(_key);

    return saved != null
        ? ProtobufHelper.decode(saved, RefereeStreamRequest.fromBuffer)
        : RefereeStreamRequest();
  }

  void _updateAndSend(Function(RefereeStreamRequest request) update) {
    final newState = state.deepCopy();
    update(newState);
    state = newState;
    localStorage.setString(_key, ProtobufHelper.encode(newState));
    connection.send(newState);
  }

  void resetPanel() {
    final defaultState = RefereeStreamRequest.getDefault();
    _updateAndSend((request) => request = defaultState);
  }

  void setRefereeVote(bool agree) {
    _updateAndSend((request) {
      request.refereeVote = agree
          ? RefereeVote.REFEREE_VOTE_AGREE
          : RefereeVote.REFEREE_VOTE_DISAGREE;
    });
  }
}

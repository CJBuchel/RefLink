import 'package:ref_link/generated/api.pbgrpc.dart';
import 'package:ref_link/helpers/local_storage.dart';
import 'package:ref_link/helpers/protobuf_helper.dart';
import 'package:ref_link/models/panel_types.dart';
import 'package:ref_link/providers/panel_id_provider.dart';
import 'package:ref_link/utils/logger.dart';
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

  RefereeStreamResponse getRefereePanelServerState() {
    final buffer = localStorage.getString(_key);
    return buffer != null
        ? ProtobufHelper.decode(buffer, RefereeStreamResponse.fromBuffer)
        : RefereeStreamResponse();
  }

  void _setRefereePanelServerState(RefereeStreamResponse newState) {
    localStorage.setString(_key, ProtobufHelper.encode(newState));
  }

  void _updateState(RefereeStreamResponse newState) {
    state = newState;
    _setRefereePanelServerState(newState);
  }

  @override
  RefereeStreamResponse build() {
    final connection = ref.read(refereePanelConnectionProvider);

    connection.stream.listen((message) {
      _updateState(message);
    });

    return getRefereePanelServerState();
  }
}

@Riverpod(keepAlive: true)
class RefereePanel extends _$RefereePanel {
  static const _key = "refereePanelState";
  late final connection = ref.read(refereePanelConnectionProvider);

  PanelType panelType = PanelType.PANEL_TYPE_UNSPECIFIED;
  int matchId = 0;

  @override
  RefereeStreamRequest build() {
    panelType = getPanelFromString(ref.watch(panelIdProvider));
    ref.listen(refereePanelServerProvider, (previous, next) {
      if (previous?.matchId != next.matchId) {
        logger.w("Panel reset (new match)");
        matchId = next.matchId;
        resetPanel();
      }
    });
    final saved = localStorage.getString(_key);

    final buffer = saved != null
        ? ProtobufHelper.decode(saved, RefereeStreamRequest.fromBuffer)
        : RefereeStreamRequest();

    buffer.panel = panelType;
    buffer.matchId = matchId;
    return buffer;
  }

  void _updateAndSend(RefereeStreamRequest update) {
    update.matchId = matchId;
    update.panel = panelType;
    localStorage.setString(_key, ProtobufHelper.encode(update));
    connection.send(update);
    state = update;
  }

  void _updateAndSendPanelState(void Function(RefereePanelState panel) update) {
    final updated = state.deepCopy();
    updated.state = updated.state.deepCopy();
    update(updated.state);
    _updateAndSend(updated);
  }

  void resetPanel() {
    final defaultState = RefereeStreamRequest();
    _updateAndSend(defaultState);
  }

  void setMatchId(int id) {
    final updated = state.deepCopy();
    updated.matchId = id;
    _updateAndSend(updated);
  }

  void setPanelType(PanelType panel) {
    final updated = state.deepCopy();
    updated.panel = panel;
    _updateAndSend(updated);
  }

  void setRefereeVote(bool agree) {
    _updateAndSendPanelState((panel) {
      panel.refereeVote = agree
          ? RefereeVote.REFEREE_VOTE_AGREE
          : RefereeVote.REFEREE_VOTE_DISAGREE;
    });
  }
}

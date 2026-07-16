import 'package:ref_link/generated/api.pbgrpc.dart';
import 'package:ref_link/helpers/local_storage.dart';
import 'package:ref_link/helpers/protobuf_helper.dart';
import 'package:ref_link/helpers/reconnecting_bidirectional_stream.dart';
import 'package:ref_link/providers/grpc_channel_provider.dart';
import 'package:ref_link/utils/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'head_referee_panel_provider.g.dart';

@Riverpod(keepAlive: true)
HeadRefereePanelServiceClient headRefereePanelService(Ref ref) {
  final channel = ref.watch(grpcChannelProvider);
  return HeadRefereePanelServiceClient(channel);
}

@Riverpod(keepAlive: true)
ReconnectingBidirectionalStream<HeadRefereeStreamRequest, HeadRefereeStreamResponse>
headRefereePanelConnection(Ref ref) {
  final client = ref.watch(headRefereePanelServiceProvider);

  final connection =
      ReconnectingBidirectionalStream<
        HeadRefereeStreamRequest,
        HeadRefereeStreamResponse
      >((outgoing) => client.headRefereeStream(outgoing));

  ref.onDispose(connection.close);

  return connection;
}

@Riverpod(keepAlive: true)
class HeadRefereePanelServer extends _$HeadRefereePanelServer {
  static const _key = "headRefereePanelServerState";

  HeadRefereeStreamResponse getHeadRefereePanelServerState() {
    final buffer = localStorage.getString(_key);
    return buffer != null
        ? ProtobufHelper.decode(buffer, HeadRefereeStreamResponse.fromBuffer)
        : HeadRefereeStreamResponse();
  }

  void _setHeadRefereePanelServerState(HeadRefereeStreamResponse newState) {
    localStorage.setString(_key, ProtobufHelper.encode(newState));
  }

  void _updateState(HeadRefereeStreamResponse newState) {
    state = newState;
    _setHeadRefereePanelServerState(newState);
  }

  @override
  HeadRefereeStreamResponse build() {
    final connection = ref.read(headRefereePanelConnectionProvider);

    connection.stream.listen((message) {
      _updateState(message);
    });

    return getHeadRefereePanelServerState();
  }
}

@Riverpod(keepAlive: true)
class HeadRefereePanel extends _$HeadRefereePanel {
  static const _key = "headRefereePanelState";
  late final connection = ref.read(headRefereePanelConnectionProvider);

  int matchId = 0;

  @override
  HeadRefereeStreamRequest build() {
    matchId = ref.read(headRefereePanelServerProvider).matchId; // get initial
    ref.listen(headRefereePanelServerProvider, (previous, next) {
      if (previous?.matchId != next.matchId) {
        logger.w("Head referee panel reset (new match)");
        matchId = next.matchId;
        resetPanel();
      }
    });
    final saved = localStorage.getString(_key);

    final buffer = saved != null
        ? ProtobufHelper.decode(saved, HeadRefereeStreamRequest.fromBuffer)
        : HeadRefereeStreamRequest();

    buffer.matchId = matchId;
    return buffer;
  }

  void _updateAndSend(HeadRefereeStreamRequest update) {
    update.matchId = matchId;
    localStorage.setString(_key, ProtobufHelper.encode(update));
    connection.send(update);
    state = update;
  }

  void _updateAndSendPanelState(
    void Function(HeadRefereePanelState panel) update,
  ) {
    final updated = state.deepCopy();
    updated.state = updated.state.deepCopy();
    update(updated.state);
    _updateAndSend(updated);
  }

  void resetPanel() {
    final defaultState = HeadRefereeStreamRequest();
    _updateAndSend(defaultState);
  }

  void setRefViewRequired(bool required) {
    _updateAndSendPanelState((panel) {
      panel.refReviewRequired = required;
    });
  }

  // field_state is one-way (MATCH -> COUNT -> RESET) - the server clamps it so it can never
  // move backwards regardless of what's sent, so these just request the next step.
  void signalFieldCount() {
    _updateAndSendPanelState((panel) {
      panel.fieldState = FieldState.FIELD_STATE_COUNT;
    });
  }

  void signalFieldReset() {
    _updateAndSendPanelState((panel) {
      panel.fieldState = FieldState.FIELD_STATE_RESET;
    });
  }

  // No Cheesy Arena call here - it has no concept of a "2 minute warning" (its own timeout
  // feature is for actual match-clock breaks, not a heads-up cue). One-way per match cycle,
  // clamped server-side the same way as field_state.
  void giveTwoMinuteWarning() {
    _updateAndSendPanelState((panel) {
      panel.twoMinuteWarningGiven = true;
    });
  }

  void addFoul({required bool red, required bool major}) {
    _updateAndSendPanelState((panel) {
      final fouls = panel.ensureMatchFouls();
      if (red) {
        fouls.redMajorFouls += major ? 1 : 0;
        fouls.redMinorFouls += major ? 0 : 1;
      } else {
        fouls.blueMajorFouls += major ? 1 : 0;
        fouls.blueMinorFouls += major ? 0 : 1;
      }
    });
  }

  void removeFoul({required bool red, required bool major}) {
    _updateAndSendPanelState((panel) {
      final fouls = panel.ensureMatchFouls();
      if (red) {
        fouls.redMajorFouls -= major ? 1 : 0;
        fouls.redMinorFouls -= major ? 0 : 1;
      } else {
        fouls.blueMajorFouls -= major ? 1 : 0;
        fouls.blueMinorFouls -= major ? 0 : 1;
      }
    });
  }

  void setCardState(CardType cardType, TeamAllianceStationType allianceStation) {
    _updateAndSendPanelState((panel) {
      final cards = panel.ensureMatchCards();
      switch (allianceStation) {
        case TeamAllianceStationType.TEAM_ALLIANCE_STATION_TYPE_BLUE_1:
          cards.blueAllianceStation1 = cardType;
        case TeamAllianceStationType.TEAM_ALLIANCE_STATION_TYPE_BLUE_2:
          cards.blueAllianceStation2 = cardType;
        case TeamAllianceStationType.TEAM_ALLIANCE_STATION_TYPE_BLUE_3:
          cards.blueAllianceStation3 = cardType;
        case TeamAllianceStationType.TEAM_ALLIANCE_STATION_TYPE_RED_1:
          cards.redAllianceStation1 = cardType;
        case TeamAllianceStationType.TEAM_ALLIANCE_STATION_TYPE_RED_2:
          cards.redAllianceStation2 = cardType;
        case TeamAllianceStationType.TEAM_ALLIANCE_STATION_TYPE_RED_3:
          cards.redAllianceStation3 = cardType;
        default:
          break;
      }
    });
  }

  CardType getAllianceStationCard(TeamAllianceStationType allianceStation) {
    final cards = state.state.matchCards;
    switch (allianceStation) {
      case TeamAllianceStationType.TEAM_ALLIANCE_STATION_TYPE_BLUE_1:
        return cards.blueAllianceStation1;
      case TeamAllianceStationType.TEAM_ALLIANCE_STATION_TYPE_BLUE_2:
        return cards.blueAllianceStation2;
      case TeamAllianceStationType.TEAM_ALLIANCE_STATION_TYPE_BLUE_3:
        return cards.blueAllianceStation3;
      case TeamAllianceStationType.TEAM_ALLIANCE_STATION_TYPE_RED_1:
        return cards.redAllianceStation1;
      case TeamAllianceStationType.TEAM_ALLIANCE_STATION_TYPE_RED_2:
        return cards.redAllianceStation2;
      case TeamAllianceStationType.TEAM_ALLIANCE_STATION_TYPE_RED_3:
        return cards.redAllianceStation3;
      default:
        return CardType.CARD_TYPE_UNSPECIFIED;
    }
  }
}

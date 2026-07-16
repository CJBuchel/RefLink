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
    matchId = ref.read(refereePanelServerProvider).matchId; // get initial
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
    ref.invalidate(refereeSubtractionModeProvider);
    ref.invalidate(refereeCardModeProvider);
    ref.invalidate(refereeEndgameModeProvider);
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

  void setStation1AutoClimbState(AutoClimbState climb) {
    _updateAndSendPanelState((panel) {
      panel.ensureAutoClimb().autoClimbAllianceStation1 = climb;
    });
  }

  void setStation2AutoClimbState(AutoClimbState climb) {
    _updateAndSendPanelState((panel) {
      panel.ensureAutoClimb().autoClimbAllianceStation2 = climb;
    });
  }

  void setStation3AutoClimbState(AutoClimbState climb) {
    _updateAndSendPanelState((panel) {
      panel.ensureAutoClimb().autoClimbAllianceStation3 = climb;
    });
  }

  void setStation1EndgameClimbState(EndgameClimbState climb) {
    _updateAndSendPanelState((panel) {
      panel.ensureEndgameClimb().endgameClimbAllianceStation1 = climb;
    });
  }

  void setStation2EndgameClimbState(EndgameClimbState climb) {
    _updateAndSendPanelState((panel) {
      panel.ensureEndgameClimb().endgameClimbAllianceStation2 = climb;
    });
  }

  void setStation3EndgameClimbState(EndgameClimbState climb) {
    _updateAndSendPanelState((panel) {
      panel.ensureEndgameClimb().endgameClimbAllianceStation3 = climb;
    });
  }

  void submitAuto() {
    _updateAndSendPanelState((panel) {
      panel.autoSubmitted = true;
    });
  }

  void submitEndgame() {
    _updateAndSendPanelState((panel) {
      panel.endgameSubmitted = true;
    });
  }

  void setAutoIssue() {
    _updateAndSendPanelState((panel) {
      panel.autoIssue = true;
    });
  }

  void setRpIssue() {
    _updateAndSendPanelState((panel) {
      panel.rpIssue = true;
    });
  }

  void setDiscussionNeeded() {
    _updateAndSendPanelState((panel) {
      panel.discussionNeeded = true;
    });
  }

  void setEndgameIssue() {
    _updateAndSendPanelState((panel) {
      panel.endgameIssue = true;
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

  void setCardState(
    CardType cardType,
    TeamAllianceStationType allianceStation,
  ) {
    switch (allianceStation) {
      case TeamAllianceStationType.TEAM_ALLIANCE_STATION_TYPE_BLUE_1:
        _updateAndSendPanelState((panel) {
          panel.ensureMatchCards().blueAllianceStation1 = cardType;
        });
        break;
      case TeamAllianceStationType.TEAM_ALLIANCE_STATION_TYPE_BLUE_2:
        _updateAndSendPanelState((panel) {
          panel.ensureMatchCards().blueAllianceStation2 = cardType;
        });
        break;
      case TeamAllianceStationType.TEAM_ALLIANCE_STATION_TYPE_BLUE_3:
        _updateAndSendPanelState((panel) {
          panel.ensureMatchCards().blueAllianceStation3 = cardType;
        });
        break;
      case TeamAllianceStationType.TEAM_ALLIANCE_STATION_TYPE_RED_1:
        _updateAndSendPanelState((panel) {
          panel.ensureMatchCards().redAllianceStation1 = cardType;
        });
        break;
      case TeamAllianceStationType.TEAM_ALLIANCE_STATION_TYPE_RED_2:
        _updateAndSendPanelState((panel) {
          panel.ensureMatchCards().redAllianceStation2 = cardType;
        });
        break;
      case TeamAllianceStationType.TEAM_ALLIANCE_STATION_TYPE_RED_3:
        _updateAndSendPanelState((panel) {
          panel.ensureMatchCards().redAllianceStation3 = cardType;
        });
        break;
      default:
        break;
    }
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

@riverpod
class RefereeSubtractionMode extends _$RefereeSubtractionMode {
  void setSubtractionMode(bool subtraction) {
    state = subtraction;
  }

  void toggleSubtractionMode() {
    state = !state;
  }

  @override
  bool build() {
    return false;
  }
}

@riverpod
class RefereeCardMode extends _$RefereeCardMode {
  void setCardMode(bool mode) {
    state = mode;
  }

  void toggleCardMode() {
    state = !state;
  }

  @override
  bool build() {
    return false;
  }
}

@riverpod
class RefereeEndgameMode extends _$RefereeEndgameMode {
  void setEndgameMode(bool endgame) {
    state = endgame;
  }

  void toggleEndgameMode() {
    state = !state;
  }

  @override
  bool build() {
    return false;
  }
}

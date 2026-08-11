import 'package:ref_link/generated/fms.pbgrpc.dart';
import 'package:ref_link/providers/grpc_channel_provider.dart';
import 'package:ref_link/providers/mqtt_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'fms_provider.g.dart';

// GetMatchInfo stays a plain unary gRPC call; StreamMatchInfo moved to MQTT (retained, see
// server/src/modules/fms/cheesy/client.rs's publish_match_info).
@Riverpod(keepAlive: true)
FmsServiceClient fmsService(Ref ref) {
  final channel = ref.watch(grpcChannelProvider);
  return FmsServiceClient(channel);
}

@Riverpod(keepAlive: true)
Stream<FmsMatchInfo> arenaMatchInfo(Ref ref) {
  final client = ref.watch(mqttProvider);
  return subscribeDecoded(client, fmsMatchInfoTopic, FmsMatchInfo.fromBuffer);
}

String matchTypeLabel(MatchType type) {
  switch (type) {
    case MatchType.MATCH_TYPE_PRACTICE:
      return 'Practice';
    case MatchType.MATCH_TYPE_QUALIFICATION:
      return 'Qualification';
    case MatchType.MATCH_TYPE_PLAYOFF:
      return 'Playoff';
    default:
      return 'Match';
  }
}

String matchTimerLabel(int secondsRemaining) {
  final clamped = secondsRemaining < 0 ? 0 : secondsRemaining;
  final minutes = clamped ~/ 60;
  final seconds = clamped % 60;
  return '$minutes:${seconds.toString().padLeft(2, '0')}';
}

import 'package:ref_link/generated/db.pb.dart';

class EndgameClimbStationModel {
  final String teamNumber;
  final bool teamBypassed;
  final bool isRed;
  final EndgameClimbState climbState;
  final EndgameClimbState partnerClimbState;

  EndgameClimbStationModel({
    required this.teamNumber,
    required this.teamBypassed,
    required this.isRed,
    required this.climbState,
    required this.partnerClimbState,
  });

  EndgameClimbStationModel copyWith({
    String? teamNumber,
    bool? teamBypassed,
    bool? isRed,
    EndgameClimbState? climbState,
    EndgameClimbState? partnerClimbState,
  }) {
    return EndgameClimbStationModel(
      teamNumber: teamNumber ?? this.teamNumber,
      teamBypassed: teamBypassed ?? this.teamBypassed,
      isRed: isRed ?? this.isRed,
      climbState: climbState ?? this.climbState,
      partnerClimbState: partnerClimbState ?? this.partnerClimbState,
    );
  }
}

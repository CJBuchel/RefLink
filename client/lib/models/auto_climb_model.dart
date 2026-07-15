import 'package:ref_link/generated/api.pb.dart';

class AutoClimbStationModel {
  final String teamNumber;
  final bool teamBypassed;
  final bool isRed;
  final AutoClimbState climbState;
  final AutoClimbState partnerClimbState;

  AutoClimbStationModel({
    required this.teamNumber,
    required this.teamBypassed,
    required this.isRed,
    required this.climbState,
    required this.partnerClimbState,
  });

  AutoClimbStationModel copyWith({
    String? teamNumber,
    bool? teamBypassed,
    bool? isRed,
    AutoClimbState? climbState,
    AutoClimbState? partnerClimbState,
  }) {
    return AutoClimbStationModel(
      teamNumber: teamNumber ?? this.teamNumber,
      teamBypassed: teamBypassed ?? this.teamBypassed,
      isRed: isRed ?? this.isRed,
      climbState: climbState ?? this.climbState,
      partnerClimbState: partnerClimbState ?? this.partnerClimbState,
    );
  }
}

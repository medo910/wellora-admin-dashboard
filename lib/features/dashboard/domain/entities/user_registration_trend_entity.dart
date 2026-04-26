import 'package:equatable/equatable.dart';

class UserRegistrationTrendEntity extends Equatable {
  final String month;
  final int patients;
  final int doctors;

  const UserRegistrationTrendEntity({
    required this.month,
    required this.patients,
    required this.doctors,
  });

  @override
  List<Object?> get props => [month, patients, doctors];
}

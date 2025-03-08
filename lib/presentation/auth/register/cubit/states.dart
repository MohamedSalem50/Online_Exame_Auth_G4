import '../../../../domain/entity/auth_result_entity.dart';

abstract class RegisterState {}
class RegisterInitialState extends RegisterState{}
class RegisterErrorState extends RegisterState{
  final String errorMessage;
  RegisterErrorState(this.errorMessage);
}
class RegisterLoadingState extends RegisterState{}
class RegisterSuccessState extends RegisterState{
  AuthResultEntity authResultEntity;
  RegisterSuccessState({required this.authResultEntity,});
}
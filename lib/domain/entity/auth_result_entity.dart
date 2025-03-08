import 'package:online_exam/domain/entity/User_entity.dart';

class AuthResultEntity {
  UserEntity? userEntity;
  String? token;
  AuthResultEntity({this.userEntity, this.token,});
}
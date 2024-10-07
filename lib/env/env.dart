import 'package:envied/envied.dart';
part 'env.g.dart';

@Envied(path: ".env")
abstract class Env {
  @EnviedField(varName: 'OPEN_AI_API_KEY') // the .env variable.
  static const String apiKey = _Env.apiKey;
  @EnviedField(varName: 'NAVER_CLIENT_ID') // the .env variable.
  static const String clientId = _Env.clientId;
  @EnviedField(varName: 'NAVER_CLIENT_SECRET') // the .env variable.
  static const String clientSecret = _Env.clientSecret;
}

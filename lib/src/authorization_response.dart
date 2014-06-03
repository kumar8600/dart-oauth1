library authorization_response;

import 'credentials.dart';

/// A class describing Response of Authoriazation request.
class AuthorizationResponse {
  final Credentials _credentials;
  final Map<String, String> _optionalParameters;

  AuthorizationResponse(this._credentials, this._optionalParameters);
  factory AuthorizationResponse.fromMap(Map<String, String> parameters) {
    Map<String, String> paramsCopy = new Map<String, String>.from(parameters);
    Credentials cred = new Credentials.fromMap(paramsCopy);
    paramsCopy.remove('oauth_token');
    paramsCopy.remove('oauth_token_secret');
    return new AuthorizationResponse(cred, paramsCopy);
  }

  Credentials get credentials => _credentials;
  Map<String, String> get optionalParameters => _optionalParameters;
}
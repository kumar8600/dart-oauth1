library credentials;

import 'dart:convert';

/**
 * A class describing OAuth credentials except for client credential
 */
class Credentials {
  final String _token;
  final String _tokenSecret;

  Credentials(this._token, this._tokenSecret);
  factory Credentials.fromMap(Map<String, String> parameters) {
    if (!parameters.containsKey('oauth_token')) {
      throw new ArgumentError("params doesn't have a key 'oauth_token'");
    }
    if (!parameters.containsKey('oauth_token_secret')) {
      throw new ArgumentError("params doesn't have a key 'oauth_token_secret'");
    }
    return new Credentials(parameters['oauth_token'], parameters['oauth_token_secret']);
  }
  factory Credentials.fromJSON(String json) {
    return new Credentials.fromMap(JSON.decode(json));
  }

  String get token => _token;
  String get tokenSecret => _tokenSecret;

  String toString() {
    return 'oauth_token=$token&oauth_token_secret=$tokenSecret';
  }

  Map toJSON() {
    return {
      "oauth_token": token,
      "oauth_token_secret": tokenSecret
    };
  }
}

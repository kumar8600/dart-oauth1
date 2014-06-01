library credentials;

/**
 * A class describing OAuth credentials except for client credentials.
 */
class Credentials {
  final String _token;
  final String _tokenSecret;

  Credentials(this._token, this._tokenSecret);


  String get token => _token;
  String get tokenSecret => _tokenSecret;

  String toString() {
    return 'oauth_token=$token&oauth_token_secret=$tokenSecret';
  }
}

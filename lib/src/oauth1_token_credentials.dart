part of oauth1;

/**
 * A class describing OAuth Token Credentials.
 * http://tools.ietf.org/html/rfc5849#section-2.3
 */
class OAuth1TokenCredentials implements OAuth1AbstractCredentials {
  final String _token;
  final String _tokenSecret;

  OAuth1TokenCredentials(this._token, this._tokenSecret);
  OAuth1TokenCredentials.fromMap(Map<String, String> params)
      : this(params['oauth_token'], params['oauth_token_secret']);

  String get token => _token;
  String get tokenSecret => _tokenSecret;
  
  String toString() {
    return 'oauth_token=$token&oauth_token_secret=$tokenSecret';
  }
}

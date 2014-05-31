part of oauth1;

/**
 * A class describing OAuth Temporary Credentials.
 * http://tools.ietf.org/html/rfc5849#section-2.1
 */
class OAuth1TemporaryCredentials implements OAuth1AbstractCredentials {
  final String _token;
  final String _tokenSecret;

  OAuth1TemporaryCredentials(this._token, this._tokenSecret);
  OAuth1TemporaryCredentials.fromMap(Map<String, String> params)
      : this(params['oauth_token'], params['oauth_token_secret']);

  String get token => _token;
  String get tokenSecret => _tokenSecret;
}

part of oauth1;

/**
 * A class describing OAuth Client Credentials.
 * http://tools.ietf.org/html/rfc6749#section-1.3.4
 */
class OAuth1ClientCredentials implements OAuth1AbstractCredentials {
  final String _token;
  final String _tokenSecret;

  OAuth1ClientCredentials(this._token, this._tokenSecret);

  String get token => _token;
  String get tokenSecret => _tokenSecret;
}

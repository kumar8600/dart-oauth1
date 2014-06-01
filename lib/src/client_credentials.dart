library client_credentials;

/**
 * A class describing OAuth client credentials.
 */
class ClientCredentials {
  final String _token;
  final String _tokenSecret;

  ClientCredentials(this._token, this._tokenSecret);

  String get token => _token;
  String get tokenSecret => _tokenSecret;
}

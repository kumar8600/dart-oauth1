part of oauth1;

/**
 * A proxy class describing Accessing Protected Resources in OAuth.
 */
class OAuth1Connection {
  final OAuth1ClientCredentials _clientCredentials;
  final OAuth1TokenCredentials _tokenCredentials;

  /**
   * A constructor of OAuthProxy.
   */
  OAuth1Connection(this._clientCredentials, this._tokenCredentials);

  /**
   * Return HttpRequest object to access protected resources.
   */
  HttpRequest access(String method, String url, [Map<String, String> params, Map
      data]) {
    return OAuth1Utils._createRequest(_clientCredentials, _tokenCredentials,
        method, url, params, data);
  }
}

part of oauth1;

/**
 * A facade class describing OAuth authentication. 
 */
class OAuth1Authenticator {
  final OAuth1ClientCredentials _clientCredentials;

  static const String _URL_REQUEST_TOKEN =
      "https://api.twitter.com/oauth/request_token";
  static const String _URL_ACCESS_TOKEN =
      "https://api.twitter.com/oauth/access_token";
  static const String _URL_AUTHENTICATE =
      "https://api.twitter.com/oauth/authenticate";
  static const String _URL_AUTHORIZE =
      "https://api.twitter.com/oauth/authorize";

  /**
   * A constructor of OAuth.
   */
  OAuth1Authenticator(this._clientCredentials);

  /**
   * Return Future<OAuthTemporaryCredentials> object is responsed from
   * oauth/request_token.
   * https://dev.twitter.com/docs/api/1/post/oauth/request_token
   */
  Future<OAuth1TemporaryCredentials> requestRequestToken() {
    return OAuth1Utils._request(_clientCredentials, null, 'POST',
        _URL_REQUEST_TOKEN, {
      'oauth_callback': 'oob'
    }).then((res) {
      var params = OAuth1Utils._parseResponseParameters(res);
      if (params['oauth_callback_confirmed'].toLowerCase() != 'true') {
        throw new StateError("oauth_callback_confirmed must be true");
      }
      return new OAuth1TemporaryCredentials.fromMap(params);
    });
  }

  /**
   * Return Future<OAuthTokenCredentials> object is responsed from oauth/access_token.
   * https://dev.twitter.com/docs/api/1/post/oauth/access_token
   */
  Future<OAuth1TokenCredentials> requestAccessToken(OAuth1TemporaryCredentials
      temporaryCredentials, String verifier) {
    return OAuth1Utils._request(_clientCredentials, temporaryCredentials, 'POST',
        _URL_ACCESS_TOKEN, {
      'oauth_verifier': verifier
    }).then((res) => new OAuth1TokenCredentials.fromMap(
        OAuth1Utils._parseResponseParameters(res)));
  }

  /**
   * Return URL to oauth/authenticate page from requestToken.
   * https://dev.twitter.com/docs/api/1/get/oauth/authenticate
   */
  static String createAuthenticateURL(String requestToken) {
    return _URL_AUTHENTICATE + '?' + requestToken;
  }

  /**
   * Return URL to oauth/authorize page from requestToken.
   * https://dev.twitter.com/docs/api/1/get/oauth/authorize
   */
  static String createAuthorizeURL(String requestToken) {
    return _URL_AUTHORIZE + '?' + requestToken;
  }

}

library authorization;

import 'dart:async';
import 'package:http/browser_client.dart';
import 'package:http/http.dart' as http;

import 'credentials.dart';
import 'client_credentials.dart';
import 'platform.dart';
import 'authorization_header_builder.dart';

/**
 * A proxy class describing OAuth 1.0 redirection-based authorization.
 * http://tools.ietf.org/html/rfc5849#section-2
 *
 * Redirection works are belonged to client.
 * So you can do PIN-based authorization too if you want.
 */
class Authorization {
  final ClientCredentials _clientCredentials;
  final AbstractPlatform _platform;
  final http.BaseClient _httpClient;

  /// A constructor of Authorization.
  Authorization(this._clientCredentials, this._platform, this._httpClient);

  /// A named constructor of Authorization using dart:io for http requests.
  Authorization.forClient(this._clientCredentials, this._platform) : _httpClient = new http.Client();

  /// A named constructor of Authorization using dart:html for http requests.
  Authorization.forBrowser(this._clientCredentials, this._platform) : _httpClient = new BrowserClient();

  /**
   * Obtain a set of temporary credentials from the server.
   * http://tools.ietf.org/html/rfc5849#section-2.1
   *
   * If not callbackURI passed, authentication becomes PIN-based.
   */
  Future<Credentials> requestTemporaryCredentials([String callbackURI]) {
    if (callbackURI == null) {
      callbackURI = 'oob';
    }
    Map additionalParams = {
      'oauth_callback': callbackURI
    };
    var ahb = new AuthorizationHeaderBuilder();
    ahb.signatureMethod = _platform.signatureMethod;
    ahb.clientCredentials = _clientCredentials;
    ahb.method = 'POST';
    ahb.url = _platform.temporaryCredentialsRequestURI;
    ahb.additionalParameters = additionalParams;

    return _httpClient.post(_platform.temporaryCredentialsRequestURI, headers: {
      'Authorization': ahb.build().toString()
    }).then((res) {
      Map<String, String> params = _parseResponseParameters(res.body);
      if (params['oauth_callback_confirmed'].toLowerCase() != 'true') {
        throw new StateError("oauth_callback_confirmed must be true");
      }
      return new Credentials(params['oauth_token'], params['oauth_token_secret']);
    });
  }

  /**
   * Get resource owner authorization URI.
   * http://tools.ietf.org/html/rfc5849#section-2.2
   */
  String getResourceOwnerAuthorizationURI(String temporaryCredentialsIdentifier) {
    return _platform.resourceOwnerAuthorizationURI + "?oauth_token=" + Uri.encodeComponent(temporaryCredentialsIdentifier);
  }

  /**
   * Obtain a set of token credentials from the server.
   * http://tools.ietf.org/html/rfc5849#section-2.3
   */
  Future<Credentials> requestTokenCredentials(Credentials temporaryCredentials, String verifier) {
    Map additionalParams = {
      'oauth_verifier': verifier
    };
    var ahb = new AuthorizationHeaderBuilder();
    ahb.signatureMethod = _platform.signatureMethod;
    ahb.clientCredentials = _clientCredentials;
    ahb.credentials = temporaryCredentials;
    ahb.method = 'POST';
    ahb.url = _platform.tokenCredentialsRequestURI;
    ahb.additionalParameters = additionalParams;

    return _httpClient.post(_platform.temporaryCredentialsRequestURI, headers: {
      'Authorization': ahb.build().toString()
    }).then((res) {
      Map<String, String> params = _parseResponseParameters(res.body);
      return new Credentials(params['oauth_token'], params['oauth_token_secret']);
    });
  }

  /**
   * Return Map object of parsed parameters from
   * OAuth Service Provider Response Parameters.
   */
  static Map<String, String> _parseResponseParameters(String response) {
    Map<String, String> result = new Map<String, String>();
    response.split('&').forEach((p) {
      Iterable keyValue = p.split('=').map(Uri.encodeComponent);
      result[keyValue.first] = keyValue.length > 1 ? keyValue.elementAt(1) : "";
    });
    return result;
  }
}

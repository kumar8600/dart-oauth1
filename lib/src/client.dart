library oauth1_client;

import 'dart:async';
import 'package:http/browser_client.dart';
import 'package:http/http.dart' as http;

import 'signature_method.dart';
import 'client_credentials.dart';
import 'credentials.dart';
import 'authorization_header_builder.dart';

/**
 * A proxy class describing OAuth 1.0 Authenticated Request
 * http://tools.ietf.org/html/rfc5849#section-3
 *
 * If _credentials is null, this is usable for authorization requests too.
 */
class Client extends http.BaseClient {
  final SignatureMethod _signatureMethod;
  final ClientCredentials _clientCredentials;
  final Credentials _credentials;
  final http.BaseClient _httpClient;

  /// A constructor of Client.
  Client(this._signatureMethod, this._clientCredentials, this._credentials, this._httpClient);

  /// A named constructor of Client using dart:io for http requests.
  Client.forClient(this._signatureMethod, this._clientCredentials, this._credentials) :
    _httpClient = new http.Client();

  /// A named constructor of Client using dart:html for http requests.
  Client.forBrowser(this._signatureMethod, this._clientCredentials, this._credentials) :
    _httpClient = new BrowserClient();

  Future<http.StreamedResponse> send(http.BaseRequest request) {
    var ahb = new AuthorizationHeaderBuilder();
    ahb.signatureMethod = _signatureMethod;
    ahb.clientCredentials = _clientCredentials;
    ahb.credentials = _credentials;
    ahb.method = request.method;
    ahb.url = request.url.toString();
    ahb.additionalParameters = request.headers;
    request.headers['Authorization'] = ahb.build().toString();
    return _httpClient.send(request);
  }
}

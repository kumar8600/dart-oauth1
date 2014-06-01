library auhthorization_header_builder;

import 'authorization_header.dart';
import 'signature_method.dart';
import 'client_credentials.dart';
import 'credentials.dart';

/**
 * A builder class for AuthorizationHeader.
 */
class AuthorizationHeaderBuilder {
  SignatureMethod _signatureMethod;
  ClientCredentials _clientCredentials;
  Credentials _credentials;
  String _method;
  String _url;
  Map<String, String> _additionalParameters;

  AuthorizationHeaderBuilder();
  AuthorizationHeaderBuilder.from(AuthorizationHeaderBuilder other) :
    _signatureMethod = other._signatureMethod,
    _clientCredentials = other._clientCredentials,
    _credentials = other._credentials,
    _method = other._method,
    _url = other._url,
    _additionalParameters = other._additionalParameters;

  set signatureMethod(SignatureMethod value) => _signatureMethod = value;
  set clientCredentials(ClientCredentials value) => _clientCredentials = value;
  set credentials(Credentials value) => _credentials = value;
  set method(String value) => _method = value;
  set url(String value) => _url = value;
  set additionalParameters(Map<String, String> value) => _additionalParameters = value;

  AuthorizationHeader build() {
    if (_signatureMethod == null) {
      throw new StateError("signatureMethod is not set");
    }
    if (_clientCredentials == null) {
      throw new StateError("clientCredentials is not set");
    }
    if (_method == null) {
      throw new StateError("method is not set");
    }
    if (_url == null) {
      throw new StateError("url is not set");
    }
    return new AuthorizationHeader(_signatureMethod, _clientCredentials, _credentials, _method, _url, _additionalParameters);
  }
}
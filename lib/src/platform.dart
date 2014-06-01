library platform;

import 'signature_method.dart';

/**
 * Configuration of OAuth1Authorization.
 * http://tools.ietf.org/html/rfc5849
 */
abstract class AbstractPlatform {
  /// Temporary Credentials Request URI
  String get temporaryCredentialsRequestURI;

  /// Resource Owner Authorization URI
  String get resourceOwnerAuthorizationURI;

  /// Token Credentials Request URI
  String get tokenCredentialsRequestURI;

  /// Signature Method
  SignatureMethod get signatureMethod;
}

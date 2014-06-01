library utils;

import 'platform.dart';
import 'signature_method.dart';

class Twitter extends AbstractPlatform {
  /// Temporary Credentials Request URI
  String get temporaryCredentialsRequestURI => 'https://api.twitter.com/oauth/request_token';

  /// Resource Owner Authorization URI
  String get resourceOwnerAuthorizationURI => 'https://api.twitter.com/oauth/authorize';

  /// Token Credentials Request URI
  String get tokenCredentialsRequestURI => 'https://api.twitter.com/oauth/access_token';

  /// Signature Method
  SignatureMethod get signatureMethod => new HMAC_SHA1();
}

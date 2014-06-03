library utils;

import 'platform.dart';
import 'signature_method.dart';

/// A utility class contains platform definitions.
abstract class Platforms {
  static Platform TWITTER1_1 = new Platform(
      'https://api.twitter.com/oauth/request_token',
      'https://api.twitter.com/oauth/authorize',
      'https://api.twitter.com/oauth/access_token',
      SignatureMethods.HMAC_SHA1);
}

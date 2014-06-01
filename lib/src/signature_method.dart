library signature_method;

import 'package:crypto/crypto.dart';
import 'package:cipher/cipher.dart' as cipher;

/**
 * A abstract class abstracting Signature Method.
 * http://tools.ietf.org/html/rfc5849#section-3.4
 */
abstract class SignatureMethod {
  /// Signature Method Name
  String get name;

  /// Sign data by key.
  String sign(String key, String text);
}

/// http://tools.ietf.org/html/rfc5849#section-3.4.2
class HMAC_SHA1 extends SignatureMethod {
  String get name => "HMAC-SHA1";

  String sign(String key, String text) {
    HMAC hmac = new HMAC(new SHA1(), key.codeUnits);
    hmac.add(text.codeUnits);

    // The output of the HMAC signing function is a binary
    // string. This needs to be base64 encoded to produce
    // the signature string.
    return CryptoUtils.bytesToBase64(hmac.close());
  }
}

/// http://tools.ietf.org/html/rfc5849#section-3.4.3
/// TODO: Implement RSA-SHA1
//class RSA_SHA1 extends SignatureMethod {
//  String get name => "RSA-SHA1";
//
//  String sign(String key, String text) {
//  }
//}

/// http://tools.ietf.org/html/rfc5849#section-3.4.4
class PLAINTEXT extends SignatureMethod {
  String get name => "PLAINTEXT";

  String sign(String key, String text) {
    return key;
  }
}

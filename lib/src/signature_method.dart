library signature_method;

import 'package:crypto/crypto.dart';

typedef String Sign(String key, String text);

/**
 * A class abstracting Signature Method.
 * http://tools.ietf.org/html/rfc5849#section-3.4
 */
class SignatureMethod {
  final String _name;
  final Sign _sign;

  /// A constructor of SignatureMethod.
  SignatureMethod(this._name, this._sign);

  /// Signature Method Name
  String get name => _name;

  /// Sign data by key.
  String sign(String key, String text) => _sign(key, text);
}

/**
 * A abstract class contains Signature Methods.
 */
abstract class SignatureMethods {
  /// http://tools.ietf.org/html/rfc5849#section-3.4.2
  static final SignatureMethod HMAC_SHA1 = new SignatureMethod("HMAC-SHA1", (key, text) {
    HMAC hmac = new HMAC(new SHA1(), key.codeUnits);
    hmac.add(text.codeUnits);

    // The output of the HMAC signing function is a binary
    // string. This needs to be base64 encoded to produce
    // the signature string.
    return CryptoUtils.bytesToBase64(hmac.close());
  });

  /// http://tools.ietf.org/html/rfc5849#section-3.4.3
  /// TODO: Implement RSA-SHA1

  /// http://tools.ietf.org/html/rfc5849#section-3.4.4
  static final SignatureMethod PLAINTEXT = new SignatureMethod("PLAINTEXT", (key, text) {
    return key;
  });
}

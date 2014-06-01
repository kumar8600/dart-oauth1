library signature_method;

abstract class SignatureMethod {
  /// Signature Method Name
  String get name;

  /// Sign data by key.
  String sign(String data, String key);
}

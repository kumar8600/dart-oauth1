part of oauth1;

/**
 * A class abstracts OAuth credentials. 
 */
abstract class OAuth1AbstractCredentials {
  String get token;
  String get tokenSecret;
}

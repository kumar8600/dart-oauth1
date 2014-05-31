part of oauth1;

abstract class OAuth1Utils {
  static final _uuid = new Uuid();

  /**
   * Create signature in ways referred from
   *   https://dev.twitter.com/docs/auth/creating-signature.
   */
  static String _createSignature(String method, String url, Map<String, String>
      params, String consumerSecret, [String tokenSecret]) {
    // Referred from https://dev.twitter.com/docs/auth/creating-signature
    if (params.isEmpty) {
      throw new ArgumentError("params is empty.");
    }

    //
    // Collecting parameters
    //

    // 1. Percent encode every key and value
    //    that will be signed.
    Map<String, String> encodedParams = new HashMap<String, String>();
    params.forEach((k, v) {
      encodedParams[Uri.encodeComponent(k)] = Uri.encodeComponent(v);
    });

    // 2. Sort the list of parameters alphabetically[1]
    //    by encoded key[2].
    List<String> sortedEncodedKeys = encodedParams.keys.toList()..sort();

    // 3. For each key/value pair:
    // 4. Append the encoded key to the output string.
    // 5. Append the '=' character to the output string.
    // 6. Append the encoded value to the output string.
    // 7. If there are more key/value pairs remaining,
    //    append a '&' character to the output string.
    String baseParams = sortedEncodedKeys.map((k) {
      return '$k=${encodedParams[k]}';
    }).join('&');

    //
    // Creating the signature base string
    //

    StringBuffer base = new StringBuffer();
    // 1. Convert the HTTP Method to uppercase and set the
    //    output string equal to this value.
    base.write(method.toUpperCase());

    // 2. Append the '&' character to the output string.
    base.write('&');

    // 3. Percent encode the URL and append it to the
    //    output string.
    base.write(Uri.encodeComponent(url));

    // 4. Append the '&' character to the output string.
    base.write('&');

    // 5. Percent encode the parameter string and append it
    //    to the output string.
    base.write(Uri.encodeComponent(baseParams.toString()));

    //
    // Getting a signing key
    //

    // The signing key is simply the percent encoded consumer
    // secret, followed by an ampersand character '&',
    // followed by the percent encoded token secret:
    String signingKey =
        "${Uri.encodeComponent(consumerSecret)}&${tokenSecret == null? "" : Uri.encodeComponent(tokenSecret)}";

    print(base.toString());
    //
    // Calculating the signature
    //
    HMAC hmac = new HMAC(new SHA1(), signingKey.codeUnits);
    hmac.add(base.toString().codeUnits);

    // The output of the HMAC signing function is a binary
    // string. This needs to be base64 encoded to produce
    // the signature string.
    return CryptoUtils.bytesToBase64(hmac.close());
  }

  /**
   * Set Authorization header to request.
   * 
   * Below parameters are provided default values:
   * - oauth_signature_method
   * - oauth_signature
   * - oauth_timestamp
   * - oauth_nonce
   * - oauth_version
   * 
   * Below parameters are provided by your parameter are passed to this function:
   * - oauth_consumer_key
   * - oauth_token
   * - oauth_token_secret
   * 
   * You can add parameters by params. (You can override too.)
   */
  static void _setAuthorizationHeader(HttpRequest request, String method, String
      url, Map<String, String> params, OAuth1ClientCredentials
      clientCredentials, [OAuth1AbstractCredentials credentials]) {
    Map<String, String> _params = new HashMap();

    _params['oauth_nonce'] = _uuid.v1();
    _params['oauth_signature_method'] = 'HMAC-SHA1';
    _params['oauth_timestamp'] = (new DateTime.now().millisecondsSinceEpoch /
        1000).floor().toString();
    _params['oauth_consumer_key'] = clientCredentials.token;
    _params['oauth_version'] = '1.0';
    if (credentials != null) {
      _params['oauth_token'] = credentials.token;
    }
    _params.addAll(params);
    if (!_params.containsKey('oauth_signature')) {
      _params['oauth_signature'] = OAuth1Utils._createSignature('POST', url,
          _params, clientCredentials.tokenSecret, credentials != null ?
          credentials.tokenSecret : null);
    }

    String authHeader = 'OAuth ' + _params.keys.map((k) {
      return '$k="${Uri.encodeComponent(_params[k])}"';
    }).join(', ');
    request.setRequestHeader('Authorization', authHeader);
  }

  /**
   * Return HttpRequest object of OAuth request.
   */
  static HttpRequest _createRequest(OAuth1ClientCredentials
      clientCredentials, OAuth1AbstractCredentials credentials, String method, String
      url, [Map<String, String> params, Map data]) {
    var request = new HttpRequest();
    request.open(method, url);
    OAuth1Utils._setAuthorizationHeader(request, method, url, params,
        clientCredentials, credentials);
    return request;
  }

  /**
   * Return Future object that will fire when it get response of your request.
   */
  static Future<String> _request(OAuth1ClientCredentials
      clientCredentials, OAuth1AbstractCredentials credentials, String method, String
      url, [Map<String, String> params, Map data]) {
    var completer = new Completer<Map<String, String>>();

    var request = _createRequest(clientCredentials, credentials, method, url,
        params, data);
    request.onLoad.listen((event) {
      completer.complete((event.target as HttpRequest).responseText);
    });
    request.send(data);

    return completer.future;
  }

  /**
   * Return Map object of parsed parameters from
   * OAuth Service Provider Response Parameters.
   */
  static Map<String, String> _parseResponseParameters(String response) {
    Map<String, String> result = new HashMap();
    response.split('&').forEach((p) {
      Iterable keyValue = p.split('=').map(Uri.encodeComponent);
      result[keyValue.first] = keyValue.length > 1 ? keyValue.elementAt(1) : "";
    });
    return result;
  }

  /**
   * Return new Map object removed elements that have key equals keys elements from map.
   */
  static Map _differenceMapKeys(Map map, List keys) {
    Set keysDifference = map.keys.toSet().difference(keys.toSet());
    return new Map.fromIterable(keysDifference, value: (item) => map[item]);
  }
}

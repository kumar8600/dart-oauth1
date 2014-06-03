library authorization_test;

import 'package:unittest/unittest.dart';
import 'package:http/http.dart' as http;
import 'package:oauth1/oauth1.dart';

void main() {
  const String apiKey = 'LLDeVY0ySvjoOVmJ2XgBItvTV';
  const String apiSecret = 'JmEpkWXXmY7BYoQor5AyR84BD2BiN47GIBUPXn3bopZqodJ0MV';
  ClientCredentials clientCredentials = new ClientCredentials(apiKey, apiSecret);

  test('request temporary credentials', () {
    Authorization auth = new Authorization(clientCredentials, Platforms.TWITTER1_1, new http.Client());
    return auth.requestTemporaryCredentials();
  });
}

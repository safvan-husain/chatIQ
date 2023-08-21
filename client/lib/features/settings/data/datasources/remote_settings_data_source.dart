import 'package:client/core/error/exception.dart';
import 'package:http/http.dart' as http;

import '../../../../constance/constant_variebles.dart';
class RemoteSettingDataSource {final http.Client client;

  RemoteSettingDataSource(this.client);
  Future<bool> deleteData(String authToken) async {
    try {
       http.Response response = await client.delete(
      Uri.parse('$uri/message'),
      headers: <String, String>{
        'content-type': 'application/json; charset=utf-8',
        'x-auth-token': authToken,
      },
    );
    if(response.statusCode == 200) {
      return true;
    }
    return false;

    } catch (e) {
      throw ServerException();
    }
  }
}

import 'package:dio/dio.dart';

import 'constants.dart' as constants;

final dio = Dio(
  BaseOptions(
    validateStatus: (status) {
      return status! < 500;
    },
  ),
);

addToken(String token) async {
  await dio.post(
    constants.addTokenUrl,
    data: {
      "token": token,
    },
    options: Options(contentType: 'application/json; charset=utf-8'),
  );
}

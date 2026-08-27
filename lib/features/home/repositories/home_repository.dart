import 'dart:io';

import 'package:client/core/constants/server_constant.dart';
import 'package:http/http.dart' as http;

class HomeRepository {
  Future<void> uploadSong(File selectedImage, File selectedAudio) async {
    final request = http.MultipartRequest(
      'POST',
      Uri.parse('${ServerConstant.serverUrl}/song/upload'),
    );
    request
      ..files.addAll([
        await http.MultipartFile.fromPath('song', selectedAudio.path),
        await http.MultipartFile.fromPath('thumbnail', selectedImage.path),
      ])
      ..fields.addAll({
        'artist': 'Taylor',
        'song_name': 'poorya',
        'hex_code': 'FFFFF',
      })
      ..headers.addAll({
        'x-auth-token':
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjNjNWRmMjQ3LWU3OTktNDAxZi05ODcyLTdhZjExMjAzNzY4YyJ9.fqgx2eHMoucdK5qqPluFOAr97oikrfzFisoWj9LwlqM',
      });
    final res = request.send();
    print(res);
  }
}

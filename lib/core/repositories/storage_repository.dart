
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class StorageRepository {
  // Use getters to fetch latest env vars in case of hot restart issues, 
  // or just final variables if we trust dotenv.load() runs once.
  String get _cloudName => dotenv.env['CLOUDINARY_CLOUD_NAME'] ?? '';
  String get _uploadPreset => dotenv.env['CLOUDINARY_UPLOAD_PRESET'] ?? '';

  Future<String?> uploadImage(XFile imageFile) async {
    if (_cloudName.isEmpty || _cloudName == 'YOUR_CLOUD_NAME_HERE') {
      // print('Cloud Name not set in .env');
      return null; 
    }

    try {
      final url = Uri.parse('https://api.cloudinary.com/v1_1/$_cloudName/image/upload');
      
      final request = http.MultipartRequest('POST', url)
        ..fields['upload_preset'] = _uploadPreset
        ..files.add(await http.MultipartFile.fromPath('file', imageFile.path));

      final response = await request.send();

      if (response.statusCode == 200) {
        final responseData = await response.stream.toBytes();
        final responseString = String.fromCharCodes(responseData);
        final jsonMap = jsonDecode(responseString);
        return jsonMap['secure_url'];
      } else {
        // print('Upload failed: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      // print('Error uploading image: $e');
      return null;
    }
  }
  
  Future<List<String>> uploadImages(List<XFile> images) async {
    List<String> urls = [];
    for (var i in images) {
      final url = await uploadImage(i);
      if (url != null) {
        urls.add(url);
      }
    }
    return urls;
  }
}

final storageRepositoryProvider = Provider<StorageRepository>((ref) {
  return StorageRepository();
});

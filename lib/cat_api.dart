import 'package:http/http.dart' as http;
import 'dart:convert';

Future<Map<String, dynamic>> fetchCatWithBreed() async {
  final response = await http.get(
    Uri.parse('https://api.thecatapi.com/v1/images/search'),
    headers: {
      'x-api-key': 'live_7fDMTkbCmWdi4j4A98anHw9i04YbHp4Iqhx8nJ8NgLYOhOCFsUZzFPbPWwQ6Zxti',
    },
  );

  if (response.statusCode == 200) {
    final List<dynamic> data = json.decode(response.body);

    if (data.isNotEmpty &&
        data[0]['breeds'] != null &&
        (data[0]['breeds'] as List).isNotEmpty) {
      return data[0];
    } else {
      // Повторяем запрос, пока не найдём кота с породой
      return fetchCatWithBreed();
    }
  } else {
    throw Exception('Failed to load cat image');
  }
}

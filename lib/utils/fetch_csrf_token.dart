import 'package:http/http.dart' as http;

Future<String> fetchCsrfToken(String apiUrl) async {
  String csrfToken = "";
  final url = Uri.parse(apiUrl);
  final response = await http.get(url);

  if (response.statusCode == 200) {
    // 쿠키에서 csrf 토큰을 추출
    String? rawCookie = response.headers['set-cookie'];
    int start = rawCookie!.indexOf('csrftoken=');
    if (start != -1) {
      int end = rawCookie.indexOf(';', start);
      csrfToken = rawCookie.substring(start + 10, end);
    }
  } else {
    // print('STOP');
  }

  return csrfToken;
}

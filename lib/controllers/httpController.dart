import 'package:firebase_performance/firebase_performance.dart';
import 'package:http/http.dart' as http;

class HttpController {

  static Future<http.Response> get(requestUrl, [Map<String, String> headers = const {"Accept": "application/json"}]) async {
    final HttpMetric metric = FirebasePerformance.instance
            .newHttpMetric(requestUrl, HttpMethod.Get);
    
    await metric.start();
    try{
      http.Response res = await http.get(requestUrl, headers: headers);
      metric
        ..responsePayloadSize = res.contentLength
        ..responseContentType = res.headers['Content-Type']
        ..requestPayloadSize = res.contentLength
        ..httpResponseCode = res.statusCode;
      return res;
    }catch (e) {
      print(e.toString());
    }finally {
      await metric.stop();
    }
    return null;
  }
}
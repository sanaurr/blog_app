import 'dart:convert';
import 'dart:developer';

import 'package:blog_app/models/blogmodel.dart';
import 'package:blog_app/models/user.dart';
import 'package:http/http.dart';

Future<List<BlogModel>> allBlogs(String category) async {
  const String apiurl = "https://blog-server-sanaur-rahamans-projects.vercel.app/posts";
  // const String apiurl = "http://192.168.100.113:3000/posts";
  try {
    final response = await get(Uri.parse("$apiurl/category/$category"));
    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      List<BlogModel> allblogs = data.map((item) => BlogModel.fromJson(item)).toList();
      return allblogs;
    }
  } catch (e) {
    log("Error: $e");
    rethrow;
  }
  return [];
}

Future<bool> signup(Map<String, String> data, User user) async {
  const String apiurl = "https://blog-server-sanaur-rahamans-projects.vercel.app/users/";

  var request = MultipartRequest('POST', Uri.parse(apiurl));
  request.fields.addAll(data);

  var response = await request.send();

  if (response.statusCode == 200) {
    var data = await response.stream.bytesToString();
    return user.login(jsonDecode(data));
  } else {
    log("Error: ${response.reasonPhrase}");
  }
  return false;
}

Future<bool> login(Map<String, String> data, User user) async {
  const String apiurl = "https://blog-server-sanaur-rahamans-projects.vercel.app/login";
  // const String apiurl = "http://192.168.100.113:3000/login";

  log("Login: $data");
  log("Login: $user");

  var request = MultipartRequest('POST', Uri.parse(apiurl));
  request.fields.addAll(data);

  var response = await request.send();

  if (response.statusCode == 200) {
    var data = await response.stream.bytesToString();
    log("Login: $data");
    return user.login(jsonDecode(data));
  } else {
    log("Error: ${response.reasonPhrase}");
  }
  return false;
}

Future<bool> logout(User user) async {
  user.logout();
  return true;
}

Future<bool> createBlog(Map<String, String> data, User user) async {
  const String apiurl = "https://blog-server-sanaur-rahamans-projects.vercel.app/posts/";
  // const String apiurl = "http://192.168.100.113:3000/posts/";
  var request = MultipartRequest('POST', Uri.parse(apiurl));
  log(user.accessToken);
  log(data.values.toString());
  request.fields.addAll(data);
  request.headers.addAll({
    'Authorization': user.accessToken,
    'Content-Type': 'multipart/form-data',
  });
  var response = await request.send();
  if (response.statusCode == 200) {
    return true;
  } else {
    log("Error: ${response.reasonPhrase}");
  }
  return false;
}

Future<bool> deleteBlog(String id, User user) async {
  String apiurl = "https://blog-server-sanaur-rahamans-projects.vercel.app/posts/$id";
  final response = await delete(
    Uri.parse(apiurl),
    headers: {
      'Authorization': user.accessToken,
    },
  );
  if (response.statusCode == 200) {
    return true;
  } else {
    log("Error: ${response.reasonPhrase}");
  }
  return false;
}

Future<bool> updateBlog(Map<String, String> data, String id, User user) async {
  String apiurl = "https://blog-server-sanaur-rahamans-projects.vercel.app/posts/$id";
  var request = MultipartRequest('PUT', Uri.parse(apiurl));
  log(data.values.toString());
  request.fields.addAll(data);
  request.headers.addAll({
    'Authorization': user.accessToken,
  });
  var response = await request.send();
  if (response.statusCode == 200) {
    return true;
  } else {
    log("Error: ${response.reasonPhrase}");
  }
  return false;
}

Future<List<BlogModel>> getBlogsByUser(String id) async {
  String apiurl = "https://blog-server-sanaur-rahamans-projects.vercel.app/posts/user/$id";
  final response = await get(Uri.parse(apiurl));
  if (response.statusCode == 200) {
    List<dynamic> data = jsonDecode(response.body);
    List<BlogModel> allblogs = data.map((item) => BlogModel.fromJson(item)).toList();
    return allblogs;
  } else {
    log("Error: ${response.reasonPhrase}");
  }
  return [];
}

Future<List<BlogModel>> getLatestBlogs() async {
  const String apiurl = "https://blog-server-sanaur-rahamans-projects.vercel.app/posts";
  // const String apiurl = "http://192.168.100.113:3000/posts";
  try {
    final response = await get(Uri.parse("$apiurl/latest/${10}"));
    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      List<BlogModel> allblogs = data.map((item) => BlogModel.fromJson(item)).toList();
      return allblogs;
    }
  } catch (e) {
    log("Error: $e");
    rethrow;
  }
  return [];
}

Future<Map<String, dynamic>?> generateWithPookie(String topic, String category, int length, String accessToken) async {
  const String apiUrl = "https://blog-server-sanaur-rahamans-projects.vercel.app/assistant/generate";

  if (accessToken.isEmpty || topic.isEmpty || category.isEmpty || length <= 0) {
    return null;
  }

log("creating request");
  // Create multipart request
  var request = MultipartRequest('POST', Uri.parse(apiUrl));

  // Add fields (form-data)
  request.fields['topic'] = topic;
  request.fields['category'] = category;
  request.fields['length'] = length.toString();

  // Add headers
  request.headers['Authorization'] = accessToken;
  request.headers['Content-Type'] = 'multipart/form-data';

  try {
    // Send request
    log(request.fields.toString(), name: "sending request");
    var streamedResponse = await request.send();

    // Convert to Response to read body
    var response = await Response.fromStream(streamedResponse);

    if (response.statusCode == 200) {
      // Return decoded response text (JSON or plain string depending on your backend)
      var decodedResponse = jsonDecode(response.body);
      // log(decodedResponse.toString(), name: "response from generate ai");
      return decodedResponse;
    } else {
      log("Error: ${response.statusCode} => ${response.body}");
      return null;
    }
  } catch (e) {
    log("Exception from service: $e");
    return null;
  }
}
Future<Map<String, dynamic>?> editWithPookie(String category, String title, String content, int length, String instruction, String accessToken) async {
  const String apiUrl = "https://blog-server-sanaur-rahamans-projects.vercel.app/assistant/edit";

  if (accessToken.isEmpty || instruction.isEmpty || category.isEmpty || length <= 0) {
    return null;
  }

log("creating edit request");
  // Create multipart request
  var request = MultipartRequest('POST', Uri.parse(apiUrl));

  // Add fields (form-data)
  request.fields['instruction'] = instruction;
  request.fields['category'] = category;
  request.fields['title'] = title;
  request.fields['content'] = content;
  request.fields['length'] = length.toString();

  // Add headers
  request.headers['Authorization'] = accessToken;
  request.headers['Content-Type'] = 'multipart/form-data';

  try {
    // Send request
    log(request.fields.toString(), name: "sending edit request");
    var streamedResponse = await request.send();

    // Convert to Response to read body
    var response = await Response.fromStream(streamedResponse);

    if (response.statusCode == 200) {
      // Return decoded response text (JSON or plain string depending on your backend)
      var decodedResponse = jsonDecode(response.body);
      // log(decodedResponse.toString(), name: "response from generate ai");
      return decodedResponse;
    } else {
      log("Error from service editbyai: ${response.statusCode} => ${response.body}");
      return null;
    }
  } catch (e) {
    log("Exception from service edit by ai: $e");
    return null;
  }
}

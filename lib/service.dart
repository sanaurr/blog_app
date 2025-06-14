import 'dart:convert';
import 'dart:developer';

import 'package:blog_app/models/blogmodel.dart';
import 'package:blog_app/models/user.dart';
import 'package:http/http.dart';

Future<List<BlogModel>> allBlogs() async{
  
  const String apiurl = "https://blog-server-sanaur-rahamans-projects.vercel.app/posts";
  // const String apiurl = "http://192.168.100.113:3000/posts";
  try {
    final response = await get(Uri.parse(apiurl));
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

Future<bool> signup(Map<String, String> data, User user) async{
  const String apiurl = "https://blog-server-sanaur-rahamans-projects.vercel.app/users/";
  
var request = MultipartRequest('POST', Uri.parse(apiurl));
request.fields.addAll(data);

var response = await request.send();

if (response.statusCode == 200) {
  var data =await response.stream.bytesToString();
 return user.login(jsonDecode(data));

}
else {
  log("Error: ${response.reasonPhrase}");
}
return false;
}

Future<bool> login(Map<String, String> data, User user) async{
  const String apiurl = "https://blog-server-sanaur-rahamans-projects.vercel.app/login";
  // const String apiurl = "http://192.168.100.113:3000/login";

  log("Login: $data");
  log("Login: $user");
  
var request = MultipartRequest('POST', Uri.parse(apiurl));
request.fields.addAll(data);

var response = await request.send();

if (response.statusCode == 200) {
  var data =await response.stream.bytesToString();
  log("Login: $data");
 return user.login(jsonDecode(data));

}
else {
  log("Error: ${response.reasonPhrase}");
}
return false;
}

Future<bool> logout(User user) async{
  user.logout();
  return true;
}

Future<bool> createBlog(Map<String, String> data, User user) async{
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
  }
  else {
    log("Error: ${response.reasonPhrase}");
  }
  return false;
}

Future<bool> deleteBlog(String id, User user) async{
  String apiurl = "https://blog-server-sanaur-rahamans-projects.vercel.app/posts/$id";
   final response = await delete(
      Uri.parse(apiurl),
      headers: {
        'Authorization': user.accessToken,
      },
    );
  if (response.statusCode == 200) {
    return true;
  }
  else {
    log("Error: ${response.reasonPhrase}");
  }
  return false;
}

Future<bool> updateBlog(Map<String, String> data, String id, User user) async{
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
  }
  else {
    log("Error: ${response.reasonPhrase}");
  }
  return false;
}

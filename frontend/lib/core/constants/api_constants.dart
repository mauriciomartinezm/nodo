import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConstants {
  static String get baseUrl => dotenv.env['API_BASE_URL']!;

  static String get login => "$baseUrl/login";
  static String get createUser => "$baseUrl/createUser";
  static String updateUser(String id) => "$baseUrl/updateUser/$id";
  static String getUser(String id) => "$baseUrl/getUser/$id";
  static String get getWorkerByUserId => "$baseUrl/getWorkerByUserId";

  static String get createPost => "$baseUrl/createPost";
  static String get getPosts => "$baseUrl/getPosts";
  static String getPostsByUserId(String id) => "$baseUrl/getPostsByUserId/$id";
  static String updatePost(String id) => "$baseUrl/updatePost/$id";
  static String deletePost(String id) => "$baseUrl/deletePost/$id";

  static String get getCategories => "$baseUrl/getCategories";
  static String getCategory(String id) => "$baseUrl/getCategory/$id";
  static String get createUserCategory => "$baseUrl/createUserCategory";

  static String get apply => "$baseUrl/apply";
  static String get finishJob => "$baseUrl/finishJob";
  static String getApplicationsByPostId(String id) =>
      "$baseUrl/getApplicationsByPostId/$id";
  static String getApplicationsByUserId(String id) =>
      "$baseUrl/getApplicationsByUserId/$id";
  static String updateApplication(String id) =>
      "$baseUrl/updateApplication/$id";
  static String deleteApplication(String id) =>
      "$baseUrl/deleteApplication/$id";

  static String getNotificationsByUserId(String id) =>
      "$baseUrl/getNotificationsByUserId/$id";
  static String get saveToken => "$baseUrl/saveToken";
  static String get deleteToken => "$baseUrl/deleteToken";

  static String get createReport => "$baseUrl/createReport";

  static String generateUploadUrl(String fileName, String contentType) =>
      "$baseUrl/generateUploadUrl?fileName=$fileName&contentType=$contentType";
}

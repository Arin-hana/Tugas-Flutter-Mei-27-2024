import 'package:retrofit/retrofit.dart';
import '../models/post_model.dart';
import 'package:retrofit/http.dart';
import 'package:dio/dio.dart';
//©Arin Hanabi

part 'api_service.g.dart';

@RestApi(baseUrl: 'http://10.0.2.2/flutterendpoint/')
abstract class ApiService {
  factory ApiService(Dio dio) = _ApiService;

  @GET('list.php')
  Future<List<PostModel>> getList();

  @DELETE('delete.php')
  Future<void> deleteData(@Body() String setid);

  @PUT('update.php')
  Future<void> updateData(@Body() Map<String, dynamic> post);

  @PUT('create.php')
  Future<void> createData(@Body() Map<String, dynamic> post);
}

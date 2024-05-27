import 'package:exam2/pages/create.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import './service/api_service.dart';
import './models/post_model.dart';
import 'pages/edit.dart';
//©Arin Hanabi

enum PopupItem { itemOne, itemTwo }

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: DisplayData());
  }
}

class DisplayData extends StatefulWidget {
  const DisplayData({super.key});

  @override
  State<DisplayData> createState() => _DisplayDataState();
}

class _DisplayDataState extends State<DisplayData> {
  PopupItem? popupItem;
  late ApiService apiService;
  Future<List<PostModel>>? futurePosts;

  @override
  void initState() {
    super.initState();
    final dio = Dio();
    dio.options.headers['Content-Type'] = 'application/json';
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        print(
            'Request[${options.method}] => PATH: ${options.path} | QUERY: ${options.queryParameters}');
        return handler.next(options);
      },
      onResponse: (response, handler) {
        print('Response[${response.statusCode}] => DATA: ${response.data}');
        return handler.next(response);
      },
      onError: (DioException e, handler) {
        print('Error[${e.response?.statusCode}] => MESSAGE: ${e.message}');
        return handler.next(e);
      },
    ));
    apiService = ApiService(dio);
    futurePosts = apiService.getList();
    dio.interceptors.add(LogInterceptor(responseBody: true));
  }

  void refresh() {
    setState(() {
      futurePosts = apiService.getList(); // Refresh the list
    });
  }

  Future<void> deleteData(String setid) async {
    try {
      await apiService.deleteData(setid);
      refresh();
    } catch (e) {
      print('Error deleting post: $e');
    }
  }

  Future<void> editData(PostModel data) async {
    final updatedPost = await Navigator.push<PostModel>(
      context,
      MaterialPageRoute(
        builder: (context) => EditPostScreen(data: data),
      ),
    );
    if (updatedPost != null) {
      refresh();
    }
  }

  Future<void> createData() async {
    final updatedPost = await Navigator.push<PostModel>(
      context,
      MaterialPageRoute(
        builder: (context) => const CreateData(),
      ),
    );
    if (updatedPost != null) {
      refresh();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Exam Flutter 27/05/2024'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () async {
              refresh();
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await createData();
        },
        child: const Icon(Icons.add),
      ),
      body: FutureBuilder<List<PostModel>>(
        future: futurePosts,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final data = snapshot.data!;
            return ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) {
                final displayData = data[index];
                return Container(
                    // color: const Color.fromARGB(255, 221, 231, 245),
                    padding: const EdgeInsets.all(10),
                    margin: const EdgeInsets.only(
                        left: 10, right: 10, bottom: 4, top: 4),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: const Color.fromARGB(255, 221, 231, 245),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 10, right: 10, top: 0, bottom: 20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 10, bottom: 10),
                            child: Row(
                              children: [
                                Text(
                                  displayData.name,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 16),
                                ),
                                const Spacer(),
                                PopupMenuButton<PopupItem>(
                                  initialValue: popupItem,
                                  onSelected: (PopupItem items) {
                                    setState(() {
                                      popupItem = items;
                                    });
                                  },
                                  itemBuilder: (BuildContext context) =>
                                      <PopupMenuEntry<PopupItem>>[
                                    PopupMenuItem<PopupItem>(
                                      value: PopupItem.itemOne,
                                      child: const Text("Edit"),
                                      onTap: () async {
                                        final updated = await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                EditPostScreen(
                                                    data: displayData),
                                          ),
                                        );
                                        if (updated != null) {
                                          refresh();
                                        }
                                      },
                                    ),
                                    PopupMenuItem<PopupItem>(
                                      value: PopupItem.itemTwo,
                                      child: const Text("Delete"),
                                      onTap: () => showDialog<String>(
                                        context: context,
                                        builder: (BuildContext context) =>
                                            AlertDialog(
                                          title: const Text('Hapus data?'),
                                          actions: <Widget>[
                                            TextButton(
                                              onPressed: () => Navigator.pop(
                                                  context, 'Cancel'),
                                              child: const Text('Cancel'),
                                            ),
                                            TextButton(
                                              onPressed: () async {
                                                await deleteData(
                                                    "id=${displayData.id}");
                                                print(displayData.id);
                                                Navigator.pop(
                                                    context, 'Cancel');
                                              },
                                              child: const Text('OK'),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                          Text("Salary : Rp. ${displayData.salary}"),
                          Text("Age : ${displayData.age}")
                        ],
                      ),
                    ));
              },
            );
          } else {
            return const Center(child: Text('No data'));
          }
        },
      ),
    );
  }
}

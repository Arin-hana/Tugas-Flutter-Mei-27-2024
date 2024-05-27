import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../service/api_service.dart';
import '../models/post_model.dart';
//©Arin Hanabi

class EditPostScreen extends StatefulWidget {
  final PostModel data;

  const EditPostScreen({super.key, required this.data});

  @override
  _EditPostScreenState createState() => _EditPostScreenState();
}

class _EditPostScreenState extends State<EditPostScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _salaryController;
  late TextEditingController _ageController;
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
    dio.interceptors.add(LogInterceptor(responseBody: true));
    futurePosts = apiService.getList();
    _nameController = TextEditingController(text: widget.data.name);
    _salaryController =
        TextEditingController(text: widget.data.salary.toString());
    _ageController = TextEditingController(text: widget.data.age.toString());
  }

  @override
  void dispose() {
    _nameController.dispose();
    _salaryController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  Future<void> _saveEmployee() async {
    if (_formKey.currentState!.validate()) {
      try {
        final updatedData = {
          'id': widget.data.id,
          'name': _nameController.text,
          'salary': int.parse(_salaryController.text),
          'age': int.parse(_ageController.text),
        };
        await apiService.updateData(updatedData);
        Navigator.of(context).pop();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error updating employee: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Employee'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _salaryController,
                decoration: const InputDecoration(labelText: 'Salary'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a salary';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _ageController,
                decoration: const InputDecoration(labelText: 'Age'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an age';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveEmployee,
                child: const Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

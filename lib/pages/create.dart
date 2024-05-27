import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../service/api_service.dart';
//©Arin Hanabi

class CreateData extends StatefulWidget {
  const CreateData({super.key});

  @override
  _CreateDataState createState() => _CreateDataState();
}

class _CreateDataState extends State<CreateData> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _salaryController;
  late TextEditingController _ageController;
  late ApiService apiService;

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
    _nameController = TextEditingController();
    _salaryController = TextEditingController();
    _ageController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _salaryController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  Future<void> _createData() async {
    if (_formKey.currentState!.validate()) {
      try {
        final newData = {
          'id': 0, // Assuming the ID will be set by the server
          'name': _nameController.text,
          'salary': int.parse(_salaryController.text),
          'age': int.parse(_ageController.text),
        };
        await apiService.createData(newData);
        Navigator.of(context).pop();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error creating employee: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Employee'),
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
                onPressed: _createData,
                child: const Text('Create'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  final dio = Dio(
    BaseOptions(
      baseUrl: "http://127.0.0.1:8000/api",
      headers: {
        "Accept": "application/json",
      },
    ),
  );

  List items = [];

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchItems();
    });
  }

  Future<void> fetchItems() async {
    final response = await dio.get("/items");

    setState(() {
      items = response.data;
    });
  }

  Future<void> createItem() async {
    final response = await dio.post("/items", data: {
      "name": "test",
      "description": "test",
    });
    fetchItems();
  }

  Future<void> updateItem(int id) async {
    final response = await dio.put("/items/$id", data: {
      "name": "(updated) test",
      "description": "sudah diupdate",
    });
    fetchItems();
  }

  Future<void> deleteItem(int id) async {
    final response = await dio.delete("/items/$id");
    fetchItems();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text("items"),
          centerTitle: false,
        ),
        body: ListView.builder(
          itemCount: items.length,
          itemBuilder: (context, index) => ListTile(
            title: Text(items[index]["name"]),
            subtitle: Text(items[index]["description"]),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () => updateItem(items[index]["id"]),
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => deleteItem(items[index]["id"]),
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: createItem,
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}

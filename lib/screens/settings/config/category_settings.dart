import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:jspos/screens/settings/controller/category_controller.dart';

class CategorySettings extends StatefulWidget {
  const CategorySettings({super.key});

  @override
  CategorySettingsState createState() => CategorySettingsState();
}

class CategorySettingsState extends State<CategorySettings> {
  final _formKey = GlobalKey<FormBuilderState>();
  List<String> categories = [];

  @override
  void initState() {
    super.initState();
    loadCategories();
  }

  void loadCategories() async {
    categories = CategoryController.getCategories();
    // var controllers = categories.map((_) => TextEditingController()).toList();
    // log('$categories');
    // log('$controllers');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Categories'),
      ),
      body: FormBuilder(
        key: _formKey,
        child: ListView.builder(
          itemCount: categories.length,
          itemBuilder: (context, index) {
            return ListTile(
              leading: Text((index + 1).toString()),
              title: Row(
                children: [
                  Text(categories[index]),
                  Expanded(
                    child: FormBuilderTextField(
                      name: 'category_$index',
                      // initialValue: categories[index],
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      onChanged: (value) {
                        if (value != null) {
                          categories[index] = value;
                          CategoryController.setCategories(categories);
                        }
                      },
                    ),
                  ),
                ],
              ),
              trailing: index >= 3
                  ? IconButton(
                      icon: const Icon(Icons.remove_circle, color: Colors.red),
                      onPressed: () {
                        setState(() {
                          categories.removeAt(index);
                        });
                        CategoryController.setCategories(categories);
                      },
                    )
                  : null,
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          setState(() {
            categories.add("");
          });
        },
      ),
    );
  }
}

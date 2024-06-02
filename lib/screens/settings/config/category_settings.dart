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
  }

  Widget _buildTextField(int index) {
    return Expanded(
      child: ListTile(
        leading: Text(
          (index + 1).toString(),
          style: const TextStyle(fontSize: 14, color: Colors.white),
        ),
        title: FormBuilderTextField(
          name: 'category_$index',
          initialValue: categories[index],
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
              if (value.isNotEmpty) {
                categories[index] = value;
                CategoryController.setCategories(categories);
              }
            }
          },
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
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xff1f2029),
      ),
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
      margin: const EdgeInsets.fromLTRB(10, 20, 10, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                const Text(
                  'Categories',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                const SizedBox(width: 10),
                InkWell(
                  onTap: () {
                    if (categories.length < 5) {
                      setState(() {
                        categories.add("");
                      });
                      log('categories: $categories');
                    } else {
                      log("Maximum number of categories reached");
                    }
                  },
                  child: Container(
                    height: 30,
                    width: 30,
                    decoration: const BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                    ),
                    padding: const EdgeInsets.all(0),
                    child: const Icon(Icons.add, color: Colors.white, size: 20),
                  ),
                )
              ],
            ),
          ),
          Expanded(
            child: FormBuilder(
              key: _formKey,
              child: ListView.builder(
                itemCount: (categories.length / 2).ceil(),
                itemBuilder: (context, index) {
                  int first = index * 2;
                  int second = first + 1;
                  return Row(
                    children: [
                      _buildTextField(first),
                      if (second < categories.length) _buildTextField(second),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}


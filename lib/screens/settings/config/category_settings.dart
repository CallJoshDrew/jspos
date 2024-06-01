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
    List<String> uiCategories = List<String>.from(categories);
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
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Categories',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                const SizedBox(width: 10),
                InkWell(
                  onTap: () {
                    if (uiCategories.length < 5) {
                      // limit to 5 categories
                      setState(() {
                        uiCategories.add("");
                      });
                      log('uiCategories: ${uiCategories}'); // log the UI categories
                    } else {
                      log("Maximum number of categories reached"); // replace with your own error handling
                    }
                  },
                  child: Container(
                    height: 30,
                    width: 30,
                    decoration: const BoxDecoration(
                      color: Colors.green, // background color
                      shape: BoxShape.circle,
                    ),
                    padding: const EdgeInsets.all(0), // adjust padding as needed
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
                itemCount: uiCategories.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: Text(
                      (index + 1).toString(),
                      style: const TextStyle(fontSize: 14, color: Colors.white),
                    ),
                    title: FormBuilderTextField(
                      name: 'category_$index',
                      initialValue: uiCategories[index],
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      onChanged: (value) {
                        if (value != null) {
                          uiCategories[index] = value;
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

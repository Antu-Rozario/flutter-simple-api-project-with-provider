import 'package:api_project/models/category.dart';
import 'package:api_project/widgets/categoryAdd.dart';
import 'package:api_project/widgets/categoryEdit.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import '../providers/categoryProvider.dart';

// http://127.0.0.1:8000/api/categories


class Categories extends StatefulWidget {
  const Categories({super.key});

  @override
  State<Categories> createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CategoryProvider>(context);
    List<Category> categories = provider.categories;
    return Scaffold(
      appBar: AppBar(
        title: Text('Categories'),
      ),
      body: ListView.builder(
        itemCount: categories.length,
        itemBuilder: (context, index) {
          Category category = categories[index];
          return Card(
            elevation: 3,
            child: ListTile(
              title: Text(category.name),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          builder: (context) {
                            return CategoryEdit(
                                category, provider.updateCategory);
                          });
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () => showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text('Confirmation'),
                            content: Text('Are you sure you want to delete?'),
                            actions: [
                              TextButton(
                                onPressed: () => deleteCategory(
                                    provider.deleteCategory, category),
                                child: Text('Confirm'),
                              ),
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: Text('Cancel'),
                              ),
                            ],
                          );
                        }),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              builder: (context) {
                return CategoryAdd(provider.addCategory);
              });
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Future deleteCategory(Function callback, Category category) async {
    await callback(category);
    Navigator.pop(context);
  }
}

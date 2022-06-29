import 'package:api_project/models/category.dart';
import 'package:api_project/services/api.dart';
import 'package:flutter/material.dart';

class CategoryEdit extends StatefulWidget {
  final Category category;
  Function categoryUpdateCallback;

  CategoryEdit(this.category, this.categoryUpdateCallback);

  @override
  _CategoryEditState createState() => _CategoryEditState();
}

class _CategoryEditState extends State<CategoryEdit> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final categoryNameController = TextEditingController();
  String errorMessage = '';

  @override
  void initState() {
    categoryNameController.text = widget.category.name;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Form(
        key: _formKey,
        child: Column(children: <Widget>[
          TextFormField(
            onChanged: (text) => setState(() => errorMessage = ''),
            controller: categoryNameController,
            validator: (String? value) {
              if (value!.isEmpty) {
                return 'Enter category name';
              }

              return null;
            },
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Category name',
            ),
          ),
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: ElevatedButton(
                    child: Text('Save'),
                    onPressed: () => saveCategory(),
                  ),
                ),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(primary: Colors.red),
                    child: Text('Cancel'),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
              ]),
          Text(
            errorMessage,
            style: TextStyle(color: Colors.red),
          )
        ]),
      ),
    );
  }

  Future saveCategory() async {
    final form = _formKey.currentState;

    if (!form!.validate()) {
      return;
    }
    widget.category.name=categoryNameController.text;
    await widget.categoryUpdateCallback(widget.category);
    Navigator.pop(context);
  }
}

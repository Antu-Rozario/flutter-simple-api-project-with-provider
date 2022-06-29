import 'package:api_project/models/category.dart';
import 'package:api_project/services/api.dart';
import 'package:flutter/material.dart';

class CategoryAdd extends StatefulWidget {
  Function categoryCallback;

  CategoryAdd(this.categoryCallback);

  @override
  _CategoryAddState createState() => _CategoryAddState();
}

class _CategoryAddState extends State<CategoryAdd> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final categoryNameController = TextEditingController();
  String errorMessage = '';


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
    await widget.categoryCallback(categoryNameController.text);
    Navigator.pop(context);
  }
}

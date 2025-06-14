import 'package:blog_app/models/user.dart';
import 'package:blog_app/service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Createblog extends StatefulWidget {
  const Createblog({super.key});
  

  @override
  State<Createblog> createState() => _CreateblogState();
}

class _CreateblogState extends State<Createblog> {
  String? dropdownValue;
  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();
  final List<String> categories = [
    "Politics",
    "Technology",
    "Health",
    "Education",
    "Finance"
  ];
  @override
  Widget build(BuildContext context) {
    var user = context.watch<User>();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Blog"),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      resizeToAvoidBottomInset: true,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Container(
            color: Theme.of(context).colorScheme.primaryContainer,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      const Text("Categories: "),
                      DropdownButton(
                        hint: const Text("Select Category"),
                        dropdownColor: Theme.of(context).colorScheme.primaryContainer,
                        value: dropdownValue,
                        items: categories.map((category) {
                          return DropdownMenuItem<String>(
                            value: category,
                            child: Text(category),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            dropdownValue = value!;
                          });
                        },
                      ),
                      const Spacer(),
                      ElevatedButton(
                        onPressed: () async{
                          var navigator = Navigator.of(context);
                          var messenger = ScaffoldMessenger.of(context);
                          Map<String, String> blog = {
                            "category": dropdownValue!,
                            "title": titleController.text,
                            "content": contentController.text,
                            "author":  user.name,
                            "authorid": user.id,
                          };
                          var success = await createBlog(blog, user);
                          if (success) {
                            navigator.pop(true);
                          } else {
                            messenger.showSnackBar(const SnackBar(
                              content: Text("Something went wrong!"),
                            ));
                          }
                        },
                        child: const Text("Save"),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  TextField(
                    controller: titleController,
                    maxLines: 1,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Title",
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  TextField(
                    controller: contentController,
                    maxLines: null,
                    minLines: 10,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Content",
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

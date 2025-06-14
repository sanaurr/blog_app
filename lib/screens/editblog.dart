import 'package:blog_app/models/blogmodel.dart';
import 'package:blog_app/models/user.dart';
import 'package:blog_app/service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Editblog extends StatefulWidget {
  const Editblog({super.key, required this.blog});
  final BlogModel blog;

  @override
  State<Editblog> createState() => _EditblogState();
}

class _EditblogState extends State<Editblog> {
  late String dropdownValue;
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
  void initState() {
    super.initState();
    dropdownValue = widget.blog.category;
    titleController.text = widget.blog.title;
    contentController.text = widget.blog.content;
  }

  // @override
  // void dispose() {
  //   titleController.dispose();
  //   contentController.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    var user = context.watch<User>();
    var navigator = Navigator.of(context);
    var messenger = ScaffoldMessenger.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Blog"),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      resizeToAvoidBottomInset: true,
      body: Padding(
        padding: const EdgeInsets.all(5.0),
        child: SingleChildScrollView(
          child: Container(
            color: Theme.of(context).colorScheme.primaryContainer,
            child: Padding(
              padding: const EdgeInsets.all(3.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      const Text("Categories: "),
                      DropdownButton(
                        hint: const Text("Select Category"),
                        dropdownColor:
                            Theme.of(context).colorScheme.primaryContainer,
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
                      // const Spacer(),
                      IconButton(
                        onPressed: () async {
                          var success = await deleteBlog(widget.blog.id, user);
                          if (success) {
                            navigator.pop(true);

                          } else {
                            messenger.showSnackBar(
                              const SnackBar(
                                content: Text("Failed to delete blog"),
                              ),
                            );
                          }
                        },
                        icon: const Icon(Icons.delete_forever),
                      ),
                      ElevatedButton(
                        onPressed: () async{
                          Map<String, String> blog = {
                            "title": titleController.text,
                            "content": contentController.text,
                            "category": dropdownValue,
                            "author": widget.blog.author,
                            "authorid": widget.blog.authorid,
                          };
                          var success = await updateBlog(blog, widget.blog.id, user);
                          if (success) {
                            navigator.pop(true);
                          } else {
                            messenger.showSnackBar(
                              const SnackBar(
                                content: Text("Failed to update blog"),
                              ),
                            );
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
                    minLines: 10,
                    maxLines: null,
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

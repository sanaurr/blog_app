import 'dart:developer';

import 'package:blog_app/models/user.dart';
import 'package:blog_app/providers/loading_provider.dart';
import 'package:blog_app/service.dart';
import 'package:blog_app/widgets/text_editor.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:blog_app/widgets/neu_container.dart';
import 'package:blog_app/widgets/neu_button.dart';
import 'package:blog_app/providers/theme_provider.dart';

class Createblog extends StatefulWidget {
  const Createblog({super.key});

  @override
  State<Createblog> createState() => _CreateblogState();
}

class _CreateblogState extends State<Createblog> {
  String? dropdownValue;
  final TextEditingController titleController = TextEditingController();
  final RichTextEditorController contentController = RichTextEditorController();
  final List<String> categories = [
    "Politics",
    "Technology",
    "Health",
    "Education",
    "Finance",
    "Travel",
  ];
  String? topic;
  @override
  void initState() {
    super.initState();
    titleController.addListener(() => setState(() {}));
    contentController.addListener(() => setState(() {}));
  }

  Future<void> generateByAI(
    String topic,
    String category,
  ) async {
    var accessToken = context.read<User>().accessToken;
    var content = await generateWithPookie(topic, category, 500, accessToken);
    if (content != null) {
      log(content.toString());
      contentController.text = content['content'];
      titleController.text = content['title'];

      setState(() {});
    }
    context.read<LoadingProvider>().setLoading(false);
    return;
  }

  bool get canSave => titleController.text.trim().isNotEmpty && contentController.text.trim().isNotEmpty && dropdownValue != null;

  @override
  Widget build(BuildContext context) {
    var user = context.watch<User>();
    var navigator = Navigator.of(context);
    var messenger = ScaffoldMessenger.of(context);
    var themeProvider = context.watch<ThemeProvider>();
    final isDark = themeProvider.isDarkMode;
    final neuBase = isDark ? NeuColors.neuBaseDark : NeuColors.neuBase;
    final neuText = isDark ? NeuColors.neuTextDark : NeuColors.neuText;
    var loadingprovider = context.watch<LoadingProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Blog"),
        centerTitle: true,
        backgroundColor: neuBase,
        foregroundColor: neuText,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: NeuButton(
              onPressed: canSave
                  ? () async {
                      loadingprovider.setLoading(true);
                      Map<String, String> blog = {
                        "title": titleController.text,
                        "content": contentController.text,
                        "category": dropdownValue!,
                        "author": user.name,
                        "authorid": user.id!,
                      };
                      var success = await createBlog(blog, user);
                      if (success) {
                        navigator.pop(true);
                      } else {
                        messenger.showSnackBar(
                          const SnackBar(content: Text("Something went wrong!")),
                        );
                      }
                      loadingprovider.setLoading(false);
                    }
                  : null,
              label: 'Save',
              isDark: isDark,
              padding: const EdgeInsetsGeometry.all(8),
              borderRadius: 10,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Categories
            NeuContainer(
              isDark: isDark,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Text("Category:", style: TextStyle(color: neuText)),
                  
                  DropdownButton<String>(
                    hint: Text("Select Category", style: TextStyle(color: neuText)),
                    dropdownColor: neuBase,
                    value: dropdownValue,
                    items: categories.map((category) {
                      return DropdownMenuItem<String>(
                        value: category,
                        child: Text(category, style: TextStyle(color: neuText)),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        dropdownValue = value!;
                      });
                    },
                  ),

                  NeuButton(
                      label: " create with PookieAI",
                      onPressed: () async {
                        await showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              content: TextField(
                                autofocus: true,
                                decoration: const InputDecoration(
                                  labelText: "Enter topic",
                                  border: OutlineInputBorder(),
                                ),
                                onChanged: (value) {
                                  topic = value;
                                },
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text("Cancel"),
                                ),
                                ElevatedButton(
                                  onPressed: () async {
                                    Navigator.of(context).pop();
                                    loadingprovider.setLoading(true);
                                    await generateByAI(topic ?? "", dropdownValue ?? "");
                                  },
                                  child: const Text("Create"),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      isDark: isDark,
                      padding: const EdgeInsetsGeometry.all(10),
                      borderRadius: 10)
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Title input
            NeuContainer(
              isDark: isDark,
              child: TextField(
                controller: titleController,
                maxLines: 3,
                style: TextStyle(color: isDark ? NeuColors.neuTextDark : NeuColors.neuText),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  hintText: "Title",
                  hintStyle: TextStyle(
                    color: isDark ? NeuColors.neuTextDark : NeuColors.neuText,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Content input
            // NeuContainer(
            //   isDark: isDark,
            //   child: TextField(
            //     controller: contentController,
            //     minLines: 10,
            //     maxLines: 15,
            //     style: TextStyle(color: isDark ? NeuColors.neuTextDark : NeuColors.neuText),
            //     decoration: InputDecoration(
            //       border: InputBorder.none,
            //       focusedBorder: InputBorder.none,
            //       enabledBorder: InputBorder.none,
            //       hintText: "Content",
            //       hintStyle: TextStyle(
            //         color: isDark ? NeuColors.neuTextDark : NeuColors.neuText,
            //         fontSize: 18,
            //         fontWeight: FontWeight.bold,
            //       ),
            //     ),
            //   ),
            // ),
            RichTextEditor(
              controller: contentController,
            ),
          ],
        ),
      ),
    );
  }
}

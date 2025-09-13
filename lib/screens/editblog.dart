import 'package:blog_app/models/blogmodel.dart';
import 'package:blog_app/models/user.dart';
import 'package:blog_app/service.dart';
import 'package:blog_app/widgets/neu_button.dart';
import 'package:blog_app/widgets/neu_container.dart';
import 'package:flutter/material.dart';
import 'package:blog_app/providers/theme_provider.dart';
import 'package:provider/provider.dart';

class Editblog extends StatefulWidget {
  const Editblog({super.key, required this.blog});
  final BlogModel blog;

  @override
  State<Editblog> createState() => _EditblogState();
}

class _EditblogState extends State<Editblog> {
  late String dropdownValue;
  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();

  final List<String> categories = ["Politics", "Technology", "Health", "Education", "Finance", "Travel"];

  @override
  void initState() {
    super.initState();
    dropdownValue = widget.blog.category;
    titleController.text = widget.blog.title;
    contentController.text = widget.blog.content;

    // Refresh button state when typing
    titleController.addListener(() => setState(() {}));
    contentController.addListener(() => setState(() {}));
  }

  bool get canSave => titleController.text.trim().isNotEmpty && contentController.text.trim().isNotEmpty;

  @override
  Widget build(BuildContext context) {
    var user = context.watch<User>();
    var navigator = Navigator.of(context);
    var messenger = ScaffoldMessenger.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final neuBase = isDark ? NeuColors.neuBaseDark : NeuColors.neuBase;
    final neuText = isDark ? NeuColors.neuTextDark : NeuColors.neuText;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Blog"),
        centerTitle: true,
        backgroundColor: neuBase,
        foregroundColor: neuText,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: NeuButton(
              onPressed: canSave
                  ? () async {
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
                          const SnackBar(content: Text("Failed to update blog")),
                        );
                      }
                    }
                  : null,
              label: 'Save',
              isDark: isDark,
              padding: const EdgeInsetsGeometry.all(8),
              borderRadius: 10, // di
            ),
          ),
        ],
      ),
      // resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Categories
              NeuContainer(
                isDark: isDark,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Category:", style: TextStyle(color: neuText)),
                    const SizedBox(width: 10),
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
                    labelText: "Title",
                    labelStyle: TextStyle(color: isDark ? NeuColors.neuTextDark : NeuColors.neuText, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Content input
              NeuContainer(
                isDark: isDark,
                child: TextField(
                  controller: contentController,
                  minLines: 10,
                  maxLines: 15,
                  style: TextStyle(color: isDark ? NeuColors.neuTextDark : NeuColors.neuText),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    labelText: "Content",
                    labelStyle: TextStyle(color: isDark ? NeuColors.neuTextDark : NeuColors.neuText, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

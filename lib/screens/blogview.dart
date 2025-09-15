import 'package:blog_app/models/blogmodel.dart';
import 'package:blog_app/models/user.dart';
import 'package:blog_app/screens/editblog.dart';
import 'package:blog_app/service.dart';
import 'package:blog_app/widgets/neu_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:provider/provider.dart';
import 'package:blog_app/providers/theme_provider.dart';

class Blogview extends StatefulWidget {
  const Blogview({super.key, required this.blog});
  final BlogModel blog;

  @override
  State<Blogview> createState() => _BlogviewState();
}

class _BlogviewState extends State<Blogview> {
  void _deleteBlog(String id) async {
    var success = await deleteBlog(id, context.read<User>());
    if (success) {
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    var user = context.watch<User>();
    var themeProvider = context.watch<ThemeProvider>();
    final isDark = themeProvider.isDarkMode;
    final neuBase = isDark ? NeuColors.neuBaseDark : NeuColors.neuBase;
    final neuText = isDark ? NeuColors.neuTextDark : NeuColors.neuText;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: neuBase,
        foregroundColor: neuText,
        title: const Text("ZeeBlog"),
        centerTitle: true,
        actions: [
          user.id == widget.blog.authorid
              ? PopupMenuButton<String>(
                  icon: Icon(Icons.more_vert, color: neuText),
                  onSelected: (value) async {
                    if (value == "edit") {
                      var navigator = Navigator.of(context);
                      var result = await navigator.push(
                        MaterialPageRoute(
                          builder: (context) => ChangeNotifierProvider.value(
                              value: user,
                              builder: (context, _) {
                                return Editblog(blog: widget.blog);
                              }),
                        ),
                      );
                      if (result == true) {
                        navigator.pop(true);
                      }
                    } else if (value == "delete") {
                      _confirmDelete(context, id: widget.blog.id);
                    }
                  },
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: "edit",
                      child: Row(
                        children: [
                          Icon(Icons.edit, color: neuText),
                          const SizedBox(width: 8),
                          Text("Edit", style: TextStyle(color: neuText)),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: "delete",
                      child: Row(
                        children: [
                          Icon(Icons.delete, color: neuText),
                          const SizedBox(width: 8),
                          Text("Delete", style: TextStyle(color: neuText)),
                        ],
                      ),
                    ),
                  ],
                )
              : const SizedBox.shrink(),
        ],
      ),
      body: Container(
        color: neuBase,
        padding: const EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    NeuContainer(
                        isDark: isDark,
                        child: Text("Author: ${widget.blog.author}",
                            style: TextStyle(color: isDark ? NeuColors.neuTextDark : NeuColors.neuText, fontWeight: FontWeight.w500))),
                    Text("Published: ${widget.blog.date.year}-${widget.blog.date.month}-${widget.blog.date.day}",
                        style: TextStyle(color: isDark ? NeuColors.neuTextDark : NeuColors.neuText)),
                  ],
                ),
                const SizedBox(height: 20),
                Text(
                  widget.blog.title,
                  style: TextStyle(color: neuText, fontSize: 20, fontWeight: FontWeight.bold),
                ),

                // Divider(color: neuText),
                const SizedBox(height: 20),
                Html(data: widget.blog.content),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context, {required String id}) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Blog"),
        content: const Text("Are you sure you want to delete this blog?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              
              _deleteBlog(id);
              Navigator.pop(context);
            },
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}

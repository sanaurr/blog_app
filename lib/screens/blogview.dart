import 'package:blog_app/models/blogmodel.dart';
import 'package:blog_app/models/user.dart';
import 'package:blog_app/screens/editblog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Blogview extends StatefulWidget {
  const Blogview({super.key, required this.blog});
  final BlogModel blog;

  @override
  State<Blogview> createState() => _BlogviewState();
}

class _BlogviewState extends State<Blogview> {
  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    var textTheme = Theme.of(context).textTheme;
    var user = context.watch<User>();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        title: const Text("Blog"),
        centerTitle: true,
      ),
      body: Container(
        color: colorScheme.primaryContainer,
        padding: const EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 20),
              Row(
                children: [
                  Column(
                    children: [
                      Text("Author: ${widget.blog.author}",
                          style: textTheme.bodyLarge),
                      Text("Date: ${widget.blog.date}",
                          style: textTheme.bodySmall),
                    ],
                  ),
                  const Spacer(),
                  if (user.id == widget.blog.authorid)
                    ElevatedButton(
                      onPressed: () async{
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
                      },
                      child: const Text("Edit"),
                    ),
                ],
              ),
              Text(
                widget.blog.title,
                style: TextStyle(
                    color: colorScheme.onPrimaryContainer,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
              Divider(color: colorScheme.onPrimaryContainer),
              const SizedBox(height: 20),
              Text(widget.blog.content, style: textTheme.bodyLarge),
            ],
          ),
        ),
      ),
    );
  }
}

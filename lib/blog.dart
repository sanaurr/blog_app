import 'package:blog_app/models/blogmodel.dart';
import 'package:blog_app/models/user.dart';
import 'package:blog_app/screens/blogview.dart';
import 'package:blog_app/screens/createblog.dart';
import 'package:blog_app/screens/login.dart';
import 'package:blog_app/service.dart';
import 'package:blog_app/widgets/searchbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Blog extends StatefulWidget {
  const Blog({super.key});

  @override
  State<Blog> createState() => _BlogState();
}

class _BlogState extends State<Blog> {
  List<BlogModel>? blogs;
  @override
  void initState() {
    super.initState();
    loadBlogs();
  }

  void loadBlogs() async {
    // var messanger = ScaffoldMessenger.of(context);
    try {
      blogs = await allBlogs();
      if (mounted) {
        setState(() {});
      }
    } catch (e) {
      // messanger.showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  @override
  Widget build(BuildContext context) {
    var user = context.watch<User>();
    var colorScheme = Theme.of(context).colorScheme;
    var textTheme = Theme.of(context).textTheme;
    var size = MediaQuery.sizeOf(context);
    var cardCount = (size.width - 10) ~/ 200;
    var cardWidth = (size.width - 10) / cardCount;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        title: const Text('Blog'),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: user.isAuthenticated
                ? Text(user.name)
                : ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChangeNotifierProvider.value(
                              value: user,
                              builder: (context, _) {
                                return const Login();
                              }),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorScheme.primaryContainer,
                      foregroundColor: colorScheme.onPrimaryContainer,
                    ),
                    child: const Text("Sign In")),
          ),
        ],
      ),
      drawer: Drawer(
        backgroundColor: colorScheme.surfaceContainer,
        child: Column(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: colorScheme.secondary,
              ),
              child: Center(
                child: Text(
                  'Categories',
                  style: textTheme.titleLarge!.copyWith(
                    color: colorScheme.onSecondary,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 5),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                children: [
                  Container(
                    width: 200,
                    height: 40,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        bottomLeft: Radius.circular(30),
                      ),
                    ),
                    child: const TextField(
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.search, color: Colors.grey),
                        border: InputBorder.none,
                        hintText: 'Search',
                      ),
                    ),
                  ),
                  const SizedBox(width: 5),
                  Container(
                    width: 75,
                    height: 40,
                    decoration: BoxDecoration(
                      color: colorScheme.primary,
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(30),
                        bottomRight: Radius.circular(30),
                      ),
                    ),
                    child: TextButton(
                      onPressed: () {},
                      child: const Text(
                        "Search",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 5),
            ListTile(
              tileColor: colorScheme.primaryContainer,
              title: const Text('Category 1'),
            ),
            const SizedBox(height: 5),
            ListTile(
              tileColor: colorScheme.primaryContainer,
              title: const Text('Category 1'),
            ),
            const SizedBox(height: 5),
            ListTile(
              tileColor: colorScheme.primaryContainer,
              title: const Text('Category 1'),
            ),
            const Spacer(),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(15.0),
              child: ElevatedButton(
                onPressed: () {
                  user.logout();
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.tertiaryContainer,
                  foregroundColor: colorScheme.onTertiaryContainer,
                ),
                child: const Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Text("Logout"),
                ),
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                children: [
                  const Expanded(child: Searchbar()),
                  const SizedBox(
                    width: 10,
                  ),
                  if (user.isAuthenticated)
                    ElevatedButton(
                      onPressed: () async {
                        var result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const Createblog(),
                          ),
                        );
                        if (result ?? false) {
                          loadBlogs();
                        }
                      },
                      child: const Text("Create"),
                    )
                ],
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: blogs == null
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : blogs!.isEmpty
                      ? const Center(
                          child: Text('No Itmems'),
                        )
                      : Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: blogs!
                              .map(
                                (blog) => SizedBox(
                                  width: cardWidth,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Card(
                                      color: colorScheme.primaryContainer,
                                      elevation: 5,
                                      child: Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                color: colorScheme
                                                    .tertiaryContainer,
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(5.0),
                                                child: Text(
                                                  blog.category,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                              blog.title,
                                              style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                              blog.content,
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            TextButton(
                                                onPressed: () async {
                                                  var result =
                                                      await Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          ChangeNotifierProvider
                                                              .value(
                                                                  value: user,
                                                                  builder:
                                                                      (context,
                                                                          _) {
                                                                    return Blogview(
                                                                      blog:
                                                                          blog,
                                                                    );
                                                                  }),
                                                    ),
                                                  );

                                                  if (result ?? false) {
                                                    loadBlogs();
                                                  }
                                                },
                                                child: const Text("Read more"))
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                        ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:blog_app/models/blogmodel.dart';
import 'package:blog_app/models/user.dart';
import 'package:blog_app/providers/theme_provider.dart';
import 'package:blog_app/screens/blogview.dart';
import 'package:blog_app/screens/createblog.dart';
import 'package:blog_app/screens/login.dart';
import 'package:blog_app/service.dart';
import 'package:blog_app/widgets/author_icon.dart';
import 'package:blog_app/widgets/neu_button.dart';
import 'package:blog_app/widgets/neu_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:provider/provider.dart';

class LatestPosts extends StatefulWidget {
  const LatestPosts({super.key});

  @override
  State<LatestPosts> createState() => _LatestPostsState();
}

class _LatestPostsState extends State<LatestPosts> {
  List<BlogModel>? blogs;
  bool loading = true;
  @override
  void initState() {
    super.initState();
    loadBlogs();
  }

  loadBlogs() async {
    var fetchedBlogs = await getLatestBlogs();
    setState(() {
      blogs = fetchedBlogs;
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    var user = context.watch<User>();
    var themeProvider = context.watch<ThemeProvider>();
    final isDark = themeProvider.isDarkMode;
    final neuText = isDark ? NeuColors.neuTextDark : NeuColors.neuText;
    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = (screenWidth - 20);

    return Scaffold(
      appBar: AppBar(
        title: const Text("My Blogs"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(10.0),
        child: user.isAuthenticated == false
            ? Center(
                child: NeuContainer(
                isDark: isDark,
                child: const Text('Please Login'),
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const Login())),
              ))
            : loading && user.isAuthenticated
                ? Center(child: NeuContainer(isDark: isDark, child: const Text('Loading...')))
                : blogs!.isEmpty && user.isAuthenticated
                    ? Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('No Items! Create a blog post', style: TextStyle(color: neuText)),
                            const SizedBox(height: 10),
                            NeuButton(
                              label: "Create Blog",
                              height: cardWidth * 0.13,
                              width: cardWidth * 0.5,
                              onPressed: () {
                                Navigator.push(context, MaterialPageRoute(builder: (context) => const Createblog()));
                              },
                              isDark: isDark,
                              padding: const EdgeInsets.all(10),
                              borderRadius: 20,
                            )
                          ],
                        ),
                      )
                    : Wrap(
                        spacing: 20,
                        runSpacing: 20,
                        children: blogs!
                            .map(
                              (blog) => SizedBox(
                                width: cardWidth,
                                child: NeuContainer(
                                  isDark: isDark,
                                  padding: const EdgeInsets.all(15),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            blog.category,
                                            style: TextStyle(
                                              color: isDark ? NeuColors.neuTextDark : NeuColors.neuText,
                                            ),
                                          ),
                                          const Spacer(),
                                          AuthorIcon(
                                            width: cardWidth * 0.09,
                                            height: cardWidth * 0.1,
                                            author: blog.author,
                                            isDark: isDark,
                                          )
                                        ],
                                      ),
                                      const SizedBox(height: 5),
                                      Text(
                                        blog.title,
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: isDark ? NeuColors.neuTextDark : NeuColors.neuText,
                                        ),
                                      ),
                                      const SizedBox(height: 5),
                                      Html(
                                        data:blog.content.substring(0, blog.content.length > 100 ? 100 : blog.content.length),
                                      
                                      ),
                                      const SizedBox(height: 10),
                                      NeuButton(
                                        label: "Read more",
                                        height: cardWidth * 0.1,
                                        onPressed: () async {
                                          var result = await Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => ChangeNotifierProvider.value(
                                                value: user,
                                                builder: (context, _) => Blogview(blog: blog),
                                              ),
                                            ),
                                          );
                                          if (result ?? false) {
                                            loadBlogs();
                                          }
                                        },
                                        isDark: isDark,
                                        padding: const EdgeInsets.all(5.0),
                                        borderRadius: 10,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                      ),
      ),
    );
  }
}

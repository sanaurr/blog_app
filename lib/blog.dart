import 'package:blog_app/models/blogmodel.dart';
import 'package:blog_app/models/user.dart';
import 'package:blog_app/providers/theme_provider.dart';
import 'package:blog_app/screens/blogview.dart';
import 'package:blog_app/screens/createblog.dart';
import 'package:blog_app/screens/login.dart';
import 'package:blog_app/service.dart';
import 'package:blog_app/widgets/author_icon.dart';
import 'package:blog_app/widgets/neu_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/neu_container.dart'; // import NeuContainer

class Blog extends StatefulWidget {
  const Blog({super.key});

  @override
  State<Blog> createState() => _BlogState();
}

class _BlogState extends State<Blog> {
  List<BlogModel>? blogs;
  String? category;
  List<String> navItems = ["Home", "My Blogs", "Latest", "About"];
  bool isShowSearch = false;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    category = category ?? "All";
    loadBlogs(category!);
  }

  void loadBlogs(String category) async {
    try {
      blogs = await allBlogs(category);
      if (mounted) setState(() {});
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    var user = context.watch<User>();
    var themeProvider = context.watch<ThemeProvider>();
    var isDark = themeProvider.isDarkMode;
    var neuText = isDark ? NeuColors.neuTextDark : NeuColors.neuText;
    var size = MediaQuery.sizeOf(context);
    var cardCount = (size.width - 10) ~/ 200;
    var cardWidth = (size.width - 10) / cardCount;

    return Scaffold(
        appBar: AppBar(
          backgroundColor: isDark ? NeuColors.neuBaseDark : NeuColors.neuBase,
          foregroundColor: isDark ? NeuColors.neuTextDark : NeuColors.neuText,
          title: isShowSearch ? null : const Text('ZeeBlog'),
          centerTitle: true,
          actions: [
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  isShowSearch
                      ? NeuContainer(
                          width: size.width * 0.6,
                          height: cardWidth * 0.15,
                          isDark: isDark,
                          borderRadius: 30,
                          child: TextField(
                            controller: searchController,
                            style: TextStyle(color: neuText),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Search',
                              hintStyle: TextStyle(color: isDark ? NeuColors.neuTextDark : NeuColors.neuText),
                            ),
                          ),
                        )
                      : const SizedBox.shrink(),
                  const SizedBox(width: 10),
                  NeuButton(
                    icon: Icons.search,
                    label: "",
                    onPressed: () {
                      setState(() {
                        isShowSearch = !isShowSearch;
                      });
                    },
                    isDark: isDark,
                    padding: const EdgeInsetsGeometry.all(12.0),
                    borderRadius: 50,
                  )
                ],
              ),
            ),
          ],
        ),
        drawer: Drawer(
          backgroundColor: isDark ? NeuColors.neuBaseDark : NeuColors.neuBase,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DrawerHeader(
                  decoration: BoxDecoration(
                    color: isDark ? NeuColors.neuBaseDark : NeuColors.neuBase,
                  ),
                  child: Row(
                    children: [
                      Text(user.isAuthenticated ? user.name : "Welcome! Guest",
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: isDark ? NeuColors.neuTextDark : NeuColors.neuText)),
                      const Spacer(),
                      IconButton(
                        icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode, color: neuText),
                        onPressed: () {
                          themeProvider.toggleTheme(!themeProvider.isDarkMode);
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 5),
                ...List.generate(
                  navItems.length,
                  (i) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
                    child: NeuContainer(
                      width: double.infinity,
                      onTap: () {
                        // category = categories[i];
                        // loadBlogs(category!);
                        // Navigator.pop(context);
                      },
                      isDark: isDark,
                      child: Text(navItems[i], style: TextStyle(color: neuText)),
                    ),
                  ),
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: NeuContainer(
                    isDark: isDark,
                    borderRadius: 30,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    onTap: () {
                      if (user.isAuthenticated) {
                        user.logout();
                        Navigator.pop(context);
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChangeNotifierProvider.value(
                              value: user,
                              builder: (context, _) => const Login(),
                            ),
                          ),
                        );
                      }
                    },
                    child: Center(
                      child: Text(user.isAuthenticated ? "Logout" : "Login", style: TextStyle(color: neuText)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        body: DefaultTabController(
          length: 7,
          child: Column(
            children: [
              const SizedBox(height: 10),
              // 🔹 TabBar
              TabBar(
                indicatorAnimation: TabIndicatorAnimation.elastic,
                indicatorSize: TabBarIndicatorSize.tab,
                dividerHeight: 0,
                indicator: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: isDark ? NeuColors.neuBaseDark : NeuColors.neuBase,
                  boxShadow: isDark ? NeuShadows.neuDark : NeuShadows.neu,
                ),
                onTap: (index) {
                  switch (index) {
                    case 0:
                      category = "All";
                      break;
                    case 1:
                      category = "Technology";
                      break;
                    case 2:
                      category = "Health";
                      break;
                    case 3:
                      category = "Travel";
                      break;
                    case 4:
                      category = "Politics";
                      break;
                    case 5:
                      category = "Business";
                      break;
                    case 6:
                      category = "Lifestyle";
                      break;
                  }
                  loadBlogs(category!);
                },
                isScrollable: true,
                indicatorColor: neuText,
                labelColor: neuText,
                unselectedLabelColor: neuText,
                tabs: const [
                  Tab(text: 'All'),
                  Tab(text: 'Technology'),
                  Tab(text: 'Health'),
                  Tab(text: 'Travel'),
                  Tab(text: 'Politics'),
                  Tab(text: 'Business'),
                  Tab(text: 'Lifestyle'),
                ],
              ),
              const SizedBox(height: 10),

              // 🔹 Expanded so TabBarView fills available height
              Expanded(
                child: TabBarView(
                  children: List.generate(
                    7,
                    (index) => SingleChildScrollView(
                      padding: const EdgeInsets.all(10.0),
                      child: blogs == null
                          ? const Center(child: CircularProgressIndicator())
                          : blogs!.isEmpty
                              ? Center(
                                  child: Text('No Items', style: TextStyle(color: neuText)),
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
                                                Text(
                                                  blog.content,
                                                  maxLines: 2,
                                                  overflow: TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                    color: isDark ? NeuColors.neuTextDark : NeuColors.neuText,
                                                  ),
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
                                                      loadBlogs(category!);
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
                  ),
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: isDark ? NeuColors.neuBaseDark : NeuColors.neuBase,
          foregroundColor: isDark ? NeuColors.neuTextDark : NeuColors.neuText,
          onPressed: () {
            if (user.isAuthenticated) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChangeNotifierProvider.value(
                    value: user,
                    builder: (context, _) => const Createblog(),
                  ),
                ),
              ).then((value) {
                if (value == true) {
                  loadBlogs(category!);
                }
              });
            } else {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Not Authenticated'),
                  content: const Text('Please log in to create a blog post.'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('OK'),
                    ),
                  ],
                ),
              );
            }
          },
          child: const Icon(Icons.add),
        ));
  }
}

import 'package:blog_app/providers/loading_provider.dart';
import 'package:blog_app/providers/theme_provider.dart';
import 'package:blog_app/widgets/neu_button.dart';
import 'package:blog_app/widgets/neu_container.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final loadingprovider = context.read<LoadingProvider>();
      loadingprovider.setLoading(false);
    });
  }

  @override
  Widget build(BuildContext context) {
    var themeProvider = context.watch<ThemeProvider>();
    final isDark = themeProvider.isDarkMode;
    return Scaffold(
      appBar: AppBar(
        title: const Text("About"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Text('Welcome to ZeeBlog!', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.blueAccent)),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Your modern platform for sharing stories, ideas, and knowledge. "
                "Our mission is to empower everyone to create, discover, and "
                "connect through blogging.",
                style: TextStyle(
                  color: isDark ? NeuColors.neuTextDark : NeuColors.neuText,
                  fontSize: 16,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: NeuContainer(
                  isDark: isDark,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "✨ What We Offer",
                        style: TextStyle(fontWeight: FontWeight.bold, color: isDark ? NeuColors.neuTextDark : NeuColors.neuText),
                        // textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 5),
                      Text(
                        "📝 Effortless blog creation with an intuitive editor",
                        style: TextStyle(
                          color: isDark ? NeuColors.neuTextDark : NeuColors.neuText,
                        ),
                        // textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 5),
                      Text(
                        "🎉 Effortless blog creation with PookieAI",
                        style: TextStyle(
                          color: isDark ? NeuColors.neuTextDark : NeuColors.neuText,
                        ),
                        // textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 5),
                      Text(
                        "🔍 Discover articles by category and trending topics",
                        style: TextStyle(
                          color: isDark ? NeuColors.neuTextDark : NeuColors.neuText,
                        ),
                        // textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 5),
                      Text(
                        "👤 Personalized profiles and easy blog management",
                        style: TextStyle(
                          color: isDark ? NeuColors.neuTextDark : NeuColors.neuText,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        "🌙 Light & dark mode for comfortable reading",
                        style: TextStyle(
                          color: isDark ? NeuColors.neuTextDark : NeuColors.neuText,
                        ),
                        // textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 5),
                      Text(
                        "💬 A growing community of writers and readers",
                        style: TextStyle(
                          color: isDark ? NeuColors.neuTextDark : NeuColors.neuText,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 5),
                    ],
                  )),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: NeuContainer(
                  isDark: isDark,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "✨ Our Story",
                        style: TextStyle(fontWeight: FontWeight.bold, color: isDark ? NeuColors.neuTextDark : NeuColors.neuText),
                        // textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 5),
                      Text(
                        "ZeeBLOG was created by SANAUR RAHAMAN as a portfolio project who "
                        "believes in the power of words and community. We wanted a space "
                        "that is simple, fast, and inspiring for both new and experienced "
                        "bloggers. Whether you want to share your expertise, document "
                        "your journey, or just express yourself — ZeeBLOG is here for you.",
                        style: TextStyle(
                          color: isDark ? NeuColors.neuTextDark : NeuColors.neuText,
                        ),
                        // textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 5),
                    ],
                  )),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: NeuContainer(
                  isDark: isDark,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "✨ Get in touch",
                        style: TextStyle(fontWeight: FontWeight.bold, color: isDark ? NeuColors.neuTextDark : NeuColors.neuText),
                        // textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 5),
                      Text(
                        "If you have any questions, suggestions, or feedback, please don't hesitate to reach out. We're here to help you make the most of ZeeBLOG.",
                        style: TextStyle(
                          color: isDark ? NeuColors.neuTextDark : NeuColors.neuText,
                        ),
                        // textAlign: TextAlign.center,
                      ),
                      Text(
                        "Our email: sanaur.sp@gmail.com",
                        style: TextStyle(
                          color: isDark ? NeuColors.neuTextDark : NeuColors.neuText,
                          fontWeight: FontWeight.bold,
                        ),
                        // textAlign: TextAlign.center,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Or visit our website :",
                            style: TextStyle(
                              color: isDark ? NeuColors.neuTextDark : NeuColors.neuText,
                              fontWeight: FontWeight.bold,
                            ),
                            // textAlign: TextAlign.center,
                          ),
                          NeuButton(
                            label: 'Visit',
                            width: MediaQuery.sizeOf(context).width * 0.2,
                            height: MediaQuery.sizeOf(context).width * 0.1,
                            onPressed: () async {
                              const url = 'https://blog-web-azure.vercel.app/';
                              if (await canLaunchUrl(Uri.parse(url))) {
                                await launchUrl(Uri.parse(url));
                              } else {
                                throw 'Could not launch $url';
                              }
                            },
                            isDark: isDark,
                            padding: const EdgeInsets.all(10),
                            borderRadius: 10,
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                    ],
                  )),
            )
          ],
        ),
      ),
    );
  }
}

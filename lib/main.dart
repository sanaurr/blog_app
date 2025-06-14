import 'package:blog_app/blog.dart';
import 'package:blog_app/models/user.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var user = await User.init();
  runApp(ChangeNotifierProvider.value(
    value: user,
    builder: (context, child) => const MainApp(),
  ));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorSchemeSeed: Colors.blue,
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const Blog(),
    );
  }
}

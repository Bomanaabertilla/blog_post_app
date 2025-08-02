import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app_state.dart';
import 'screens/login_screen.dart';
import 'screens/create_post_screen.dart';
import 'widgets/post_card.dart';

void main() {
  runApp(
    ChangeNotifierProvider(create: (_) => AppState(), child: const MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    return MaterialApp(
      title: 'Blog App',
      debugShowCheckedModeBanner: false,
      theme: appState.isDarkMode ? _darkTheme : ThemeData.light(),
      home: appState.currentUser == null
          ? const LoginScreen()
          : const HomeScreen(),
    );
  }

  static final _darkTheme = ThemeData(
    primarySwatch: Colors.blue,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: Colors.grey[900],
    cardTheme: const CardThemeData(color: Colors.grey, elevation: 2),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.grey,
      foregroundColor: Colors.white,
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.white),
      bodyMedium: TextStyle(color: Colors.white),
    ),
  );
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Blog App'),
        centerTitle: true, // This centers the title
        actions: [
          IconButton(
            icon: Icon(
              appState.isDarkMode ? Icons.light_mode : Icons.dark_mode,
            ),
            onPressed: () {
              appState.toggleTheme();
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              appState.logout();
            },
          ),
        ],
      ),
      body: appState.posts.isEmpty
          ? const Center(child: Text('No posts yet. Create the first one!'))
          : ListView.builder(
              itemCount: appState.posts.length,
              itemBuilder: (context, index) => PostCard(
                post: appState.posts[index],
                currentUser: appState.currentUser!,
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CreatePostScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

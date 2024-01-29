import 'package:flutter/material.dart';
import 'package:otp_auth/provider/auth_provider.dart';
import 'package:otp_auth/screens/welcome_screen.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  final List<String> records = [];

  @override
  void initState() {
    super.initState();
  }

  void _openDialog() {
    showDialog(
      context: context,
      builder: (context) {
        TextEditingController _textController = TextEditingController();

        final formKey = GlobalKey<FormState>();

        return AlertDialog(
          backgroundColor: Colors.white,
          title: const Text("Navigate your way!"),
          content: Form(
            key: formKey,
            child: Column(
              children: [
                TextField(
                  controller: _textController,
                  decoration: const InputDecoration(
                    hintText: "Enter record",
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                "Cancel",
                style: TextStyle(
                  color: Colors.blue,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  records.add(_textController.text);
                });
                Navigator.pop(context);
              },
              child: const Text(
                "Add",
                style: TextStyle(
                  color: Colors.blue,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final ap = Provider.of<AuthProvider>(context, listen: false);
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: const Text("IIUMap"),
          titleTextStyle: const TextStyle(
            fontSize: 18,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
          actions: [
            IconButton(
                onPressed: () async {
                  ap.signOut().then(
                        (value) => Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => WelcomeScreen(),
                            ),
                            (route) => false),
                      );
                },
                icon: const Icon(Icons.logout),
                style: ButtonStyle(
                  foregroundColor: MaterialStateProperty.all(Colors.white),
                )),
          ],
        ),
        body: Center(
          child: Column(
            children: [
              const SizedBox(height: 10),
              Text(
                "Hello, ${ap.getUserModel.name}",
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Text(ap.getUserModel.name),
              Text(ap.getUserModel.email),
              Text(ap.getUserModel.phoneNumber),
            ],
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton(
          onPressed: _openDialog,
          tooltip: "Add Dept Record",
          child: const Icon(Icons.search),
          backgroundColor: Colors.blue.shade50,
          foregroundColor: Colors.blue,
          shape: CircleBorder(),
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          backgroundColor: Colors.blue,
          selectedItemColor: Colors.blue.shade50,
          unselectedItemColor: Colors.blue.shade900,
          showUnselectedLabels: false,
          selectedLabelStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: "Home",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.map),
              label: "LiveTracker",
            ),
          ],
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
        ));
  }
}

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pursue_your_next_degree/screens/degree_screen.dart';
import 'package:pursue_your_next_degree/screens/profile_form_screen.dart';
import 'package:pursue_your_next_degree/screens/select_country.dart';
import 'package:pursue_your_next_degree/screens/login_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final String userEmail = FirebaseAuth.instance.currentUser?.email ?? 'User';
  final String userId = FirebaseAuth.instance.currentUser?.uid ?? '';
  bool isProfileCreated = false;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    checkUserProfile();
  }

  Future<void> checkUserProfile() async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('profiles')
          .doc(userId)
          .get();

      if (doc.exists) {
        print("✅ Profile found for user: $userId");

        setState(() {
          isProfileCreated = true;
        });
      } else {
        print("❌ No profile found for user: $userId");
      }
    } catch (e) {
      print('⚠️ Error checking profile: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 2,
        title: const Text(
          'ApplyGlobal',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Row(
              children: [
                Text(
                  userEmail.split('@')[0],
                  style: const TextStyle(
                    color: Colors.black87,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.logout, color: Colors.redAccent),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text("Are you sure you want to logout?"),
                          actions: [
                            TextButton(
                              onPressed: () {
                                FirebaseAuth.instance.signOut();
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => LoginScreen(),
                                  ),
                                );
                              },
                              child: const Text("Yes"),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text("No"),
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Banner Section
            Stack(
              children: [
                SizedBox(
                  height: 250,
                  width: double.infinity,
                  child: Image.asset(
                    'assets/images/graduates.jpg',
                    fit: BoxFit.cover,
                  ),
                ),
                Container(
                  height: 250,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.black.withOpacity(0.6),
                        Colors.transparent,
                      ],
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                    ),
                  ),
                ),
                const Positioned(
                  left: 20,
                  bottom: 30,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Welcome to",
                        style: TextStyle(
                          fontSize: 26,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          shadows: [
                            Shadow(
                              offset: Offset(0, 2),
                              blurRadius: 4,
                              color: Colors.black54,
                            )
                          ],
                        ),
                      ),
                      Text(
                        "Study Abroad Portal",
                        style: TextStyle(
                          fontSize: 26,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          shadows: [
                            Shadow(
                              offset: Offset(0, 2),
                              blurRadius: 4,
                              color: Colors.black54,
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                )
                ,
              ],
            ),

            const SizedBox(height: 30),

            // About Us Section
            Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Text(
                    "About Us",
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: Colors.blueAccent,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "At Study Abroad Portal, we're committed to helping students fulfill their dreams of higher education overseas. Whether you're aiming for the USA, UK, Canada, or beyond – we're here to guide you every step of the way.",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // Profile Creation Section (conditionally rendered)
            if (!isProfileCreated)
              Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
                color: Colors.blue.shade50,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Get Started on Your Journey!",
                      style: Theme.of(context).textTheme.headlineSmall,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "Create your profile to explore degree opportunities tailored to you.",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const ProfileFormPage()),
                        );
                      },
                      icon: const Icon(Icons.person_add),
                      label: const Text("Create Profile"),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    )
                  ],
                ),
              ),

            const SizedBox(height: 20),

            // Apply Section
            Container(
              color: Colors.green.shade50,
              padding:
              const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
              child: Column(
                children: [
                  Text(
                    "Ready to Apply?",
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Submit your application for universities in the USA, UK, Canada, and more.",
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => DegreeScreen()),
                      );
                    },
                    child: const Text("Apply Now"),
                  )
                ],
              ),
            ),

            // Footer
            Container(
              color: Colors.grey.shade200,
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const Text("Contact Us: example@email.com | +880123456789"),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.facebook, size: 20),
                      SizedBox(width: 10),
                      Icon(Icons.linked_camera, size: 20),
                      SizedBox(width: 10),
                      Icon(Icons.web, size: 20),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Text("\u00a9 2025 Study Abroad Portal")
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

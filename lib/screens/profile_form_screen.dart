import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pursue_your_next_degree/screens/home_screen.dart';

class ProfileFormPage extends StatefulWidget {
  const ProfileFormPage({super.key});

  @override
  State<ProfileFormPage> createState() => _ProfileFormPageState();
}

class _ProfileFormPageState extends State<ProfileFormPage> {
  final _formKey = GlobalKey<FormState>();
  String? _name, _contact, _ieltsScore, _lastDegree, _cgpa;

  final List<String> _degreeOptions = ['B.Sc', 'M.Sc', 'PhD'];

  final DatabaseReference _databaseRef = FirebaseDatabase.instance.ref('profiles');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Your Profile"),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: "Full Name"),
                validator: (value) => value!.isEmpty ? "Enter your name" : null,
                onSaved: (value) => _name = value,
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(labelText: "Contact Number"),
                keyboardType: TextInputType.phone,
                validator: (value) => value!.isEmpty ? "Enter your contact number" : null,
                onSaved: (value) => _contact = value,
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(labelText: "IELTS Score"),
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? "Enter your IELTS score" : null,
                onSaved: (value) => _ieltsScore = value,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: "Last Degree"),
                items: _degreeOptions.map((degree) {
                  return DropdownMenuItem<String>(
                    value: degree,
                    child: Text(degree),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _lastDegree = value;
                  });
                },
                validator: (value) => value == null ? "Select your last degree" : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: "CGPA (optional)",
                  hintText: "e.g., 3.80",
                ),
                keyboardType: TextInputType.number,
                onSaved: (value) => _cgpa = value,
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final confirmed = await showDialog<bool>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text("Confirmation"),
                        content: const Text("Are you sure you want to submit this profile?"),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, false),
                            child: const Text("Cancel"),
                          ),
                          ElevatedButton(
                            onPressed: () => Navigator.pop(context, true),
                            child: const Text("Yes, Submit"),
                          ),
                        ],
                      ),
                    );

                    if (confirmed == true) {
                      _formKey.currentState!.save();

                      final user = FirebaseAuth.instance.currentUser;

                      if (user == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("User not logged in")),
                        );
                        return;
                      }

                      final profileData = {
                        'user_id': user.uid,
                        'name': _name,
                        'contact': _contact,
                        'ielts_score': _ieltsScore,
                        'last_degree': _lastDegree,
                        'cgpa': _cgpa ?? '',
                        'created_at': DateTime.now().toIso8601String(),
                      };

                      try {
                        await _databaseRef.push().set(profileData);

                        _formKey.currentState!.reset();

                        await showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text("Success"),
                            content: const Text("🎉 Profile submitted successfully!"),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(builder: (context) => const HomePage()),
                                  );
                                },
                                child: const Text("OK"),
                              ),
                            ],
                          ),
                        );
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Failed to submit: $e")),
                        );
                      }
                    }
                  }
                },
                child: const Text("Submit"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

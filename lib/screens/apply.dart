import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:pursue_your_next_degree/screens/home_screen.dart';

class ApplyScreen extends StatefulWidget {
  final String degree;
  final String country;
  final String subject;

  ApplyScreen({
    required this.degree,
    required this.country,
    required this.subject,
  });

  @override
  State<ApplyScreen> createState() => _ApplyScreenState();
}

class _ApplyScreenState extends State<ApplyScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController nidController = TextEditingController();
  final TextEditingController cgpaController = TextEditingController();

  String? gender;
  DateTime? selectedDate;

  Future<void> _pickDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime(2000),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() => selectedDate = picked);
    }
  }

  Future<void> _submitForm() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('User not logged in')),
        );
        return;
      }

      // Reference to the Firebase Realtime Database
      DatabaseReference ref = FirebaseDatabase.instance.ref("applications");

      // Push data to Firebase Realtime Database
      await ref.push().set({
        "userId": user.uid,
        "name": nameController.text,
        "email": emailController.text,
        "gender": gender,
        "dob": selectedDate!.toIso8601String(),
        "nid": nidController.text,
        "cgpa": cgpaController.text,
        "degree": widget.degree,
        "country": widget.country,
        "subject": widget.subject,
        "submittedAt": DateTime.now().toIso8601String(),
      });

      // Success dialog
      await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Success'),
          content: Text('Your request has been submitted.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => HomePage()),
                      (route) => false,
                );
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error submitting form: $e')),
      );
    }
  }

  void _confirmSubmission() {
    if (_formKey.currentState!.validate() && gender != null && selectedDate != null) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Confirm Submission'),
          content: Text('Are you sure you want to submit the application?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _submitForm();
              },
              child: Text('Submit'),
            ),
          ],
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill all fields')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Apply for ${widget.subject}")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: nameController,
                  decoration: InputDecoration(labelText: 'Name'),
                  validator: (value) => value!.isEmpty ? 'Enter your name' : null,
                ),
                SizedBox(height: 12),
                TextFormField(
                  controller: emailController,
                  decoration: InputDecoration(labelText: 'Email'),
                  validator: (value) => value!.contains('@') ? null : 'Enter a valid email',
                ),
                SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: gender,
                  hint: Text('Select Gender'),
                  items: ['Male', 'Female', 'Other']
                      .map((g) => DropdownMenuItem(value: g, child: Text(g)))
                      .toList(),
                  onChanged: (value) => setState(() => gender = value),
                  validator: (value) => value == null ? 'Select gender' : null,
                ),
                SizedBox(height: 12),
                ListTile(
                  title: Text(
                    selectedDate == null
                        ? 'Select Date of Birth'
                        : 'DOB: ${selectedDate!.toLocal()}'.split(' ')[0],
                  ),
                  trailing: Icon(Icons.calendar_today),
                  onTap: () => _pickDate(context),
                ),
                SizedBox(height: 12),
                TextFormField(
                  controller: nidController,
                  decoration: InputDecoration(labelText: 'NID'),
                  validator: (value) => value!.isEmpty ? 'Enter NID' : null,
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 12),
                TextFormField(
                  controller: cgpaController,
                  decoration: InputDecoration(labelText: 'Undergraduate CGPA'),
                  validator: (value) => value!.isEmpty ? 'Enter CGPA' : null,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                ),
                SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _confirmSubmission,
                  child: Text("Apply"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:pursue_your_next_degree/screens/select_country.dart';

class ApplyScreen extends StatefulWidget {
  final String subject;

  ApplyScreen({required this.subject});

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
      setState(() {
        selectedDate = picked;
      });
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate() && gender != null && selectedDate != null) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Success'),
          content: Text('Your request has been submitted.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => SelectCountryScreen()),
                );
              },
              child: Text('OK'),
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
                  validator: (value) =>
                  value!.contains('@') ? null : 'Enter a valid email',
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
                  onPressed: _submitForm,
                  child: Text("Apply"),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

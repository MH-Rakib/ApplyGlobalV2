import 'package:flutter/material.dart';
import 'apply.dart';

class SelectSubjectScreen extends StatelessWidget {
  final String degree;
  final String countryName;
  final List<String> subjects;

  SelectSubjectScreen({required this.degree, required this.countryName, required this.subjects});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Select Subject")),
      body: ListView.builder(
        itemCount: subjects.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(subjects[index]),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ApplyScreen(
                    degree: degree,
                    country: countryName,
                    subject: subjects[index],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

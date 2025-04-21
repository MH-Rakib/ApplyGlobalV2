import 'package:flutter/material.dart';
import 'select_country.dart';

class DegreeScreen extends StatelessWidget {
  final List<String> degrees = ["B.Sc", "M.Sc", "PhD"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Select Degree")),
      body: ListView.builder(
        itemCount: degrees.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(degrees[index]),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SelectCountryScreen(degree: degrees[index]),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

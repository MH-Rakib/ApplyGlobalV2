import 'package:flutter/material.dart';
import 'package:pursue_your_next_degree/screens/select_subject.dart';

import '../data/country_subject_data.dart';

class SelectCountryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Select Country")),
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
        ),
        itemCount: countries.length,
        itemBuilder: (context, index) {
          return Card(
            child: InkWell(
              onTap: () {
                // Redirect to the Select Subject screen
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SelectSubjectScreen(country: countries[index]),
                  ),
                );
              },
              child: Center(child: Text(countries[index].name)),
            ),
          );
        },
      ),
    );
  }
}

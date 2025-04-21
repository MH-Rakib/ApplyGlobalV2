import 'package:flutter/material.dart';
import 'package:pursue_your_next_degree/screens/select_subject.dart';

import '../data/country_subject_data.dart';

class SelectCountryScreen extends StatelessWidget {
  final String degree;

  SelectCountryScreen({required this.degree});

  @override
  Widget build(BuildContext context) {
    final selectedDegreeData = degreePrograms.firstWhere((d) => d['degree'] == degree);
    final countries = selectedDegreeData['countries'];

    return Scaffold(
      appBar: AppBar(title: Text("Select Country")),
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        itemCount: countries.length,
        itemBuilder: (context, index) {
          final country = countries[index];
          return Card(
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SelectSubjectScreen(
                      degree: degree,
                      countryName: country['name'],
                      subjects: country['subjects'],
                    ),
                  ),
                );
              },
              child: Center(child: Text(country['name'])),
            ),
          );
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:sqlite_flutter_crud/JsonModels/services/calculator.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculator',
      theme: ThemeData.light(),  // Always light theme
      home: const GpaCgpaInstantCalculator(),
    );
  }
}

class GpaCgpaInstantCalculator extends StatefulWidget {
  const GpaCgpaInstantCalculator({super.key});

  @override
  State<GpaCgpaInstantCalculator> createState() =>
      _GpaCgpaInstantCalculatorState();
}

class _GpaCgpaInstantCalculatorState extends State<GpaCgpaInstantCalculator> {
  final semesterNumberController = TextEditingController();
  final gpaController = TextEditingController();
  final creditController = TextEditingController();

  List<Semester> semesters = [];

  double calculateCGPA() {
    double totalPoints = 0;
    int totalCredits = 0;

    for (var s in semesters) {
      totalPoints += s.gpa * s.credits;
      totalCredits += s.credits;
    }

    return totalCredits > 0 ? totalPoints / totalCredits : 0.0;
  }

  void addSemester() {
    final int? number = int.tryParse(semesterNumberController.text);
    final double? gpa = double.tryParse(gpaController.text);
    final int? credits = int.tryParse(creditController.text);

    if (number != null && gpa != null && credits != null) {
      setState(() {
        semesters.add(Semester(number: number, gpa: gpa, credits: credits));
        semesterNumberController.clear();
        gpaController.clear();
        creditController.clear();
      });
    }
  }

  void generatePdfReport() async {
    final pdf = pw.Document();

    pdf.addPage(pw.Page(
      build: (context) => pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text('CGPA Report', style: pw.TextStyle(fontSize: 24)),
          pw.SizedBox(height: 10),
          pw.Text('Semesters:'),
          pw.SizedBox(height: 5),
          ...semesters.map((s) => pw.Text(
              'Semester ${s.number}: GPA = ${s.gpa.toStringAsFixed(2)}, Credits = ${s.credits}')),
          pw.SizedBox(height: 10),
          pw.Text('CGPA: ${calculateCGPA().toStringAsFixed(2)}',
              style: pw.TextStyle(fontSize: 20)),
        ],
      ),
    ));

    await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => pdf.save());
  }

  @override
  Widget build(BuildContext context) {
    final cgpa = calculateCGPA();

    return Scaffold(
      appBar: AppBar(
        title: const Text('GPA & CGPA Calculator'),
        // No theme toggle button
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(children: [
            const Text('Enter Semester GPA',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            TextField(
              controller: semesterNumberController,
              decoration: const InputDecoration(labelText: 'Semester Number'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: gpaController,
              decoration: const InputDecoration(labelText: 'GPA'),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
            ),
            TextField(
              controller: creditController,
              decoration: const InputDecoration(labelText: 'Credit Hours'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: addSemester,
              child: const Text('Add Semester'),
            ),
            const Divider(thickness: 2),
            const Text('Semester List:', style: TextStyle(fontWeight: FontWeight.bold)),
            ...semesters.map((s) => ListTile(
                  title: Text('Semester ${s.number}'),
                  subtitle: Text('GPA: ${s.gpa}, Credits: ${s.credits}'),
                )),
            const Divider(),
            Text('CGPA: ${cgpa.toStringAsFixed(2)}',
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              icon: const Icon(Icons.picture_as_pdf),
              label: const Text("Export PDF"),
              onPressed: generatePdfReport,
            )
          ]),
        ),
      ),
    );
  }
}

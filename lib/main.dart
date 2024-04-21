import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Package for date formatting

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Catatan KU',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Catatan KU'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late final TextEditingController _noteController;
  late final DateTime _selectedDate;
  String _currentNote = '';

  @override
  void initState() {
    super.initState();
    _noteController = TextEditingController();
    _selectedDate = DateTime.now();
    _loadNote();
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              DateFormat('dd MMMM yyyy').format(_selectedDate),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _noteController,
              decoration: InputDecoration(
                hintText: 'Write your note here...',
                border: OutlineInputBorder(),
              ),
              maxLines: null, // Allows multiple lines for longer notes
              onChanged: (value) {
                setState(() {
                  _currentNote = value;
                });
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveNote,
              child: Text('Save Note'),
            ),
          ],
        ),
      ),
    );
  }

  void _saveNote() {
    // Save note to local storage
    // For simplicity, we'll use SharedPreferences here
    // You can replace this with other local storage methods like SQLite or Hive
    final String formattedDate = DateFormat('yyyy-MM-dd').format(_selectedDate);
    // Save note with key as formatted date
    // Here, we're saving the note as a string
    // In a real app, you might want to save it as a structured data (e.g., JSON)
    // and convert it back when loading
    // For example: _saveNoteToLocalStorage(formattedDate, {'note': _currentNote});
    // Loading and saving to local storage is asynchronous operation, so it should be awaited
    // You can use packages like shared_preferences or hive for local storage in Flutter
    // Here is an example using SharedPreferences:
    // final prefs = await SharedPreferences.getInstance();
    // await prefs.setString(formattedDate, _currentNote);

    // For now, we'll just print the note
    print('Note saved for $_selectedDate: $_currentNote');
  }

  void _loadNote() {
    // Load note from local storage
    // Similar to _saveNote, you should replace this with appropriate method for your local storage
    // For example: _loadNoteFromLocalStorage(formattedDate);
    // Here is an example using SharedPreferences:
    // final prefs = await SharedPreferences.getInstance();
    // final note = prefs.getString(formattedDate);
    // if (note != null) {
    //   setState(() {
    //     _currentNote = note;
    //   });
    // }

    // For now, we'll just print the loaded note
    print('Note loaded for $_selectedDate: $_currentNote');
  }
}

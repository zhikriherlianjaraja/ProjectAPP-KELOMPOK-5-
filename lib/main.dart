import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Package for local storage

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
      initialRoute: '/',
      routes: {
        '/': (context) => MyHomePage(title: 'Catatan KU'),
        '/kalender': (context) => CalendarPage(),
      },
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
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              title: Text(
                'Catatan',
                style: TextStyle(
                  fontWeight: ModalRoute.of(context)?.settings.name == '/'
                      ? FontWeight.bold
                      : FontWeight.normal,
                ),
              ),
              onTap: () {
                // Close the drawer and navigate to Catatan page
                Navigator.pop(context);
                Navigator.pushNamed(context, '/');
              },
            ),
            ListTile(
              title: Text(
                'Kalender',
                style: TextStyle(
                  fontWeight:
                      ModalRoute.of(context)?.settings.name == '/kalender'
                          ? FontWeight.bold
                          : FontWeight.normal,
                ),
              ),
              onTap: () {
                // Close the drawer and navigate to Kalender page
                Navigator.pop(context);
                Navigator.pushNamed(context, '/kalender');
              },
            ),
          ],
        ),
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
            Expanded(
              child: TextField(
                controller: _noteController,
                decoration: InputDecoration(
                  hintText: 'Write your note here...',
                  border: OutlineInputBorder(),
                ),
                maxLines: null,
                onChanged: (value) {
                  setState(() {
                    _currentNote = value;
                  });
                },
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                ElevatedButton.icon(
                  onPressed: _saveNote,
                  icon: Icon(Icons.save),
                  label: Text('Save Note'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton.icon(
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: _currentNote));
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Note copied to clipboard'),
                      ),
                    );
                  },
                  icon: Icon(Icons.copy),
                  label: Text('Copy Note'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _saveNote() async {
    // Save note to local storage
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('note_${_selectedDate.toString()}', _currentNote);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Note saved'),
      ),
    );
  }

  void _loadNote() async {
    // Load note from local storage
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? note = prefs.getString('note_${_selectedDate.toString()}');
    if (note != null) {
      setState(() {
        _currentNote = note;
        _noteController.text = note;
      });
    }
  }
}

class CalendarPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kalender'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              title: Text(
                'Catatan',
                style: TextStyle(
                  fontWeight: FontWeight.normal,
                ),
              ),
              onTap: () {
                // Close the drawer and navigate back to Catatan page
                Navigator.pop(context);
                Navigator.pushNamed(context, '/');
              },
            ),
            ListTile(
              title: Text(
                'Kalender',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              onTap: () {
                // Close the drawer
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: Text('Ini adalah halaman Kalender'),
      ),
    );
  }
}

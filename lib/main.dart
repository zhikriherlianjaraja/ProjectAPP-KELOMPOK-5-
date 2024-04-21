import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
  List<String> _notes = [];

  @override
  void initState() {
    super.initState();
    _noteController = TextEditingController();
    _selectedDate = DateTime.now();
    _loadNotes();
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
        actions: [
          IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
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
                Navigator.pop(context);
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
              child: ListView.builder(
                itemCount: _notes.length,
                itemBuilder: (context, index) {
                  return NoteCard(
                    noteTitle: _notes[index],
                    onDelete: () {
                      _deleteNote(index);
                    },
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: _addNote,
              child: Text('Tambah Catatan'),
            ),
          ],
        ),
      ),
    );
  }

  void _addNote() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Tambah Catatan'),
          content: TextField(
            controller: _noteController,
            decoration: InputDecoration(hintText: 'Tulis judul catatan...'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                _saveNote();
                Navigator.pop(context);
              },
              child: Text('Simpan'),
            ),
          ],
        );
      },
    );
  }

  void _saveNote() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _notes.add(_noteController.text);
    await prefs.setStringList('notes', _notes);
    _noteController.clear();
    setState(() {});
  }

  void _loadNotes() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? notes = prefs.getStringList('notes');
    if (notes != null) {
      setState(() {
        _notes = notes;
      });
    }
  }

  void _deleteNote(int index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _notes.removeAt(index);
    await prefs.setStringList('notes', _notes);
    setState(() {});
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
                Navigator.pop(context);
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

class NoteCard extends StatelessWidget {
  final String noteTitle;
  final VoidCallback onDelete;

  const NoteCard({Key? key, required this.noteTitle, required this.onDelete})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => NoteDetailPage(noteTitle: noteTitle)),
        );
      },
      child: Container(
        padding: EdgeInsets.all(12.0),
        margin: EdgeInsets.only(bottom: 16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 3,
              offset: Offset(0, 2), // changes position of shadow
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  noteTitle,
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                PopupMenuButton(
                  itemBuilder: (BuildContext context) {
                    return [
                      PopupMenuItem(
                        child: Text('Hapus'),
                        value: 'delete',
                      ),
                      PopupMenuItem(
                        child: Text('Ubah Warna'),
                        value: 'change_color',
                      ),
                    ];
                  },
                  onSelected: (value) {
                    if (value == 'delete') {
                      onDelete();
                    } else if (value == 'change_color') {
                      _changeColor(context);
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _changeColor(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Warna catatan diubah.'),
      ),
    );
    // Add your change color logic here
  }
}

class NoteDetailPage extends StatelessWidget {
  final String noteTitle;

  const NoteDetailPage({Key? key, required this.noteTitle}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(noteTitle),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              decoration: InputDecoration(),
            ),
            const SizedBox(height: 8),
            TextField(
              maxLines: null,
              expands: true,
              decoration: InputDecoration(
                alignLabelWithHint: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

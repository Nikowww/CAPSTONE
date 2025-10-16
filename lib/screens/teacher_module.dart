import 'package:flutter/material.dart';

class TeacherDashboard extends StatelessWidget {
  const TeacherDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Teacher Dashboard'),
        backgroundColor: Colors.indigo,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Welcome, Teacher!',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),

            ElevatedButton.icon(
              icon: const Icon(Icons.upload_file),
              label: const Text("Upload Quiz"),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const UploadQuizPage()),
                );
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 15),
              ),
            ),
            const SizedBox(height: 20),

            ElevatedButton.icon(
              icon: const Icon(Icons.people),
              label: const Text("View Students"),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ViewStudentsPage()),
                );
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 15),
              ),
            ),
            const SizedBox(height: 20),

            ElevatedButton.icon(
              icon: const Icon(Icons.logout),
              label: const Text("Logout"),
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/login');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                padding: const EdgeInsets.symmetric(vertical: 15),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class UploadQuizPage extends StatefulWidget {
  const UploadQuizPage({super.key});

  @override
  State<UploadQuizPage> createState() => _UploadQuizPageState();
}

class _UploadQuizPageState extends State<UploadQuizPage> {
  final TextEditingController _titleController = TextEditingController();
  bool _fileUploaded = false;

  void _uploadQuiz() {
    setState(() {
      _fileUploaded = true;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Quiz uploaded successfully!")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Upload Quiz"),
        backgroundColor: Colors.indigo,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: "Quiz Title",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              icon: const Icon(Icons.file_present),
              label: Text(_fileUploaded ? "File Uploaded" : "Choose File"),
              onPressed: _uploadQuiz,
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: _uploadQuiz,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 40),
              ),
              child: const Text("Submit Quiz"),
            ),
          ],
        ),
      ),
    );
  }
}

class ViewStudentsPage extends StatelessWidget {
  const ViewStudentsPage({super.key});

  final List<Map<String, String>> students = const [
    {'name': 'Juan Dela Cruz', 'status': 'Active'},
    {'name': 'Maria Santos', 'status': 'Active'},
    {'name': 'Carlos Reyes', 'status': 'Inactive'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Students List"),
        backgroundColor: Colors.indigo,
      ),
      body: ListView.builder(
        itemCount: students.length,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            child: ListTile(
              leading: const Icon(Icons.person),
              title: Text(students[index]['name']!),
              subtitle: Text('Status: ${students[index]['status']}'),
            ),
          );
        },
      ),
    );
  }
}

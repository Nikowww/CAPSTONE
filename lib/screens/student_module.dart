import 'package:flutter/material.dart';

// ==============================
// MODELS
// ==============================
class ClassModel {
  final String id;
  final String title;
  final String teacher;
  final String code;

  ClassModel({
    required this.id,
    required this.title,
    required this.teacher,
    required this.code,
  });
}

class Activity {
  final String id;
  final String title;
  final String description;
  final bool completed;
  final String? grade;

  Activity({
    required this.id,
    required this.title,
    required this.description,
    this.completed = false,
    this.grade,
  });
}

class Student {
  final String id;
  final String name;
  Student({required this.id, required this.name});
}

// ==============================
// SAMPLE DATA
// ==============================
final sampleClasses = <ClassModel>[
  ClassModel(id: 'c1', title: 'Math 101', teacher: 'Ms. Santos', code: 'MATH123'),
  ClassModel(id: 'c2', title: 'Science 7', teacher: 'Mr. Cruz', code: 'SCI777'),
];

final sampleActivities = <String, List<Activity>>{
  'c1': [
    Activity(id: 'a1', title: 'Act 1 - Algebra', description: 'Solve problems 1-10', completed: false),
    Activity(id: 'a2', title: 'Act 2 - Quiz', description: 'Online quiz', completed: true, grade: '90'),
  ],
  'c2': [
    Activity(id: 'b1', title: 'Lab Report', description: 'Write lab report', completed: true, grade: '85'),
  ],
};

final sampleStudents = <String, List<Student>>{
  'c1': [
    Student(id: 's1', name: 'Ana'),
    Student(id: 's2', name: 'Rico'),
    Student(id: 's3', name: 'Maya'),
  ],
  'c2': [
    Student(id: 's4', name: 'Jon'),
    Student(id: 's5', name: 'Liza'),
  ],
};

// ==============================
// STUDENT DASHBOARD
// ==============================
class StudentsHomepage extends StatelessWidget {
  const StudentsHomepage({super.key});

  void _logout(BuildContext context) {
    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
  }

  void _openMenu(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => const StudentMenuScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Dashboard'),
        actions: [
          IconButton(
            onPressed: () => _logout(context),
            icon: const Icon(Icons.logout),
            tooltip: "Logout",
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Text('Welcome, Student!',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () => _openMenu(context),
              icon: const Icon(Icons.menu),
              label: const Text('Open Menu'),
            ),
            const SizedBox(height: 12),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text('Enrolled Classes:',
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                itemCount: sampleClasses.length,
                itemBuilder: (context, i) {
                  final c = sampleClasses[i];
                  return Card(
                    child: ListTile(
                      title: Text(c.title),
                      subtitle: Text('Teacher: ${c.teacher} • Code: ${c.code}'),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => EnrolledClassScreen(classModel: c),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ==============================
// STUDENT MENU SCREEN
// ==============================
class StudentMenuScreen extends StatelessWidget {
  const StudentMenuScreen({super.key});

  void _joinByCode(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => const JoinByCodeScreen()));
  }

  void _joinByQR(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => const JoinByQRScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Menu')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () => _joinByCode(context),
              child: const ListTile(
                leading: Icon(Icons.code),
                title: Text('Join with Class Code'),
                subtitle: Text('Enter the teacher-provided class code'),
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () => _joinByQR(context),
              child: const ListTile(
                leading: Icon(Icons.qr_code),
                title: Text('Join with QR Code'),
                subtitle: Text('Scan QR to join'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ==============================
// JOIN CLASS BY CODE
// ==============================
class JoinByCodeScreen extends StatefulWidget {
  const JoinByCodeScreen({super.key});

  @override
  State<JoinByCodeScreen> createState() => _JoinByCodeScreenState();
}

class _JoinByCodeScreenState extends State<JoinByCodeScreen> {
  final _controller = TextEditingController();
  String? _message;

  void _tryJoin() {
    final code = _controller.text.trim();
    final found = sampleClasses.where((c) => c.code == code).toList();
    setState(() {
      if (found.isEmpty) {
        _message = 'Class not found for code: $code';
      } else {
        _message = 'Joined ${found.first.title}';
        Future.microtask(() {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => EnrolledClassScreen(classModel: found.first),
            ),
          );
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Join by Class Code')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(controller: _controller, decoration: const InputDecoration(labelText: 'Class Code')),
            const SizedBox(height: 12),
            ElevatedButton(onPressed: _tryJoin, child: const Text('Join')),
            if (_message != null) ...[
              const SizedBox(height: 12),
              Text(_message!, style: const TextStyle(color: Colors.green)),
            ],
          ],
        ),
      ),
    );
  }
}

// ==============================
// JOIN CLASS BY QR (DEMO ONLY)
// ==============================
class JoinByQRScreen extends StatelessWidget {
  const JoinByQRScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Join by QR Code')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Text('QR Scanner (mock)', style: TextStyle(fontSize: 16)),
            const SizedBox(height: 20),
            const Icon(Icons.qr_code_scanner, size: 120),
            const SizedBox(height: 12),
            const Text('This demo does not include a real scanner.'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => EnrolledClassScreen(classModel: sampleClasses.first)),
                );
              },
              child: const Text('Simulate Scan & Join First Class'),
            ),
          ],
        ),
      ),
    );
  }
}

// ==============================
// ENROLLED CLASS SCREEN
// ==============================
class EnrolledClassScreen extends StatefulWidget {
  final ClassModel classModel;
  const EnrolledClassScreen({super.key, required this.classModel});

  @override
  State<EnrolledClassScreen> createState() => _EnrolledClassScreenState();
}

class _EnrolledClassScreenState extends State<EnrolledClassScreen> {
  int _selectedTab = 0;

  void _openMeeting() {
    Navigator.push(context, MaterialPageRoute(builder: (_) => MeetingStreamScreen(classModel: widget.classModel)));
  }

  @override
  Widget build(BuildContext context) {
    final activities = sampleActivities[widget.classModel.id] ?? [];
    final people = sampleStudents[widget.classModel.id] ?? [];

    return Scaffold(
      appBar: AppBar(title: Text(widget.classModel.title)),
      body: Column(
        children: [
          ListTile(
            title: Text(widget.classModel.title, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text('Teacher: ${widget.classModel.teacher} • Code: ${widget.classModel.code}'),
            trailing: ElevatedButton.icon(onPressed: _openMeeting, icon: const Icon(Icons.video_call), label: const Text('Join Meeting')),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: ChoiceChip(label: const Text('Classworks'), selected: _selectedTab == 0, onSelected: (v) => setState(() => _selectedTab = 0)),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ChoiceChip(label: const Text('People'), selected: _selectedTab == 1, onSelected: (v) => setState(() => _selectedTab = 1)),
                ),
              ],
            ),
          ),
          Expanded(child: _selectedTab == 0 ? _buildClassworks(activities) : _buildPeople(people)),
        ],
      ),
    );
  }

  Widget _buildClassworks(List<Activity> activities) {
    final assigned = activities.where((a) => !a.completed).toList();
    final completed = activities.where((a) => a.completed).toList();

    return Padding(
      padding: const EdgeInsets.all(12),
      child: ListView(
        children: [
          const Text('Assigned', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          if (assigned.isEmpty) const Text('No assigned works.'),
          ...assigned.map((a) => Card(
                child: ListTile(
                  title: Text(a.title),
                  subtitle: Text(a.description),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => ActivityDetailScreen(activity: a)),
                  ),
                ),
              )),
          const SizedBox(height: 12),
          const Text('Completed', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          if (completed.isEmpty) const Text('No completed works.'),
          ...completed.map((a) => Card(
                child: ListTile(
                  title: Text(a.title),
                  subtitle: Text(a.description),
                  trailing: Text(a.grade ?? '-', style: const TextStyle(fontWeight: FontWeight.bold)),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => ActivityDetailScreen(activity: a)),
                  ),
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildPeople(List<Student> people) {
    if (people.isEmpty) return const Center(child: Text('No students yet.'));
    return ListView.separated(
      padding: const EdgeInsets.all(12),
      itemCount: people.length,
      separatorBuilder: (_, __) => const Divider(),
      itemBuilder: (context, i) {
        final s = people[i];
        return ListTile(
          leading: CircleAvatar(child: Text(s.name[0])),
          title: Text(s.name),
          subtitle: Text('Student ID: ${s.id}'),
          trailing: const Icon(Icons.message),
        );
      },
    );
  }
}

// ==============================
// MEETING SCREEN (DEMO)
// ==============================
class MeetingStreamScreen extends StatelessWidget {
  final ClassModel classModel;
  const MeetingStreamScreen({super.key, required this.classModel});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Meeting - ${classModel.title}')),
      body: const Center(
        child: Text('Meeting Stream Demo', style: TextStyle(fontSize: 18)),
      ),
    );
  }
}

// ==============================
// ACTIVITY DETAIL SCREEN
// ==============================
class ActivityDetailScreen extends StatelessWidget {
  final Activity activity;
  const ActivityDetailScreen({super.key, required this.activity});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(activity.title)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(activity.description),
            const SizedBox(height: 16),
            if (!activity.completed)
              ElevatedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Submitted (demo).')));
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.upload_file),
                label: const Text('Submit Work'),
              )
            else
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Status: Completed', style: TextStyle(color: Colors.green)),
                  const SizedBox(height: 8),
                  Text('Grade: ${activity.grade ?? '—'}'),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

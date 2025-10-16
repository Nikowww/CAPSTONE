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
    Activity(id: 'a1', title: 'Algebra HW', description: 'Solve problems 1-10', completed: false),
    Activity(id: 'a2', title: 'Math Quiz', description: 'Online quiz', completed: true, grade: '90'),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Student Dashboard')),
      drawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.indigo),
              child: Text('Student Menu', style: TextStyle(color: Colors.white, fontSize: 24)),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.checklist),
              title: const Text('To-Do'),
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ToDoScreen())),
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () => _logout(context),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Text('Welcome, Student!', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text('Enrolled Classes:', style: TextStyle(fontWeight: FontWeight.bold)),
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
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => EnrolledClassScreen(classModel: c)),
                      ),
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
// TO-DO SCREEN WITH TABS
// ==============================
class ToDoScreen extends StatelessWidget {
  const ToDoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('To-Do'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Assigned'),
              Tab(text: 'Missing'),
              Tab(text: 'Done'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            ToDoListTab(type: 'assigned'),
            ToDoListTab(type: 'missing'),
            ToDoListTab(type: 'done'),
          ],
        ),
      ),
    );
  }
}

class ToDoListTab extends StatelessWidget {
  final String type;
  const ToDoListTab({super.key, required this.type});

  List<Activity> _filterActivities() {
    List<Activity> all = sampleActivities.values.expand((e) => e).toList();
    switch (type) {
      case 'assigned':
        return all.where((a) => !a.completed).toList();
      case 'missing':
        // For demo, mark activities past due (simply using completed = false)
        return all.where((a) => !a.completed).toList();
      case 'done':
        return all.where((a) => a.completed).toList();
      default:
        return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    final tasks = _filterActivities();
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: tasks.length,
      itemBuilder: (context, i) {
        final t = tasks[i];
        return Card(
          color: type == 'done' ? Colors.green[50] : type == 'missing' ? Colors.red[50] : null,
          child: ListTile(
            leading: Icon(type == 'done'
                ? Icons.check_circle
                : type == 'missing'
                    ? Icons.error
                    : Icons.assignment,
                color: type == 'done'
                    ? Colors.green
                    : type == 'missing'
                        ? Colors.red
                        : Colors.indigo),
            title: Text(t.title),
            subtitle: Text(t.description),
            trailing: type == 'done' ? Text(t.grade ?? '-') : null,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => ActivityDetailScreen(activity: t)),
            ),
          ),
        );
      },
    );
  }
}

// ==============================
// ENROLLED CLASS SCREEN
// ==============================
class EnrolledClassScreen extends StatelessWidget {
  final ClassModel classModel;
  const EnrolledClassScreen({super.key, required this.classModel});

  @override
  Widget build(BuildContext context) {
    final activities = sampleActivities[classModel.id] ?? [];
    final students = sampleStudents[classModel.id] ?? [];

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(classModel.title),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Classworks'),
              Tab(text: 'People'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            ListView(
              padding: const EdgeInsets.all(12),
              children: activities.map((a) => Card(
                    child: ListTile(
                      title: Text(a.title),
                      subtitle: Text(a.description),
                      trailing: a.completed ? Text(a.grade ?? '-') : null,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => ActivityDetailScreen(activity: a)),
                      ),
                    ),
                  )).toList(),
            ),
            ListView(
              padding: const EdgeInsets.all(12),
              children: students.map((s) => ListTile(
                    leading: CircleAvatar(child: Text(s.name[0])),
                    title: Text(s.name),
                  )).toList(),
            ),
          ],
        ),
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

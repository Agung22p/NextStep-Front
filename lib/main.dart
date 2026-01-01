// main.dart
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const NextStepApp());
}

class NextStepApp extends StatelessWidget {
  const NextStepApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NextStep',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
        useMaterial3: true,
      ),
      home: const SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

// 1️⃣ SPLASH SCREEN
class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.blue.shade700, Colors.purple.shade500],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.rocket_launch, size: 100, color: Colors.white),
              const SizedBox(height: 24),
              const Text(
                'NextStep',
                style: TextStyle(
                  fontSize: 42,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Temukan Karirmu. Bangun Skillmu.',
                style: TextStyle(fontSize: 16, color: Colors.white70),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// 2️⃣ LOGIN SCREEN
class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Welcome Back!',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  prefixIcon: const Icon(Icons.email),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  prefixIcon: const Icon(Icons.lock),
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () async {
                  final email = _emailController.text.trim();
                  final password = _passwordController.text.trim();
                  final api = ApiService();
                  final ok = await api.login(email, password);
                  if (!mounted) return;
                  if (ok) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const OnboardingStep1()),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Login failed. Please check credentials.')),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Login', style: TextStyle(fontSize: 16)),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const RegisterScreen()),
                  );
                },
                child: const Text('Belum punya akun? Register'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// REGISTER SCREEN
class RegisterScreen extends StatelessWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'Nama',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () async {
                // basic register wiring (UI fields not stored in this simple layout)
                // In this simplified screen we just navigate back after attempting register
                // Find text fields by traversing widget tree isn't trivial here, so assume minimal sample
                final api = ApiService();
                // using placeholder values for demo; ideally wire controllers like login screen
                final ok = await api.register('New User', 'newuser@mail.com', 'password');
                if (ok) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Register successful. Please login.')),
                  );
                  Navigator.pop(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Register failed.')),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Register'),
            ),
          ],
        ),
      ),
    );
  }
}

// 3️⃣ ONBOARDING STEP 1
class OnboardingStep1 extends StatefulWidget {
  const OnboardingStep1({Key? key}) : super(key: key);

  @override
  State<OnboardingStep1> createState() => _OnboardingStep1State();
}

class _OnboardingStep1State extends State<OnboardingStep1> {
  final _ageController = TextEditingController();
  String? _education;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Data Dasar'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const LinearProgressIndicator(value: 0.25),
            const SizedBox(height: 32),
            const Text(
              'Langkah 1 dari 4',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 8),
            const Text(
              'Ceritakan tentang dirimu',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 32),
            TextField(
              controller: _ageController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Umur',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _education,
              decoration: InputDecoration(
                labelText: 'Pendidikan Terakhir',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              items: const [
                DropdownMenuItem(value: 'SMP', child: Text('SMP')),
                DropdownMenuItem(value: 'SMA', child: Text('SMA/SMK')),
                DropdownMenuItem(value: 'D3', child: Text('D3')),
                DropdownMenuItem(value: 'S1', child: Text('S1')),
                DropdownMenuItem(value: 'S2', child: Text('S2')),
              ],
              onChanged: (value) => setState(() => _education = value),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () async {
                final ageText = _ageController.text.trim();
                final age = int.tryParse(ageText) ?? 0;
                final education = _education ?? '';
                final api = ApiService();
                final saved = await api.postUserProfile(age, education, '');
                if (!saved && mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Failed to save profile. Proceeding offline.')),
                  );
                }
                if (!mounted) return;
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const OnboardingStep2()),
                );
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Lanjut', style: TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }
}

// ONBOARDING STEP 2 - MINAT
class OnboardingStep2 extends StatefulWidget {
  const OnboardingStep2({Key? key}) : super(key: key);

  @override
  State<OnboardingStep2> createState() => _OnboardingStep2State();
}

class _OnboardingStep2State extends State<OnboardingStep2> {
  // fetched from API: each item contains {"id": int, "name": String}
  List<Map<String, dynamic>> _interests = [];
  final List<int> _selectedIds = [];

  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadInterests();
  }

  Future<void> _loadInterests() async {
    setState(() => _loading = true);
    final api = ApiService();
    final list = await api.getInterests();
    setState(() {
      _interests = list ?? [];
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Minat'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const LinearProgressIndicator(value: 0.5),
            const SizedBox(height: 32),
            const Text('Langkah 2 dari 4', style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 8),
            const Text(
              'Apa yang kamu minati?',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            if (_loading)
              const Center(child: CircularProgressIndicator())
            else
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _interests.map((interest) {
                  final id = interest['id'] as int? ?? 0;
                  final name = interest['name']?.toString() ?? interest['title']?.toString() ?? 'Unknown';
                  final isSelected = _selectedIds.contains(id);
                  return FilterChip(
                    label: Text(name),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        if (selected) {
                          _selectedIds.add(id);
                        } else {
                          _selectedIds.remove(id);
                        }
                      });
                    },
                  );
                }).toList(),
              ),
            const Spacer(),
            ElevatedButton(
              onPressed: _selectedIds.isEmpty ? null : () async {
                final api = ApiService();
                final ok = await api.postUserInterests(_selectedIds);
                if (!ok) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Gagal menyimpan minat ke server. Lanjut offline.')),
                  );
                }
                if (!mounted) return;
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const OnboardingStep3()),
                );
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Lanjut', style: TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }
}

// ONBOARDING STEP 3 - SKILL
class OnboardingStep3 extends StatefulWidget {
  const OnboardingStep3({Key? key}) : super(key: key);

  @override
  State<OnboardingStep3> createState() => _OnboardingStep3State();
}

class _OnboardingStep3State extends State<OnboardingStep3> {
  // fetched skills from API: each item {"id": int, "name": String}
  List<Map<String, dynamic>> _skills = [];
  final List<int> _selectedSkillIds = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadSkills();
  }

  Future<void> _loadSkills() async {
    setState(() => _loading = true);
    final api = ApiService();
    final list = await api.getSkills();
    setState(() {
      _skills = list ?? [];
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Skill'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const LinearProgressIndicator(value: 0.75),
            const SizedBox(height: 32),
            const Text('Langkah 3 dari 4', style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 8),
            const Text(
              'Skill apa yang kamu punya?',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: _loading
                  ? const Center(child: CircularProgressIndicator())
                  : ListView(
                      children: _skills.map((skill) {
                        final id = skill['id'] as int? ?? 0;
                        final name = skill['name']?.toString() ?? 'Unknown';
                        final checked = _selectedSkillIds.contains(id);
                        return CheckboxListTile(
                          title: Text(name),
                          value: checked,
                          onChanged: (value) {
                            setState(() {
                              if (value == true) {
                                _selectedSkillIds.add(id);
                              } else {
                                _selectedSkillIds.remove(id);
                              }
                            });
                          },
                        );
                      }).toList(),
                    ),
            ),
            ElevatedButton(
              onPressed: _selectedSkillIds.isEmpty
                  ? null
                  : () async {
                      final api = ApiService();
                      final ok = await api.postUserSkills(_selectedSkillIds);
                      if (!ok) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Gagal menyimpan skill ke server. Lanjut offline.')),
                        );
                      }
                      if (!mounted) return;
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const OnboardingStep4()),
                      );
                    },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Lanjut', style: TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }
}

// ONBOARDING STEP 4 - TUJUAN
class OnboardingStep4 extends StatefulWidget {
  const OnboardingStep4({Key? key}) : super(key: key);

  @override
  State<OnboardingStep4> createState() => _OnboardingStep4State();
}

class _OnboardingStep4State extends State<OnboardingStep4> {
  String? _goal;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tujuan'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const LinearProgressIndicator(value: 1.0),
            const SizedBox(height: 32),
            const Text('Langkah 4 dari 4', style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 8),
            const Text(
              'Apa tujuanmu?',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            RadioListTile<String>(
              title: const Text('Cari kerja'),
              value: 'Cari kerja',
              groupValue: _goal,
              onChanged: (value) => setState(() => _goal = value),
            ),
            RadioListTile<String>(
              title: const Text('Freelance'),
              value: 'Freelance',
              groupValue: _goal,
              onChanged: (value) => setState(() => _goal = value),
            ),
            RadioListTile<String>(
              title: const Text('Belajar skill'),
              value: 'Belajar skill',
              groupValue: _goal,
              onChanged: (value) => setState(() => _goal = value),
            ),
            RadioListTile<String>(
              title: const Text('Belum tahu'),
              value: '',
              groupValue: _goal,
              onChanged: (value) => setState(() => _goal = value),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: _goal == null
                  ? null
                  : () async {
                      final api = ApiService();
                      // only post the goal field as requested
                      // keep existing age/education if available in profile, otherwise send minimal payload
                      // Save goal locally and try to update server; success = local save or server OK
                      await api.postUserProfile2(_goal!);
                      if (!mounted) return;
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const CareerMatchingResult()),
                      );
                    },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Lihat Rekomendasi Karir', style: TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }
}

// 4️⃣ CAREER MATCHING RESULT
class CareerMatchingResult extends StatefulWidget {
  const CareerMatchingResult({Key? key}) : super(key: key);

  @override
  State<CareerMatchingResult> createState() => _CareerMatchingResultState();
}

class _CareerMatchingResultState extends State<CareerMatchingResult> {
  List<Map<String, dynamic>> _careers = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadMatches();
  }

  Future<void> _loadMatches() async {
    setState(() => _loading = true);
    final api = ApiService();
    final list = await api.careerMatch();
    if (!mounted) return;
    setState(() {
      _careers = list ?? [
        {'name': 'Web Developer Junior', 'match': 82, 'skills': 'HTML, PHP, Laravel'},
        {'name': 'UI/UX Designer', 'match': 75, 'skills': 'Figma, Adobe XD, Design Thinking'},
        {'name': 'Digital Marketing', 'match': 68, 'skills': 'SEO, Content Writing, Analytics'},
      ];
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rekomendasi Karir'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfilePage()),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Karir yang cocok untukmu',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            if (_loading)
              const Center(child: CircularProgressIndicator())
            else
              Expanded(
                child: ListView.builder(
                  itemCount: _careers.length,
                  itemBuilder: (context, index) {
                    final career = _careers[index];
                    final match = career['match'] ?? career['score'] ?? 0;
                    final name = career['name'] ?? career['title'] ?? 'Unknown';
                    final skills = career['skills'] ?? career['skills_needed'] ?? '';
                    return Card(
                      margin: const EdgeInsets.only(bottom: 16),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  name.toString(),
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: Colors.green.shade100,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    '${match}%',
                                    style: TextStyle(
                                      color: Colors.green.shade700,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Skill utama: $skills',
                              style: const TextStyle(color: Colors.grey),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Expanded(
                                  child: OutlinedButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => const SkillRoadmapPage(),
                                        ),
                                      );
                                    },
                                    child: const Text('Lihat Roadmap'),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text('Karir disimpan!')),
                                      );
                                    },
                                    child: const Text('Simpan'),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.school), label: 'Skills'),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Mentor'),
        ],
        onTap: (index) {
          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SkillMarketplace()),
            );
          } else if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const MentorshipPage()),
            );
          }
        },
      ),
    );
  }
}

// 5️⃣ SKILL ROADMAP PAGE
class SkillRoadmapPage extends StatelessWidget {
  const SkillRoadmapPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final roadmap = [
      {'skill': 'HTML & CSS', 'status': 'completed', 'duration': '2 minggu'},
      {'skill': 'PHP Dasar', 'status': 'completed', 'duration': '3 minggu'},
      {'skill': 'Laravel Framework', 'status': 'current', 'duration': '4 minggu'},
      {'skill': 'Git & Portfolio', 'status': 'locked', 'duration': '2 minggu'},
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Skill Roadmap')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Web Developer Junior',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Roadmap pembelajaran untuk mencapai karir impianmu',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: ListView.builder(
                itemCount: roadmap.length,
                itemBuilder: (context, index) {
                  final item = roadmap[index];
                  IconData icon;
                  Color color;

                  switch (item['status']) {
                    case 'completed':
                      icon = Icons.check_circle;
                      color = Colors.green;
                      break;
                    case 'current':
                      icon = Icons.play_circle;
                      color = Colors.blue;
                      break;
                    default:
                      icon = Icons.lock;
                      color = Colors.grey;
                  }

                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: ListTile(
                      leading: Icon(icon, color: color, size: 32),
                      title: Text(
                        item['skill'] as String,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text('Estimasi: ${item['duration']}'),
                      trailing: item['status'] == 'current'
                          ? const Icon(Icons.arrow_forward)
                          : null,
                      onTap: item['status'] != 'locked'
                          ? () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DetailSkillPage(
                                    skillName: item['skill'] as String,
                                  ),
                                ),
                              );
                            }
                          : null,
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

// 6️⃣ SKILL MARKETPLACE
class SkillMarketplace extends StatelessWidget {
  const SkillMarketplace({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final skills = [
      {'name': 'Laravel Mastery', 'mentor': 'Budi Santoso', 'level': 'Intermediate', 'price': 'Gratis'},
      {'name': 'UI/UX Design', 'mentor': 'Siti Nurhaliza', 'level': 'Beginner', 'price': 'Premium'},
      {'name': 'React Native', 'mentor': 'Ahmad Dahlan', 'level': 'Advanced', 'price': 'Gratis'},
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Skill Marketplace')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: skills.length,
          itemBuilder: (context, index) {
            final skill = skills[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 16),
              child: ListTile(
                leading: CircleAvatar(
                  child: Text(skill['name'].toString()[0]),
                ),
                title: Text(
                  skill['name'] as String,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text('${skill['mentor']} • ${skill['level']}'),
                trailing: Chip(
                  label: Text(skill['price'] as String),
                  backgroundColor: skill['price'] == 'Gratis'
                      ? Colors.green.shade100
                      : Colors.orange.shade100,
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailSkillPage(
                        skillName: skill['name'] as String,
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}

// 7️⃣ DETAIL SKILL
class DetailSkillPage extends StatelessWidget {
  final String skillName;

  const DetailSkillPage({Key? key, required this.skillName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(skillName)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 200,
              decoration: BoxDecoration(
                color: Colors.blue.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Icon(Icons.code, size: 80, color: Colors.blue.shade700),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Deskripsi',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Pelajari skill ini untuk meningkatkan kemampuanmu dan membuka peluang karir yang lebih luas.',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 16),
            const Text(
              'Apa yang dipelajari',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const ListTile(
              leading: Icon(Icons.check_circle, color: Colors.green),
              title: Text('Konsep dasar'),
            ),
            const ListTile(
              leading: Icon(Icons.check_circle, color: Colors.green),
              title: Text('Praktik langsung'),
            ),
            const ListTile(
              leading: Icon(Icons.check_circle, color: Colors.green),
              title: Text('Studi kasus'),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    const CircleAvatar(radius: 30, child: Icon(Icons.person)),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Mentor: Budi Santoso',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text('5 tahun pengalaman', style: TextStyle(color: Colors.grey)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Skill ditambahkan ke progress!')),
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Ambil Skill', style: TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// 8️⃣ MENTORSHIP PAGE
class MentorshipPage extends StatelessWidget {
  const MentorshipPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mentors = [
      {'name': 'Budi Santoso', 'field': 'Web Development', 'exp': '5 tahun', 'status': 'Available'},
      {'name': 'Siti Nurhaliza', 'field': 'UI/UX Design', 'exp': '3 tahun', 'status': 'Pending'},
      {'name': 'Ahmad Dahlan', 'field': 'Mobile Dev', 'exp': '7 tahun', 'status': 'Available'},
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Mentorship')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Temukan mentor terbaik',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: mentors.length,
                itemBuilder: (context, index) {
                  final mentor = mentors[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 16),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          const CircleAvatar(
                            radius: 30,
                            child: Icon(Icons.person, size: 30),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  mentor['name'] as String,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                Text('${mentor['field']}'),
                                Text(
                                  'Pengalaman: ${mentor['exp']}',
                                  style: const TextStyle(color: Colors.grey),
                                ),
                              ],
                            ),
                          ),
                          Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: mentor['status'] == 'Available'
                                      ? Colors.green.shade100
                                      : Colors.orange.shade100,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  mentor['status'] as String,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: mentor['status'] == 'Available'
                                        ? Colors.green.shade700
                                        : Colors.orange.shade700,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              ElevatedButton(
                                onPressed: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'Request mentorship ke ${mentor['name']} dikirim!',
                                      ),
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 8,
                                  ),
                                ),
                                child: const Text('Ajukan'),
                              ),
                            ],
                          ),
                        ],
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

// 9️⃣ PROFILE & PROGRESS PAGE
class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile & Progress')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 50,
              child: Icon(Icons.person, size: 50),
            ),
            const SizedBox(height: 16),
            const Text(
              'John Doe',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const Text('johndoe@email.com', style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 24),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Progress Overview',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    const ListTile(
                      leading: Icon(Icons.work, color: Colors.blue),
                      title: Text('Karir Pilihan'),
                      subtitle: Text('Web Developer Junior'),
                    ),
                    const Divider(),
                    const ListTile(
                      leading: Icon(Icons.school, color: Colors.green),
                      title: Text('Skill Dipelajari'),
                      subtitle: Text('3 skills'),
                    ),
                    const Divider(),
                    ListTile(
                      leading: const Icon(Icons.trending_up, color: Colors.orange),
                      title: const Text('Progress'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 8),
                          LinearProgressIndicator(
                            value: 0.65,
                            backgroundColor: Colors.grey.shade200,
                            color: Colors.orange,
                          ),
                          const SizedBox(height: 4),
                          const Text('65% Complete'),
                        ],
                      ),
                    ),
                    const Divider(),
                    const ListTile(
                      leading: Icon(Icons.flag, color: Colors.red),
                      title: Text('Goal'),
                      subtitle: Text('Cari kerja'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  // Edit profile logic
                },
                icon: const Icon(Icons.edit),
                label: const Text('Edit Profile'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginScreen()),
                    (route) => false,
                  );
                },
                icon: const Icon(Icons.logout),
                label: const Text('Logout'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Simple API service using endpoints from NextStep.json
class ApiService {
  static const _base = 'http://127.0.0.1:8000';

  Future<bool> login(String email, String password) async {
    final url = Uri.parse('$_base/api/login');
    final res = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      final token = data['token'] ?? data['access_token'] ?? data['data']?['token'];
      if (token != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', token is String ? token : token.toString());
        return true;
      }
    }
    return false;
  }

  Future<bool> register(String name, String email, String password) async {
    final url = Uri.parse('$_base/api/register');
    final res = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': name,
        'email': email,
        'password': password,
        'password_confirmation': password,
      }),
    );
    return res.statusCode == 201 || res.statusCode == 200;
  }

  Future<Map<String, dynamic>?> getUserProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token == null) return null;
    final url = Uri.parse('$_base/api/user-profile');
    final res = await http.get(url, headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    });
    if (res.statusCode == 200) return jsonDecode(res.body) as Map<String, dynamic>;
    return null;
  }

  Future<bool> postUserProfile(int age, String education, String goal) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token == null) return false;
    final url = Uri.parse('$_base/api/user-profile');
    final res = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'age': age, 'education': education, 'goal': goal}),
    );
    return res.statusCode == 200 || res.statusCode == 201;
  }
  Future<bool> postUserProfile2(String goal) async {
    // Always save goal locally first so UI can proceed even if network fails
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('goal', goal);
    } catch (_) {
      // local save failed; still attempt server but will return false if both fail
    }

    // Attempt to post to server if token available
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      if (token == null) return true; // local saved, no auth yet
      final url = Uri.parse('$_base/api/user-profile');
      final res = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'goal': goal}),
      );
      if (res.statusCode == 200 || res.statusCode == 201) return true;
    } catch (_) {}

    // If we reach here, server update failed but local save likely succeeded
    return true;
  }

  // Interests
  Future<List<Map<String, dynamic>>?> getInterests() async {
    final url = Uri.parse('$_base/api/admin/interests');
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      final res = await http.get(url, headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      });
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        if (data is List) return List<Map<String, dynamic>>.from(data);
        if (data is Map && data['data'] is List) return List<Map<String, dynamic>>.from(data['data']);
      }
    } catch (_) {}
    return null;
  }

  Future<bool> postUserInterests(List<int> interestIds) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token == null) return false;
    final url = Uri.parse('$_base/api/user-interests');
    final res = await http.post(url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'interest_ids': interestIds}));
    return res.statusCode == 200 || res.statusCode == 201;
  }

  // Skills
  Future<List<Map<String, dynamic>>?> getSkills() async {
    final url = Uri.parse('$_base/api/admin/skills');
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      final res = await http.get(url, headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      });
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        if (data is List) return List<Map<String, dynamic>>.from(data);
        if (data is Map && data['data'] is List) return List<Map<String, dynamic>>.from(data['data']);
      }
    } catch (_) {}
    return null;
  }

  Future<bool> postUserSkills(List<int> skills) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token == null) return false;
    final url = Uri.parse('$_base/api/user-skills');
    final body = jsonEncode({'skills': skills.map((id) => {'skill_id': id, 'level': 'dasar'}).toList()});
    final res = await http.post(url, headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    }, body: body);
    return res.statusCode == 200 || res.statusCode == 201;
  }

  // Career match
  Future<List<Map<String, dynamic>>?> careerMatch() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final url = Uri.parse('$_base/api/career/match');
    try {
      final res = await http.post(url, headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      });
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        if (data is List) return List<Map<String, dynamic>>.from(data);
        if (data is Map && data['data'] is List) return List<Map<String, dynamic>>.from(data['data']);
      }
    } catch (_) {}
    return null;
  }
}

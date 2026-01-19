import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'splash_screen.dart';
import 'role_selection_screen.dart';
import 'login_screen.dart';
import 'forgot_password_screen.dart';
import 'student/student_dashboard.dart';
import 'student/notification_screen.dart';
import 'student/attendance_screen.dart';
import 'student/courses_screen.dart';
import 'student/timetable_screen.dart';
import 'student/doubt_lecture_screen.dart';
import 'student/assignments_screen.dart';
import 'student/doubts_screen.dart';
import 'student/test_portal_screen.dart';
import 'student/result.dart';
import 'student/feedback_screen.dart';
import 'parent/parent_dashboard.dart';
import 'parent/parent_notification_screen.dart';
import 'parent/parent_child_controller.dart';
import 'Teacher/teacher_dashboard_screen.dart';

void main() {
  // Initialize ParentChildController globally
  Get.put(ParentChildController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'EduMunch',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF7C3AED),
          brightness: Brightness.light,
          primary: const Color(0xFF7C3AED),
        ),
        primaryColor: const Color(0xFF7C3AED),
        textTheme: const TextTheme(
          displayLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, letterSpacing: -0.5),
          displayMedium: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, letterSpacing: -0.5),
          displaySmall: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, letterSpacing: -0.25),
          headlineLarge: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          headlineMedium: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
          headlineSmall: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          titleLarge: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, letterSpacing: 0.15),
          titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, letterSpacing: 0.15),
          titleSmall: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, letterSpacing: 0.1),
          bodyLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, letterSpacing: 0.5),
          bodyMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, letterSpacing: 0.25),
          bodySmall: TextStyle(fontSize: 12, fontWeight: FontWeight.w400, letterSpacing: 0.4),
          labelLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, letterSpacing: 1.25),
          labelMedium: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, letterSpacing: 1.25),
          labelSmall: TextStyle(fontSize: 11, fontWeight: FontWeight.w500, letterSpacing: 1.5),
        ),
      ),
      home: const SplashScreen(),
      getPages: [
        GetPage(
          name: '/login',
          page: () {
            final role = Get.arguments as String? ?? 'Student';
            return LoginScreen(role: role);
          },
        ),
        GetPage(name: '/forgot-password', page: () => const ForgotPasswordScreen()),
        GetPage(name: '/role-selection', page: () => const RoleSelectionScreen()),
        GetPage(name: '/dashboard', page: () => const StudentDashboard()),
        GetPage(name: '/parent-dashboard', page: () => const ParentDashboard()),
        GetPage(name: '/teacher-dashboard', page: () => const TeacherDashboardScreen()),
        GetPage(name: '/notifications', page: () => const NotificationScreen()),
        GetPage(name: '/attendance', page: () => const AttendanceScreen()),
        GetPage(name: '/courses', page: () => const CoursesScreen()),
        GetPage(name: '/timetable', page: () => const TimetableScreen()),
        GetPage(name: '/doubt-lecture', page: () => const DoubtLectureScreen()),
        GetPage(name: '/assignments', page: () => const AssignmentsScreen()),
        GetPage(name: '/doubts', page: () => const DoubtsScreen()),
        GetPage(name: '/test-portal', page: () => const TestPortalScreen()),
        GetPage(name: '/academic-performance', page: () => const AcademicPerformanceScreen()),
        GetPage(name: '/result', page: () => const AcademicPerformanceScreen()),
        GetPage(name: '/feedback', page: () => const FeedbackScreen()),
        GetPage(name: '/parent-notification', page: () => const ParentNotificationScreen()),
        GetPage(name: '/home', page: () => const MyHomePage(title: 'EduMunch')),
      ],
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('You have pushed the button this many times:'),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'supabase_config.dart';
import 'auth_controller.dart';
import 'splash_screen.dart';
import 'login_screen.dart';
import 'signup_screen.dart';
import 'forgot_password_screen.dart';

// Student screens
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

// Parent screens
import 'Parent/parent_dashboard.dart';
import 'Parent/parent_notification_screen.dart';
import 'Parent/parent_attendance_screen.dart';
import 'Parent/parent_performance_screen.dart';
import 'Parent/parent_payment_screen.dart';
import 'Parent/parent_grievance_screen.dart';
import 'Parent/parent_ptm_screen.dart';
import 'Parent/parent_timetable_screen.dart';
import 'Parent/parent_child_controller.dart';

// Teacher screens
import 'Teacher/teacher_dashboard_screen.dart';
import 'Teacher/teacher_notification_screen.dart';
import 'Teacher/manage_attendance_screen.dart';
import 'Teacher/assignments_list_screen.dart';
import 'Teacher/create_assignment_template_screen.dart';
import 'Teacher/syllabus_tracking_screen.dart';
import 'Teacher/teacher_doubts_screen.dart';
import 'Teacher/teacher_timetable_screen.dart';
import 'Teacher/student_performance_screen.dart';
import 'Teacher/hr_section_screen.dart';
import 'Teacher/upload_assignment_screen.dart';

import 'middleware/auth_middleware.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (SupabaseConfig.isConfigured) {
    try {
      await Supabase.initialize(
        url: SupabaseConfig.url,
        anonKey: SupabaseConfig.anonKey,
      );
      print('Supabase initialized successfully with project URL: ${SupabaseConfig.url}');
    } catch (e) {
      print('Supabase initialization failed: $e');
    }
  } else {
    print('Supabase credentials not configured in lib/supabase_config.dart. Running in offline/demo mode.');
  }

  // Initialize controllers globally
  Get.put(ParentChildController());
  final authController = Get.put(AuthController(), permanent: true);
  try {
    await authController.initFromSupabase();
  } catch (e) {
    print('Auth init warning: $e');
  }
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
        scaffoldBackgroundColor: const Color(0xFFE8EEF5),
        brightness: Brightness.light,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF381868),
          brightness: Brightness.light,
          primary: const Color(0xFF381868),
          surface: const Color(0xFFE8EEF5),
        ),
        primaryColor: const Color(0xFF381868),
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
          page: () => const LoginScreen(),
        ),
        GetPage(name: '/signup', page: () => const SignupScreen()),
        GetPage(name: '/forgot-password', page: () => const ForgotPasswordScreen()),

        // Student Pages
        GetPage(
          name: '/dashboard',
          page: () => const StudentDashboard(),
          middlewares: [AuthMiddleware()],
        ),
        GetPage(
          name: '/notifications',
          page: () => const NotificationScreen(),
          middlewares: [AuthMiddleware()],
        ),
        GetPage(
          name: '/attendance',
          page: () => const AttendanceScreen(),
          middlewares: [AuthMiddleware()],
        ),
        GetPage(
          name: '/courses',
          page: () => const CoursesScreen(),
          middlewares: [AuthMiddleware()],
        ),
        GetPage(
          name: '/timetable',
          page: () => const TimetableScreen(),
          middlewares: [AuthMiddleware()],
        ),
        GetPage(
          name: '/doubt-lecture',
          page: () => const DoubtLectureScreen(),
          middlewares: [AuthMiddleware()],
        ),
        GetPage(
          name: '/assignments',
          page: () => const AssignmentsScreen(),
          middlewares: [AuthMiddleware()],
        ),
        GetPage(
          name: '/doubts',
          page: () => const DoubtsScreen(),
          middlewares: [AuthMiddleware()],
        ),
        GetPage(
          name: '/test-portal',
          page: () => const TestPortalScreen(),
          middlewares: [AuthMiddleware()],
        ),
        GetPage(
          name: '/academic-performance',
          page: () => const AcademicPerformanceScreen(),
          middlewares: [AuthMiddleware()],
        ),
        GetPage(
          name: '/result',
          page: () => const AcademicPerformanceScreen(),
          middlewares: [AuthMiddleware()],
        ),
        GetPage(
          name: '/feedback',
          page: () => const FeedbackScreen(),
          middlewares: [AuthMiddleware()],
        ),

        // Parent Pages
        GetPage(
          name: '/parent-dashboard',
          page: () => const ParentDashboard(),
          middlewares: [AuthMiddleware()],
        ),
        GetPage(
          name: '/parent-notification',
          page: () => const ParentNotificationScreen(),
          middlewares: [AuthMiddleware()],
        ),
        GetPage(
          name: '/parent-attendance',
          page: () => const ParentAttendanceScreen(),
          middlewares: [AuthMiddleware()],
        ),
        GetPage(
          name: '/parent-performance',
          page: () => const ParentPerformanceScreen(),
          middlewares: [AuthMiddleware()],
        ),
        GetPage(
          name: '/payments',
          page: () => const ParentPaymentScreen(),
          middlewares: [AuthMiddleware()],
        ),
        GetPage(
          name: '/parent-grievance',
          page: () => const ParentGrievanceScreen(),
          middlewares: [AuthMiddleware()],
        ),
        GetPage(
          name: '/ptm',
          page: () => const ParentPTMScreen(),
          middlewares: [AuthMiddleware()],
        ),
        GetPage(
          name: '/parent-timetable',
          page: () => const ParentTimetableScreen(),
          middlewares: [AuthMiddleware()],
        ),

        // Teacher Pages
        GetPage(
          name: '/teacher-dashboard',
          page: () => const TeacherDashboardScreen(),
          middlewares: [AuthMiddleware()],
        ),
        GetPage(
          name: '/teacher-notification',
          page: () => const TeacherNotificationScreen(),
          middlewares: [AuthMiddleware()],
        ),
        GetPage(
          name: '/manage-attendance',
          page: () => const ManageAttendanceScreen(),
          middlewares: [AuthMiddleware()],
        ),
        GetPage(
          name: '/assignments-list',
          page: () => const AssignmentsListScreen(),
          middlewares: [AuthMiddleware()],
        ),
        GetPage(
          name: '/create-assignment-template',
          page: () => const CreateAssignmentTemplateScreen(),
          middlewares: [AuthMiddleware()],
        ),
        GetPage(
          name: '/syllabus-tracking',
          page: () => const SyllabusTrackingScreen(),
          middlewares: [AuthMiddleware()],
        ),
        GetPage(
          name: '/teacher-doubts',
          page: () => const TeacherDoubtsScreen(),
          middlewares: [AuthMiddleware()],
        ),
        GetPage(
          name: '/teacher-timetable',
          page: () => const TeacherTimetableScreen(),
          middlewares: [AuthMiddleware()],
        ),
        GetPage(
          name: '/teacher-performance',
          page: () => const StudentPerformanceScreen(),
          middlewares: [AuthMiddleware()],
        ),
        GetPage(
          name: '/student-performance',
          page: () => const StudentPerformanceScreen(),
          middlewares: [AuthMiddleware()],
        ),
        GetPage(
          name: '/hr-section',
          page: () => const HRSectionScreen(),
          middlewares: [AuthMiddleware()],
        ),
        GetPage(
          name: '/upload-assignment',
          page: () => const UploadAssignmentScreen(),
          middlewares: [AuthMiddleware()],
        ),

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

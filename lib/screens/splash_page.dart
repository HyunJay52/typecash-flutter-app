// import 'package:flutter/material.dart';
// // import 'package:shared_preferences/shared_preferences.dart';
// // import 'package:supabase_flutter/supabase_flutter.dart';

// class SplashPage extends StatefulWidget {
//   static const routeName = '/splash';
//   @override
//   _SplashPageState createState() => _SplashPageState();
// }

// class _SplashPageState extends State<SplashPage> {
//   // final SupabaseClient _supabaseClient = Supabase.instance.client;

//   @override
//   void initState() {
//     super.initState();
//     _checkLocalData();
//   }

//   Future<void> _checkLocalData() async {
//     // final SharedPreferences prefs = await SharedPreferences.getInstance();
//     // final hasLocalData = prefs.getBool('isLoggedIn') ?? false;

//     // if (hasLocalData) {
//     if(true) {
//       // Local data indicates user is logged in, navigate to main service page
//       Navigator.pushReplacementNamed(context, '/main');
//     } else {
//       // Check Supabase for login session
//       _checkSupabaseLoginStatus();
//     }
//   }

//   Future<void> _checkSupabaseLoginStatus() async {
//     final session = true;
//     // _supabaseClient.auth.currentSession;

//     if (session == null) {
//       // No login data, navigate to login page
//       Navigator.pushReplacementNamed(context, '/login');
//     } else {
//       // Login data exists, navigate to main service page
//       Navigator.pushReplacementNamed(context, '/main');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(body: Center(child: CircularProgressIndicator()));
//   }
// }

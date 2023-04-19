import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final emailController = TextEditingController();
  final tokenController = TextEditingController();
  late SupabaseClient supabase;

  String anonKey = "";
  String url = "";

  @override
  void initState() {
    super.initState();
    setupSupabase();
  }

  setupSupabase() async {
    final supabaseFuture = await Supabase.initialize(
      url: url,
      anonKey: anonKey,
    );

    supabase = supabaseFuture.client;
  }

  _sendEmail(String email) async {
    try {
      debugPrint("_sendEmail: $email");
      await supabase.auth.signInWithOtp(email: email);
    } on Exception catch (e) {
      debugPrint("Exception sendLoginEmail: $e");
    }
  }

  _verifyAccountWithMagicLink() async {
    try {
      final token = tokenController.text;
      debugPrint("_verifyAccountWithMagicLink, $token");
      final response = await supabase.auth.verifyOTP(email: "guusiwanow+5@gmail.com", token: token, type: OtpType.signup);
      return response;
    } on Exception catch (e) {
      debugPrint("Exception verifyAccountWithMagicLink: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Test supabase',
            ),
            SizedBox(height: 100),
            SizedBox(
              width: 300,
              child: TextField(
                decoration: InputDecoration.collapsed(hintText: 'E-mail input'),
                textAlign: TextAlign.center,
                controller: emailController,
              ),
            ),
            TextButton(onPressed: () => _sendEmail(emailController.text), child: Text("Send E-mail")),
            SizedBox(
              width: 300,
              child: TextField(
                decoration: new InputDecoration.collapsed(hintText: 'Token input'),
                textAlign: TextAlign.center,
                controller: tokenController,
              ),
            ),
            TextButton(onPressed: () => _verifyAccountWithMagicLink(), child: Text("Verify token")),
          ],
        ),
      ),
    );
  }
}

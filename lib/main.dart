import 'package:demonotes/services/auth/auth_service.dart';
import 'package:demonotes/views/login_view.dart';
import 'package:demonotes/views/notes/create_update_note_view.dart';
import 'package:demonotes/views/notes/notes_view.dart';
import 'package:demonotes/views/register_view.dart';
import 'package:demonotes/views/verify_email_view.dart';
import 'package:flutter/material.dart';

import 'constants/routes.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: const HomePage(),
      routes: {
        notesRoute: (context) => const NotesView(),
        loginRoute: (context) => const LoginView(),
        registerRoute: (context) => const RegisterView(),
        verifyEmailRoute: (context) => const VerifyEmailView(),
        createOrUpdateNoteRoute: (context) => const CreateUpdateNoteView(),
      },
    ),
  );
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: AuthService.firebase().initialize(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            final user = AuthService.firebase().currentUser;
            if (user != null) {
              if (user.isEmailVerified) {
                return const NotesView();
              } else {
                return const VerifyEmailView();
              }
            } else {
              return const LoginView();
            }
          default:
            return const Scaffold(
                body: Center(child: CircularProgressIndicator()));
        }
      },
    );
  }
}

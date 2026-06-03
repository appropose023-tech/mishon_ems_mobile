import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app_state.dart';
import 'screens/login_screen.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => EMSStateEngine(),
      child: const MishonSolutionsEMSApplicationRoot(),
    ),
  );
}

class MishonSolutionsEMSApplicationRoot extends StatelessWidget {
  const MishonSolutionsEMSApplicationRoot({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mishon Solutions EMS',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF008080),
        scaffoldBackgroundColor: const Color(0xFFF8FAFC),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF008080),
          primary: const Color(0xFF008080),
          secondary: const Color(0xFF004d4d),
        ),
        useMaterial3: true,
      ),
      home: const IdentityGatewayPortal(),
    );
  }
}

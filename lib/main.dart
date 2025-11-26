import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';

// Imports dos teus arquivos
import 'repositories/book_repository.dart';
import 'repositories/theme_provider.dart';
import 'screens/books_page.dart';
import 'models/book.dart';
import 'models/annotation.dart';
import 'models/review.dart';

// Import da nova tela de Login
import 'screens/login_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializa o Hive (Essencial para o CRUD funcionar)
  await Hive.initFlutter();

  // Registra os adaptadores
  Hive.registerAdapter(LivroAdapter());
  Hive.registerAdapter(AnotacaoAdapter());
  Hive.registerAdapter(ReviewAdapter());

  // Abre box de configurações para evitar flicker ao aplicar o tema salvoawait Hive.openBox('app_settings');
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => BookRepository()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: const MeuApp(),
    ),
  );
}

class MeuApp extends StatelessWidget {
  const MeuApp({super.key});

  ThemeData _lightTheme() {
    return ThemeData(
      scaffoldBackgroundColor: const Color(0xFFF7F3EC),
      colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF4A768A)),
      useMaterial3: true,

      // Textos
      textTheme: const TextTheme(
        titleLarge: TextStyle(
          color: Color(0xFFA66841),
          fontWeight: FontWeight.bold,
        ),
        titleMedium: TextStyle(
          color: Color(0xFFA66841),
          fontWeight: FontWeight.w600,
        ),
        titleSmall: TextStyle(
          color: Color(0xFFA66841),
          fontWeight: FontWeight.w500,
        ),
      ),

      //Botões
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF4A768A),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
          padding: const EdgeInsets.symmetric(vertical: 14),
          elevation: 2,
        ),
      ),

      //AppBar
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFFF7F3EC),
        iconTheme: IconThemeData(color: Color(0xFFA66841)),
        elevation: 0,
      ),
    );
  }

  // Tema Escuro
  ThemeData _darkTheme() {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: const Color(0xFF121212),
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF4A768A),
        brightness: Brightness.dark,
      ),
      useMaterial3: true,
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF121212),
        elevation: 0,
      ),
      // Adicionei configurações para inputs ficarem visíveis no dark mode
      inputDecorationTheme: const InputDecorationTheme(
        filled: true,
        fillColor: Color(0xFF1E1E1E),
        border: OutlineInputBorder(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Meu Diário de Leitura',
      theme: _lightTheme(),
      darkTheme: _darkTheme(),
      themeMode: themeProvider.mode,
      // AQUI MUDAMOS: A tela inicial agora é o Login!
      home: const LoginPage(),
    );
  }
}

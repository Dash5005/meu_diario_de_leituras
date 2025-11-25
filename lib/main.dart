import 'package:flutter/material.dart';
import 'screens/books_page.dart'; // Import da nova página

void main() {
  runApp(const MeuApp());
}

class MeuApp extends StatelessWidget {
  const MeuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Meu Diário de Leitura',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFF7F3EC),
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF4A768A)),
        useMaterial3: true,

        // === TEMA GLOBAL DE TEXTO ===
        textTheme: const TextTheme(
          titleLarge: TextStyle(
            color: Color(0xFFA66841), // Cor dos títulos
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

        // === TEMA GLOBAL DE BOTÃO ===
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF4A768A),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
            ),
            padding: const EdgeInsets.symmetric(vertical: 14),
            elevation: 2,
          ),
        ),
      ),
      home: const TelaLogin(),
    );
  }
}

class TelaLogin extends StatefulWidget {
  const TelaLogin({super.key});

  @override
  State<TelaLogin> createState() => _TelaLoginState();
}

class _TelaLoginState extends State<TelaLogin> {
  final TextEditingController _usuarioController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();
  bool _ocultarSenha = true;

  void _continuar() {
    String usuario = _usuarioController.text.trim();
    String senha = _senhaController.text.trim();

    if (usuario.isEmpty || senha.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, preencha todos os campos')),
      );
    } else {
      print("Usuário: $usuario, Senha: $senha");
      // Navegar para BooksPage
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const BooksPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo
                Image.asset('assets/images/logo.png', height: 180),
                const SizedBox(height: 40),

                // Label "login"
                Text('login', style: Theme.of(context).textTheme.titleSmall),
                const SizedBox(height: 8),

                // Campo de usuário
                TextField(
                  controller: _usuarioController,
                  decoration: InputDecoration(
                    hintText: 'usuário',
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 16,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Color(0xFF4A768A)),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xFF4A768A),
                        width: 2,
                      ),
                    ),
                  ),
                  cursorColor: const Color(0xFF4A768A),
                ),
                const SizedBox(height: 16),

                // Campo de senha
                TextField(
                  controller: _senhaController,
                  obscureText: _ocultarSenha,
                  decoration: InputDecoration(
                    hintText: 'senha',
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 16,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Color(0xFF4A768A)),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xFF4A768A),
                        width: 2,
                      ),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _ocultarSenha ? Icons.visibility_off : Icons.visibility,
                        color: const Color(0xFF4A768A),
                      ),
                      onPressed: () {
                        setState(() {
                          _ocultarSenha = !_ocultarSenha;
                        });
                      },
                    ),
                  ),
                  cursorColor: const Color(0xFF4A768A),
                ),
                const SizedBox(height: 20),

                // Botão
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _continuar,
                    child: const Text(
                      'Continue',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

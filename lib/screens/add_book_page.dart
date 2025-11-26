import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/book.dart';
import '../repositories/book_repository.dart';
import '../widgets/custom_text_field.dart';

class AddBookPage extends StatefulWidget {
  const AddBookPage({super.key});

  @override
  State<AddBookPage> createState() => _AddBookPageState();
}

class _AddBookPageState extends State<AddBookPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _tituloController = TextEditingController();
  final TextEditingController _autorController = TextEditingController();
  final TextEditingController _generoController = TextEditingController();

  AutovalidateMode _autoValidateMode = AutovalidateMode.disabled;

  @override
  void initState() {
    super.initState();
    _tituloController.addListener(_onFormChanged);
    _autorController.addListener(_onFormChanged);
    _generoController.addListener(_onFormChanged);
  }

  @override
  void dispose() {
    _tituloController.removeListener(_onFormChanged);
    _autorController.removeListener(_onFormChanged);
    _generoController.removeListener(_onFormChanged);
    _tituloController.dispose();
    _autorController.dispose();
    _generoController.dispose();
    super.dispose();
  }

  void _onFormChanged() {
    if (mounted) setState(() {});
  }

  bool get _isFormValid {
    final tituloOk = _tituloController.text.trim().isNotEmpty;
    final autorOk = _autorController.text.trim().isNotEmpty;
    final generoOk = _generoController.text.trim().isNotEmpty;
    return tituloOk && autorOk && generoOk;
  }

  void _salvar() async {
    setState(() => _autoValidateMode = AutovalidateMode.onUserInteraction);

    if (_formKey.currentState!.validate()) {
      final novoLivro = Livro(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        titulo: _tituloController.text.trim(),
        autor: _autorController.text.trim(),
        genero: _generoController.text.trim(),
      );

      try {
        await Provider.of<BookRepository>(
          context,
          listen: false,
        ).addLivro(novoLivro);

        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Livro adicionado com sucesso!'),
            backgroundColor: Colors.green,
          ),
        );

        Navigator.pop(context);
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao salvar livro: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Novo Livro"), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          autovalidateMode: _autoValidateMode,
          child: Column(
            children: [
              CustomTextField(
                label: "Título",
                controller: _tituloController,
                validator: (v) =>
                    v == null || v.isEmpty ? 'Preencha o título' : null,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                label: "Autor",
                controller: _autorController,
                validator: (v) =>
                    v == null || v.isEmpty ? 'Preencha o autor' : null,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                label: "Gênero",
                controller: _generoController,
                validator: (v) =>
                    v == null || v.isEmpty ? 'Preencha o gênero' : null,
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: _isFormValid ? _salvar : null,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text(
                  "Salvar",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

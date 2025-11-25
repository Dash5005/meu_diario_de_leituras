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
  final _tituloController = TextEditingController();
  final _autorController = TextEditingController();
  final _generoController = TextEditingController();

  @override
  void dispose() {
    _tituloController.dispose();
    _autorController.dispose();
    _generoController.dispose();
    super.dispose();
  }

  void _salvar() async {
    if (_formKey.currentState!.validate()) {
      final livro = Livro(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        titulo: _tituloController.text.trim(),
        autor: _autorController.text.trim(),
        genero: _generoController.text.trim(),
      );
      await Provider.of<BookRepository>(context, listen: false).addLivro(livro);
      Navigator.pop(context);
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
          child: Column(
            children: [
              CustomTextField(
                label: "Título",
                controller: _tituloController,
                validator: (v) =>
                    v == null || v.isEmpty ? 'Informe o título' : null,
              ),
              const SizedBox(height: 12),
              CustomTextField(
                label: "Autor",
                controller: _autorController,
                validator: (v) =>
                    v == null || v.isEmpty ? 'Informe o autor' : null,
              ),
              const SizedBox(height: 12),
              CustomTextField(
                label: "Gênero",
                controller: _generoController,
                validator: (v) =>
                    v == null || v.isEmpty ? 'Informe o gênero' : null,
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _salvar,
                  child: const Text("Salvar"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

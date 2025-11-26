import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/book.dart';
import '../repositories/book_repository.dart';

class EditBookPage extends StatefulWidget {
  final Livro livro;
  const EditBookPage({super.key, required this.livro});

  @override
  State<EditBookPage> createState() => _EditBookPageState();
}

class _EditBookPageState extends State<EditBookPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _tituloController;
  late TextEditingController _autorController;
  late TextEditingController _generoController;

  @override
  void initState() {
    super.initState();
    _tituloController = TextEditingController(text: widget.livro.titulo);
    _autorController = TextEditingController(text: widget.livro.autor);
    _generoController = TextEditingController(text: widget.livro.genero);
  }

  @override
  void dispose() {
    _tituloController.dispose();
    _autorController.dispose();
    _generoController.dispose();
    super.dispose();
  }

  void _salvar() async {
    if (_formKey.currentState!.validate()) {
      final atualizado = Livro(
        id: widget.livro.id,
        titulo: _tituloController.text.trim(),
        autor: _autorController.text.trim(),
        genero: _generoController.text.trim(),
        anotacoes: widget.livro.anotacoes,
        avaliacoes: widget.livro.avaliacoes,
      );
      try {
        await Provider.of<BookRepository>(
          context,
          listen: false,
        ).updateLivro(atualizado);
        if (!mounted) return;
        Navigator.pop(context);
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Erro ao atualizar livro: $e')));
      }
    }
  }

  InputDecoration _dec(String label) =>
      InputDecoration(labelText: label, border: const OutlineInputBorder());

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(title: const Text("Editar Livro"), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _tituloController,
                decoration: _dec("Título"),
                validator: (v) =>
                    (v == null || v.isEmpty) ? 'Informe o título' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _autorController,
                decoration: _dec("Autor"),
                validator: (v) =>
                    (v == null || v.isEmpty) ? 'Informe o autor' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _generoController,
                decoration: _dec("Gênero"),
                validator: (v) =>
                    (v == null || v.isEmpty) ? 'Informe o gênero' : null,
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

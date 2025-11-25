import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/annotation.dart';
import '../models/book.dart';
import '../repositories/book_repository.dart';

class AddNotePage extends StatefulWidget {
  final Livro livro;
  const AddNotePage({super.key, required this.livro});

  @override
  State<AddNotePage> createState() => _AddNotePageState();
}

class _AddNotePageState extends State<AddNotePage> {
  final _formKey = GlobalKey<FormState>();
  final _notaController = TextEditingController();
  final _paginaController = TextEditingController();

  @override
  void dispose() {
    _notaController.dispose();
    _paginaController.dispose();
    super.dispose();
  }

  void _salvar() async {
    if (_formKey.currentState!.validate()) {
      final anotacao = Anotacao(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        texto: _notaController.text.trim(),
        pagina: int.tryParse(_paginaController.text.trim()) ?? 0,
        data: DateTime.now(),
      );
      await Provider.of<BookRepository>(
        context,
        listen: false,
      ).addAnotacao(widget.livro.id, anotacao);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Nova Anotação"), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _notaController,
                maxLines: 5,
                validator: (v) =>
                    v == null || v.isEmpty ? 'Escreva uma anotação' : null,
                decoration: const InputDecoration(
                  hintText: "Anotação",
                  filled: true,
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _paginaController,
                keyboardType: TextInputType.number,
                validator: (v) =>
                    v == null || v.isEmpty ? 'Informe a página' : null,
                decoration: const InputDecoration(
                  hintText: "Página atual",
                  filled: true,
                ),
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

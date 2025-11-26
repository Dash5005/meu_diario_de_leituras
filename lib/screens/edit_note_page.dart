import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/annotation.dart';
import '../models/book.dart';
import '../repositories/book_repository.dart';

class EditNotePage extends StatefulWidget {
  final Livro livro;
  final Anotacao anotacao;
  const EditNotePage({super.key, required this.livro, required this.anotacao});

  @override
  State<EditNotePage> createState() => _EditNotePageState();
}

class _EditNotePageState extends State<EditNotePage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _textoController;
  late TextEditingController _paginaController;

  @override
  void initState() {
    super.initState();
    _textoController = TextEditingController(text: widget.anotacao.texto);
    _paginaController = TextEditingController(
      text: widget.anotacao.pagina.toString(),
    );
  }

  @override
  void dispose() {
    _textoController.dispose();
    _paginaController.dispose();
    super.dispose();
  }

  void _salvar() async {
    if (_formKey.currentState!.validate()) {
      final atualizado = Anotacao(
        id: widget.anotacao.id,
        texto: _textoController.text.trim(),
        pagina:
            int.tryParse(_paginaController.text.trim()) ??
            widget.anotacao.pagina,
        data: DateTime.now(),
      );
      try {
        await Provider.of<BookRepository>(
          context,
          listen: false,
        ).updateAnotacao(widget.livro.id, atualizado);
        if (!mounted) return;
        Navigator.pop(context);
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao atualizar anotação: $e')),
        );
      }
    }
  }

  InputDecoration _dec(String label) => const InputDecoration(
    border: OutlineInputBorder(),
    labelText: '',
  ).copyWith(labelText: label);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(title: const Text("Editar Anotação"), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _textoController,
                maxLines: 5,
                decoration: _dec("Texto"),
                validator: (v) =>
                    (v == null || v.isEmpty) ? 'Informe o texto' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _paginaController,
                keyboardType: TextInputType.number,
                decoration: _dec("Página"),
                validator: (v) =>
                    (v == null || v.isEmpty) ? 'Informe a página' : null,
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

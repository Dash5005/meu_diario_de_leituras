import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/annotation.dart';
import '../models/book.dart';
import '../repositories/book_repository.dart';
import '../widgets/custom_text_field.dart';

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
    // Inicializa os campos com os dados existentes da anotação
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
      // Cria um novo objeto Anotacao mantendo o mesmo ID e Data, mas com texto/página novos
      final atualizado = Anotacao(
        id: widget.anotacao.id,
        texto: _textoController.text.trim(),
        pagina:
            int.tryParse(_paginaController.text.trim()) ??
            widget.anotacao.pagina,
        data: widget.anotacao.data,
      );

      try {
        await Provider.of<BookRepository>(
          context,
          listen: false,
        ).updateAnotacao(widget.livro.id, atualizado);

        if (!mounted) return;
        Navigator.pop(context); // Volta para os detalhes do livro
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Anotação atualizada com sucesso!'),
            backgroundColor: Colors.green,
          ),
        );
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Erro ao atualizar: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Editar Anotação"), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              CustomTextField(
                label: "Texto da anotação",
                controller: _textoController,
                maxLines: 5,
                validator: (v) =>
                    v == null || v.isEmpty ? 'Informe o texto' : null,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                label: "Página",
                controller: _paginaController,
                keyboardType: TextInputType.number,
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Informe a página';
                  if (int.tryParse(v) == null) return 'Número inválido';
                  return null;
                },
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _salvar,
                  child: const Text(
                    "Salvar Alterações",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

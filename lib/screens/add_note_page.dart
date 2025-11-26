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
  final TextEditingController _notaController = TextEditingController();
  final TextEditingController _paginaController = TextEditingController();

  AutovalidateMode _autoValidateMode = AutovalidateMode.disabled;

  @override
  void initState() {
    super.initState();
    _notaController.addListener(_onFormChanged);
    _paginaController.addListener(_onFormChanged);
  }

  @override
  void dispose() {
    _notaController.removeListener(_onFormChanged);
    _paginaController.removeListener(_onFormChanged);
    _notaController.dispose();
    _paginaController.dispose();
    super.dispose();
  }

  void _onFormChanged() {
    if (mounted) setState(() {});
  }

  bool get _isFormValid {
    final textoOk = _notaController.text.trim().isNotEmpty;
    final paginaOk =
        _paginaController.text.trim().isNotEmpty &&
        int.tryParse(_paginaController.text.trim()) != null;
    return textoOk && paginaOk;
  }

  void _salvar() async {
    setState(() => _autoValidateMode = AutovalidateMode.onUserInteraction);

    if (_formKey.currentState!.validate()) {
      final anotacao = Anotacao(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        texto: _notaController.text.trim(),
        pagina: int.tryParse(_paginaController.text.trim()) ?? 0,
        data: DateTime.now(),
      );

      try {
        await Provider.of<BookRepository>(
          context,
          listen: false,
        ).addAnotacao(widget.livro.id, anotacao);

        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Anotação salva com sucesso!'),
            backgroundColor: Colors.green,
          ),
        );

        Navigator.pop(context);
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Erro ao salvar anotação: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F3EC),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF7F3EC),
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFFA66841)),
        title: const Text(
          "Nova Anotação",
          style: TextStyle(
            color: Color(0xFFA66841),
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          autovalidateMode: _autoValidateMode,
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F4FA),
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.all(12),
                child: TextFormField(
                  controller: _notaController,
                  maxLines: 5,
                  validator: (value) => value == null || value.isEmpty
                      ? 'Escreva uma anotação'
                      : null,
                  decoration: const InputDecoration(
                    hintText: "Anotação",
                    border: InputBorder.none,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _paginaController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: "Página atual",
                  filled: true,
                  fillColor: const Color(0xFFF1F4FA),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Informe a página atual';
                  }
                  if (int.tryParse(value.trim()) == null) {
                    return 'Informe um número válido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: _isFormValid ? _salvar : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4A768A),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 14,
                  ),
                ),
                child: const Text(
                  "Salvar",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
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

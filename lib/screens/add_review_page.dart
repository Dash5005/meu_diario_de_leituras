import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/review.dart';
import '../models/book.dart';
import '../repositories/book_repository.dart';

class AddReviewPage extends StatefulWidget {
  final Livro livro;
  const AddReviewPage({super.key, required this.livro});

  @override
  State<AddReviewPage> createState() => _AddReviewPageState();
}

class _AddReviewPageState extends State<AddReviewPage> {
  final _notaController = TextEditingController();
  final _comentController = TextEditingController();

  @override
  void dispose() {
    _notaController.dispose();
    _comentController.dispose();
    super.dispose();
  }

  Future<void> _enviar() async {
    final nota = int.tryParse(_notaController.text.trim());
    if (nota == null || nota < 1 || nota > 5) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Informe uma nota entre 1 e 5')),
      );
      return;
    }

    final review = Review(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      nota: nota,
      comentario: _comentController.text.trim(),
      data: DateTime.now(),
    );

    await Provider.of<BookRepository>(
      context,
      listen: false,
    ).addReview(widget.livro.id, review);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Avaliação adicionada!'),
        backgroundColor: Colors.green,
      ),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        iconTheme: theme.iconTheme.copyWith(color: const Color(0xFFA66841)),
        title: Text("Adicionar Avaliação", style: theme.textTheme.titleLarge),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextFormField(
              controller: _notaController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: 'Nota (1-5)',
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
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _comentController,
              maxLines: 5,
              decoration: InputDecoration(
                hintText: "Comentário",
                filled: true,
                fillColor: const Color(0xFFF1F4FA),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _enviar,
                child: const Text(
                  'Enviar Avaliação',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

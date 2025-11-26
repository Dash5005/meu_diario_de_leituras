import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
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
  // O _notaController por uma variável double
  double _rating = 3;
  final _comentController = TextEditingController();

  AutovalidateMode _autoValidateMode = AutovalidateMode.disabled;

  @override
  void initState() {
    super.initState();
    _comentController.addListener(_onFormChanged);
  }

  @override
  void dispose() {
    _comentController.removeListener(_onFormChanged);
    _comentController.dispose();
    super.dispose();
  }

  void _onFormChanged() {
    if (mounted) setState(() {});
  }

  Future<void> _enviar() async {
    setState(() => _autoValidateMode = AutovalidateMode.onUserInteraction);

    final review = Review(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      nota: _rating.toInt(),
      comentario: _comentController.text.trim(),
      data: DateTime.now(),
    );

    try {
      await Provider.of<BookRepository>(
        context,
        listen: false,
      ).addReview(widget.livro.id, review);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Avaliação adicionada!'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao adicionar avaliação: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
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
      body: SingleChildScrollView(
        // SingleChildScrollView para evitar overflow em telas pequenas
        padding: const EdgeInsets.all(16),
        child: Form(
          autovalidateMode: _autoValidateMode,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Sua nota",
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              RatingBar.builder(
                initialRating: _rating,
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: false,
                itemCount: 5,
                itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                itemBuilder: (context, _) =>
                    const Icon(Icons.star, color: Colors.amber),
                onRatingUpdate: (rating) {
                  setState(() {
                    _rating = rating;
                  });
                },
              ),

              const SizedBox(height: 24),

              TextFormField(
                controller: _comentController,
                maxLines: 5,
                decoration: InputDecoration(
                  hintText: "Escreva seu comentário aqui...",
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
      ),
    );
  }
}

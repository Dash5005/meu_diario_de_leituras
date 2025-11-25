import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'add_note_page.dart';
import 'add_review_page.dart';
import '../models/book.dart';
import '../repositories/book_repository.dart';

class BookDetailsPage extends StatelessWidget {
  final Livro livro;

  const BookDetailsPage({super.key, required this.livro});

  void _confirmarExclusao(BuildContext context, BookRepository repo) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Excluir Livro'),
        content: const Text('Tens a certeza? Esta ação não pode ser desfeita.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () async {
              await repo.removeLivro(livro.id);
              Navigator.pop(ctx);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Livro excluído com sucesso!')),
              );
            },
            child: const Text('Excluir', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final repo = Provider.of<BookRepository>(context);

    Livro livroAtual;
    try {
      livroAtual = repo.lista.firstWhere((b) => b.id == livro.id);
    } catch (e) {
      return const SizedBox.shrink();
    }

    final containerColor = theme.brightness == Brightness.dark
        ? const Color(0xFF1E1E1E)
        : const Color(0xFFF1F4FA);

    return Scaffold(
      appBar: AppBar(
        title: Text(livroAtual.titulo, style: theme.textTheme.titleLarge),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            tooltip: 'Excluir Livro',
            onPressed: () => _confirmarExclusao(context, repo),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _infoBox(livroAtual.autor, containerColor, theme),
              const SizedBox(height: 12),
              _infoBox(livroAtual.genero, containerColor, theme),
              const SizedBox(height: 20),

              // Notas
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: containerColor,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Notas", style: theme.textTheme.titleMedium),
                    const SizedBox(height: 8),
                    if (livroAtual.anotacoes.isEmpty)
                      Text(
                        "Nenhuma anotação ainda.",
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: Colors.grey,
                        ),
                      )
                    else
                      ...livroAtual.anotacoes.reversed.map((a) {
                        return ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Text(a.texto),
                          subtitle: Text(
                            "Pág ${a.pagina} • ${a.data.toLocal().toString().split(' ')[0]}",
                            style: TextStyle(
                              color: theme.textTheme.bodySmall?.color,
                            ),
                          ),
                          trailing: IconButton(
                            icon: Icon(
                              Icons.delete_outline,
                              color: theme.colorScheme.error,
                            ),
                            onPressed: () {
                              repo.removeAnotacao(livroAtual.id, a.id);
                            },
                          ),
                        );
                      }),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              Align(
                alignment: Alignment.centerRight,
                child: FloatingActionButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => AddNotePage(livro: livroAtual),
                      ),
                    );
                  },
                  backgroundColor: theme.colorScheme.primary,
                  mini: true,
                  child: const Icon(Icons.add, color: Colors.white),
                ),
              ),

              const SizedBox(height: 16),

              // Avaliações
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: containerColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Avaliações", style: theme.textTheme.titleMedium),
                    const SizedBox(height: 8),
                    if (livroAtual.avaliacoes.isEmpty)
                      Text(
                        "Nenhuma avaliação ainda.",
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: Colors.grey,
                        ),
                      )
                    else
                      ...livroAtual.avaliacoes.reversed.map((r) {
                        return ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: CircleAvatar(
                            backgroundColor: theme.colorScheme.primary,
                            child: Text(
                              '${r.nota}',
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                          title: Text(
                            r.comentario.isEmpty ? '—' : r.comentario,
                          ),
                          subtitle: Text(
                            r.data.toLocal().toString().split(' ')[0],
                          ),
                          trailing: IconButton(
                            icon: Icon(
                              Icons.delete_outline,
                              color: theme.colorScheme.error,
                            ),
                            onPressed: () {
                              repo.removeReview(livroAtual.id, r.id);
                            },
                          ),
                        );
                      }),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => AddReviewPage(livro: livroAtual),
                      ),
                    );
                  },
                  icon: const Icon(Icons.rate_review_outlined),
                  label: const Text("Adicionar Avaliação"),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoBox(String text, Color bgColor, ThemeData theme) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Text(
          text,
          style: theme.textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

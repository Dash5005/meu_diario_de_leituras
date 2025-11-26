import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Imports de Funcionalidades (Certifica-te que os ficheiros existem)
import 'add_note_page.dart';
import 'edit_note_page.dart';
import 'edit_book_page.dart';
import 'add_review_page.dart'; // <--- Agora vai funcionar com o código acima

import '../models/book.dart';
import '../repositories/book_repository.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

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
              if (context.mounted) {
                Navigator.pop(ctx);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Livro excluído!')),
                );
              }
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

    // Garante que temos a versão mais recente do livro (Reactive)
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
        title: Text(livroAtual.titulo),
        centerTitle: true,
        actions: [
          // BOTÃO EDITAR LIVRO (Restaurado)
          IconButton(
            icon: const Icon(Icons.edit),
            tooltip: 'Editar informações',
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => EditBookPage(livro: livroAtual),
              ),
            ),
          ),
          // BOTÃO EXCLUIR LIVRO
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () => _confirmarExclusao(context, repo),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              _infoBox(livroAtual.autor, containerColor, theme),
              const SizedBox(height: 12),
              _infoBox(livroAtual.genero, containerColor, theme),
              const SizedBox(height: 20),

              // --- SEÇÃO DE NOTAS ---
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
                      const Text(
                        "Nenhuma anotação ainda.",
                        style: TextStyle(color: Colors.grey),
                      )
                    else
                      for (final a in livroAtual.anotacoes.reversed)
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Text(a.texto),
                          subtitle: Text("Pág ${a.pagina}"),
                          // Ao clicar na nota, vamos para a edição (Restaurado)
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  EditNotePage(livro: livroAtual, anotacao: a),
                            ),
                          ),
                          trailing: IconButton(
                            icon: Icon(
                              Icons.delete_outline,
                              color: theme.colorScheme.error,
                            ),
                            onPressed: () =>
                                repo.removeAnotacao(livroAtual.id, a.id),
                          ),
                        ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.centerRight,
                child: FloatingActionButton(
                  heroTag:
                      'add_note', // Evita conflito de animação com outro botão
                  mini: true,
                  backgroundColor: theme.colorScheme.primary,
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => AddNotePage(livro: livroAtual),
                    ),
                  ),
                  child: const Icon(Icons.add, color: Colors.white),
                ),
              ),

              const SizedBox(height: 20),

              // --- SEÇÃO DE AVALIAÇÕES ---
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
                      const Text(
                        "Nenhuma avaliação ainda.",
                        style: TextStyle(color: Colors.grey),
                      )
                    else
                      for (final r in livroAtual.avaliacoes.reversed)
                        Container(
                          margin: const EdgeInsets.only(
                            bottom: 8,
                          ), // Um pequeno espaço entre avaliações
                          decoration: BoxDecoration(
                            color: theme
                                .cardColor, // Opcional: destaca levemente cada review
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            // AQUI ESTÁ A MUDANÇA PRINCIPAL:
                            title: Row(
                              children: [
                                RatingBarIndicator(
                                  rating: r.nota
                                      .toDouble(), // Converte int para double
                                  itemBuilder: (context, index) => const Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                  ),
                                  itemCount: 5,
                                  itemSize:
                                      20.0, // Tamanho menor para ficar elegante na lista
                                  direction: Axis.horizontal,
                                ),
                                const SizedBox(width: 8),
                                // Opcional: Mostrar a data formatada simples
                                Text(
                                  "${r.data.day}/${r.data.month}/${r.data.year}",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: theme.textTheme.bodySmall?.color
                                        ?.withOpacity(0.6),
                                  ),
                                ),
                              ],
                            ),
                            subtitle: Padding(
                              padding: const EdgeInsets.only(top: 6.0),
                              child: Text(
                                r.comentario.isEmpty
                                    ? 'Sem comentário.'
                                    : r.comentario,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: theme.textTheme.bodyMedium?.color,
                                ),
                              ),
                            ),
                            trailing: IconButton(
                              icon: Icon(
                                Icons.delete_outline,
                                color: theme.colorScheme.error.withOpacity(0.7),
                                size: 20,
                              ),

                              onPressed: () =>
                                  repo.removeReview(livroAtual.id, r.id),
                            ),
                          ),
                        ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // BOTÃO ADICIONAR AVALIAÇÃO (Consertado)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.rate_review_outlined),
                  label: const Text("Adicionar Avaliação"),
                  onPressed: () {
                    // Navegação corrigida para a nova página AddReviewPage
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => AddReviewPage(livro: livroAtual),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 30),
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

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'add_book_page.dart';
import '../models/book.dart';
import '../repositories/book_repository.dart';
import '../repositories/theme_provider.dart';
import 'book_details_page.dart';

class BooksPage extends StatefulWidget {
  const BooksPage({super.key});

  @override
  State<BooksPage> createState() => _BooksPageState();
}

class _BooksPageState extends State<BooksPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        elevation: Theme.of(context).appBarTheme.elevation ?? 0,
        iconTheme: Theme.of(context).appBarTheme.iconTheme,
        title: Text(
          'Meus Livros',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 20),
        ),
        centerTitle: true,
        actions: [
          Consumer<ThemeProvider>(
            builder: (context, themeProvider, child) {
              return IconButton(
                icon: Icon(
                  themeProvider.isDark ? Icons.dark_mode : Icons.light_mode,
                  color: themeProvider.isDark
                      ? Colors.white
                      : const Color(0xFFA66841),
                ),
                onPressed: () => themeProvider.toggleTheme(),
                tooltip: themeProvider.isDark ? 'Tema claro' : 'Tema escuro',
              );
            },
          ),
        ],
      ),
      body: Consumer<BookRepository>(
        builder: (context, repository, child) {
          if (repository.isLoading) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFFA66841)),
            );
          }

          final List<Livro> livros = repository.lista;

          return FadeTransition(
            opacity: _fadeAnimation,
            child: livros.isEmpty
                ? Center(
                    child: Text(
                      'Nenhum livro adicionado ainda.',
                      style: TextStyle(
                        color:
                            Theme.of(context).textTheme.titleSmall?.color ??
                            const Color(0xFFA66841),
                        fontSize: 16,
                      ),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: livros.length,
                    itemBuilder: (context, index) {
                      final livro = livros[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(12),
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Container(
                              width: 50,
                              height: 50,
                              color: const Color(0xFF4A768A),
                              child: const Icon(
                                Icons.book,
                                color: Colors.white,
                                size: 28,
                              ),
                            ),
                          ),
                          title: Text(
                            livro.titulo,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFA66841),
                              fontSize: 16,
                            ),
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 4.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  livro.autor,
                                  style: TextStyle(
                                    color:
                                        Theme.of(
                                          context,
                                        ).textTheme.titleSmall?.color ??
                                        Colors.black87,
                                    fontSize: 14,
                                  ),
                                ),
                                Text(
                                  livro.genero,
                                  style: TextStyle(
                                    color:
                                        Theme.of(context)
                                            .textTheme
                                            .titleSmall
                                            ?.color
                                            ?.withOpacity(0.9) ??
                                        Colors.black54,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              PageRouteBuilder(
                                transitionDuration: const Duration(
                                  milliseconds: 400,
                                ),
                                pageBuilder: (_, __, ___) =>
                                    BookDetailsPage(livro: livro),
                                transitionsBuilder:
                                    (
                                      context,
                                      animation,
                                      secondaryAnimation,
                                      child,
                                    ) {
                                      final tween =
                                          Tween(
                                            begin: const Offset(1, 0),
                                            end: Offset.zero,
                                          ).chain(
                                            CurveTween(
                                              curve: Curves.easeOutCubic,
                                            ),
                                          );
                                      return SlideTransition(
                                        position: animation.drive(tween),
                                        child: child,
                                      );
                                    },
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF4A768A),
        elevation: 3,
        child: const Icon(Icons.add, size: 28),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddBookPage()),
          );
        },
      ),
    );
  }
}

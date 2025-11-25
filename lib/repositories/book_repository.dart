import 'dart:collection';
import 'package:flutter/material.dart';

import '../models/book.dart';
import '../models/annotation.dart';
import '../models/review.dart';

class BookRepository extends ChangeNotifier {
  final List<Livro> _books = [];
  UnmodifiableListView<Livro> get lista => UnmodifiableListView(_books);

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // CRUD Livro (em memória)
  Future<void> addLivro(Livro livro) async {
    _books.add(livro);
    notifyListeners();
  }

  Future<void> updateLivro(Livro livro) async {
    final idx = _books.indexWhere((b) => b.id == livro.id);
    if (idx != -1) {
      _books[idx] = livro;
      notifyListeners();
    }
  }

  Future<void> removeLivro(String livroId) async {
    _books.removeWhere((b) => b.id == livroId);
    notifyListeners();
  }

  // Anotações (em memória)
  Future<void> addAnotacao(String livroId, Anotacao anotacao) async {
    final livro = _books.firstWhere((b) => b.id == livroId);
    livro.anotacoes = (livro.anotacoes ?? [])..add(anotacao);
    notifyListeners();
  }

  Future<void> updateAnotacao(String livroId, Anotacao anotacao) async {
    final livro = _books.firstWhere((b) => b.id == livroId);
    final idx = livro.anotacoes.indexWhere((a) => a.id == anotacao.id);
    if (idx != -1) {
      livro.anotacoes[idx] = anotacao;
      notifyListeners();
    }
  }

  Future<void> removeAnotacao(String livroId, String anotacaoId) async {
    final livro = _books.firstWhere((b) => b.id == livroId);
    livro.anotacoes?.removeWhere((a) => a.id == anotacaoId);
    notifyListeners();
  }

  // Avaliações (em memória)
  Future<void> addReview(String livroId, Review review) async {
    final livro = _books.firstWhere((b) => b.id == livroId);
    livro.avaliacoes = (livro.avaliacoes ?? [])..add(review);
    notifyListeners();
  }

  Future<void> removeReview(String livroId, String reviewId) async {
    final livro = _books.firstWhere((b) => b.id == livroId);
    livro.avaliacoes?.removeWhere((r) => r.id == reviewId);
    notifyListeners();
  }
}

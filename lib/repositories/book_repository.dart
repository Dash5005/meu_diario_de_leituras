import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/book.dart';
import '../models/annotation.dart';
import '../models/review.dart';

class BookRepository extends ChangeNotifier {
  static const String boxName = 'meus_livros';

  List<Livro> _books = [];
  UnmodifiableListView<Livro> get lista => UnmodifiableListView(_books);

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  BookRepository() {
    _init();
  }

  Future<void> _init() async {
    try {
      final box = await Hive.openBox<Livro>(boxName);
      _books = box.values.toList();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // CRUD Livro
  Future<void> addLivro(Livro livro) async {
    final box = Hive.box<Livro>(boxName);
    await box.put(livro.id, livro);
    _books = box.values.toList();
    notifyListeners();
  }

  Future<void> updateLivro(Livro livro) async {
    final box = Hive.box<Livro>(boxName);
    await box.put(livro.id, livro);
    _books = box.values.toList();
    notifyListeners();
  }

  Future<void> removeLivro(String livroId) async {
    final box = Hive.box<Livro>(boxName);
    await box.delete(livroId);
    _books = box.values.toList();
    notifyListeners();
  }

  // Anotações
  Future<void> addAnotacao(String livroId, Anotacao anotacao) async {
    final box = Hive.box<Livro>(boxName);
    final livro = box.get(livroId);
    if (livro == null) return;
    livro.anotacoes = (livro.anotacoes ?? [])..add(anotacao);
    await livro.save();
    _books = box.values.toList();
    notifyListeners();
  }

  Future<void> updateAnotacao(String livroId, Anotacao anotacao) async {
    final box = Hive.box<Livro>(boxName);
    final livro = box.get(livroId);
    if (livro == null) return;
    final idx = livro.anotacoes.indexWhere((a) => a.id == anotacao.id);
    if (idx != -1) {
      livro.anotacoes[idx] = anotacao;
      await livro.save();
      _books = box.values.toList();
      notifyListeners();
    }
  }

  Future<void> removeAnotacao(String livroId, String anotacaoId) async {
    final box = Hive.box<Livro>(boxName);
    final livro = box.get(livroId);
    if (livro == null) return;
    livro.anotacoes?.removeWhere((a) => a.id == anotacaoId);
    await livro.save();
    _books = box.values.toList();
    notifyListeners();
  }

  // Avaliações
  Future<void> addReview(String livroId, Review review) async {
    final box = Hive.box<Livro>(boxName);
    final livro = box.get(livroId);
    if (livro == null) return;
    livro.avaliacoes = (livro.avaliacoes ?? [])..add(review);
    await livro.save();
    _books = box.values.toList();
    notifyListeners();
  }

  Future<void> removeReview(String livroId, String reviewId) async {
    final box = Hive.box<Livro>(boxName);
    final livro = box.get(livroId);
    if (livro == null) return;
    livro.avaliacoes?.removeWhere((r) => r.id == reviewId);
    await livro.save();
    _books = box.values.toList();
    notifyListeners();
  }
}

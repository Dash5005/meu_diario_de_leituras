# 📚 Diário de Leitura (Reading Diary)

## Integrantes do Projeto:

**Ana Clara da Silva Freitas**

**Guilherme de Freitas Romão Vieira**

**João Pedro Alvarado Cardoso**

**Bruno Gomes Robim**

O **Diário de Leitura** é uma aplicação móvel desenvolvida em Flutter que ajuda os leitores a organizar a sua biblioteca pessoal. O objetivo é permitir que o utilizador registe os seus livros, faça anotações de passagens importantes e avalie as suas leituras, tudo de forma offline e persistente.

Este projeto foi construído focando em boas práticas de arquitetura, gestão de estado reativa e bases de dados NoSQL locais.

## 📱 Funcionalidades

- **Gestão de Livros:** Adicionar, editar e remover livros da biblioteca pessoal.
- **Anotações Detalhadas:** Criar notas específicas vinculadas a páginas do livro.
- **Sistema de Avaliação:** Classificação de livros com sistema de estrelas (1 a 5) e comentários.
- **Persistência de Dados:** Todos os dados são salvos localmente usando **Hive**, garantindo que nada se perde ao fechar a app.
- **Temas:** Suporte completo a **Modo Claro** e **Modo Escuro**, com persistência da preferência do utilizador.
- **Interface Fluida:** Animações personalizadas na listagem e transições de ecrã.

## 🛠️ Tecnologias Utilizadas

* **Linguagem:** Dart
* **Framework:** Flutter
* **Gestão de Estado:** [Provider](https://pub.dev/packages/provider)
* **Base de Dados Local:** [Hive](https://pub.dev/packages/hive) (NoSQL rápido e leve)
* **UI Components:** [Flutter Rating Bar](https://pub.dev/packages/flutter_rating_bar)
* **Geração de Código:** [Build Runner](https://pub.dev/packages/build_runner) (para adaptadores do Hive)


## 📂 Estrutura do Projeto

O projeto segue uma arquitetura limpa e modular:

```text
lib/
├── models/         # Entidades de dados (Livro, Review, Anotacao) e Adaptadores Hive
├── repositories/   # Lógica de negócio e acesso a dados (BookRepository)
├── screens/        # Ecrãs da aplicação (UI)
├── widgets/        # Componentes reutilizáveis (ex: CustomTextField)
└── main.dart       # Ponto de entrada e configuração de temas
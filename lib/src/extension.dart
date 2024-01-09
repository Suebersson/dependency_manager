part of './dependencies.dart';

/// Implementar funções não estaticas dentro da classe [Dependencies]
/// que poderam ser acessadas quando a mesma for herdada ou mixada
extension ComplementsForDependencies on Dependencies {
  /// Obter a instância de um objeto passando o tipo Genérico [O]
  O get<O>() => Dependencies.get<O>();

  /// Adicionar e instânciar um objeto na lista de dependências
  O add<O>(Closure<O> closure, {isSingleton = true}) {
    return Dependencies.add(closure, isSingleton: isSingleton);
  }

  /// Remover um objeto [O], e disposar o mesmo se for disposavel
  void remove<O>() => Dependencies.remove<O>();

  /// Remover todos os objetos, e disposar os mesmos se for
  /// disposavel na lista dependências
  Future<void> removeAll() => Dependencies.removeAll();

  /// Disposar uma instância apenas se o [Object] não for singleton
  void dispose<O>() => Dependencies.dispose<O>();

  /// Verifica se um objeto [O] existe nas dependências
  bool contains<O>() => Dependencies.contains<O>();
}

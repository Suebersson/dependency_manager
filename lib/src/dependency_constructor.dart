part of './dependencies.dart';

/// Função que retorná uma instância de um objeto
typedef Closure<O> = O Function();

/// Adicionar uma instância de um [Object]
class Dependency<O> {
  late final Type key;
  final bool isLazy, isSingleton;
  final Closure<O> closure;

  O? instance;

  /// Criar uma instância de um objeto [singleton = false & lazy = true]
  Dependency(this.closure, {this.isLazy = true, this.isSingleton = false})
      : assert(O != dynamic,
            'Insira o tipo da dependência ou objeto no parâmentro genérico O'),
        key = O;

  /// Criar uma instância de um objeto [singleton = true & lazy = true]
  factory Dependency.lazySingleton(Closure<O> closure) {
    return Dependency<O>(closure, isSingleton: true);
  }

  /// Criar uma instância de um objeto [singleton = true & lazy = false]
  factory Dependency.singleton(Closure<O> closure) {
    return Dependency<O>(closure, isSingleton: true, isLazy: false);
  }
}

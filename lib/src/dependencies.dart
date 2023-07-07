import 'package:flutter/widgets.dart';
import 'package:dart_dev_utils/dart_dev_utils.dart' show printLog, Disposeble;

part './dependency_constructor.dart';
part './dependency_state.dart';
part './dependency_dispose.dart';
part './dependency_manager_error.dart';

/// Classe responsável por prover as função para o controle e acesso
/// as instâncias de dependências
abstract class Dependencies<O> {
  static late Dependency _dependency;
  static final List<Dependency> _dependencies = <Dependency>[];

  /// Definir e criar instâncias através de uma lista de [Dependency]
  /// com [closure]
  static Future<void> set(List<Dependency> dependencyList) async {
    await Future.forEach<Dependency>(dependencyList, (o) {
      if (!_dependencies.any((e) => e.key == o.key)) {
        if (o.isSingleton && !o.isLazy) {
          o.instance = o.closure.call();
        }
        _dependencies.add(o);
      } else {
        printLog('Objeto ${o.key} já existe na lista de dependências',
            name: 'Dependencies');
      }
    });
    dependencyList.clear();
  }

  /// Obter a instância de um objeto passando o tipo Genérico [O]
  static O get<O>() {
    assert(O != dynamic,
        'Insira o tipo da dependência ou objeto no parâmentro genérico O');

    if (contains<O>()) {
      _dependency = _dependencies.singleWhere((e) => e.key == O);

      if (_dependency.isSingleton) {
        if (_dependency.isLazy) {
          return _dependency.instance ??= _dependency.closure.call();
        } else {
          return _dependency.instance;
        }
      } else {
        return _dependency.instance = _dependency.closure.call();
      }
    } else {
      throw DependencyManagerError(
          'Objeto $O não encontrado na lista de dependências');
    }
  }

  /// Adicionar e instânciar um objeto na lista de dependências
  static O add<O>(O Function() closure, {isSingleton = true}) {
    assert(O != dynamic,
        'Insira o tipo da dependência ou objeto no parâmentro genérico O');

    if (!contains<O>()) {
      _dependency =
          Dependency<O>(closure, isLazy: false, isSingleton: isSingleton);

      _dependency.instance = _dependency.closure.call();

      _dependencies.add(_dependency);

      return _dependency.instance;
    } else {
      printLog('Já existe uma instância desse objeto $O nas dependências',
          name: 'Dependencies');

      return get<O>();
    }
  }

  /// Remover um objeto [Object], e disposar o mesmo se for disposavel
  static void remove<O>() {
    assert(O != dynamic,
        'Insira o tipo da dependência ou objeto no parâmentro genérico O');

    if (contains<O>()) {
      _dependencies.removeWhere((o) {
        if (o.key == O) {
          dependencyDispose(o.instance);
          return true;
        } else {
          return false;
        }
      });
      printLog('Objeto $O removido com sucesso', name: 'Dependencies');
    } else {
      printLog('Objeto $O não encontrado na lista de dependências',
          name: 'Dependencies');
    }
  }

  /// Remover todos os objetos, e disposar os mesmos se for
  /// disposavel na lista dependências
  static Future<void> removeAll() async {
    if (_dependencies.isNotEmpty) {
      await Future.forEach<Dependency>(_dependencies, (o) {
        dependencyDispose(o.instance);
      });
      _dependencies.clear();
      printLog('Todas as instâncias foram removidas com sucesso',
          name: 'Dependencies');
    }
  }

  /// Disposar uma instância apenas se o [Object] não for singleton
  static void dispose<O>() {
    assert(O != dynamic,
        'Insira o tipo da dependência ou objeto no parâmentro genérico O');

    if (contains<O>()) {
      _dependency = _dependencies.singleWhere((e) => e.key == O);

      if (!_dependency.isSingleton && _dependency.instance != null) {
        dependencyDispose(_dependency.instance);
        _dependency.instance = null;
      }
    }
  }

  /// Verifica se um objeto [O] existe nas dependências
  static bool contains<O>() {
    assert(O != dynamic,
        'Insira o tipo da dependência ou objeto no parâmentro genérico O');
    return _dependencies.any((e) => e.key == O);
  }
}

/// Criar uma instância única de [Dependencies] e adicionar as funções
/// dentro dos objetos [StatelessWidget] e [State] através de uma [extension]
final Dependencies _dependencies = _Dependencies();

class _Dependencies extends Dependencies {}

extension ImplementDependenciesStl on StatelessWidget {
  Dependencies get dependencies => _dependencies;
}

extension ImplementDependenciesStf on State {
  Dependencies get dependencies => _dependencies;
}

/// Implementar funções não estaticas dentro da classe [Dependencies]
/// que poderam ser acessadas quando a mesma for herdada ou mixada
///
/// Essa funções também serão implementas dentro das classes
/// [StatelessWidget] & [State] através de uma propriedade get
/// de nome [dependencies]
extension ImplementNotStatics on Dependencies {
  /// Obter a instância de um objeto passando o tipo Genérico [O]
  O get<O>() => Dependencies.get<O>();

  /// Adicionar e instânciar um objeto na lista de dependências
  O add<O>(O Function() closure, {isSingleton = true}) {
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

import 'package:dart_dev_utils/dart_dev_utils.dart' show printLog;

part './dependency_constructor.dart';
part './dependency_dispose.dart';
part './exception.dart';
part './extension.dart';
part './disposeble.dart';

/// Classe responsável por prover as função para o controle e acesso
/// as instâncias de dependências
abstract class Dependencies<O> {
  static late Dependency _dependency;
  static final List<Dependency> _dependencies = <Dependency>[];

  /// Definir e criar instâncias através de uma lista de [Dependency]
  /// com [Closure]
  static Future<void> set(List<Dependency> dependencyList) async {
    await Future.forEach<Dependency>(dependencyList, (o) {
      if (!_dependencies.any((e) => e.key == o.key)) {
        if (o.isSingleton && !o.isLazy) {
          o.instance = o.closure.call();
        }
        _dependencies.add(o);
      } else {
        _printLog('Objeto ${o.key} já existe na lista de dependências');
      }
    });
    dependencyList.clear();
  }

  /// Obter a instância de um objeto passando o tipo Genérico [O]
  static O get<O>({Closure<O>? putAbsent, bool? isSingleton}) {
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
    } else if (putAbsent is Closure<O>) {
      _dependency = Dependency<O>(putAbsent,
          isLazy: false, isSingleton: isSingleton ?? true);

      _dependencies.add(_dependency);

      return _dependency.instance = _dependency.closure.call();
    } else {
      throw DependencyManagerError(
          'Objeto $O não encontrado na lista de dependências');
    }
  }

  /// Adicionar e instânciar um objeto na lista de dependências
  static O add<O>(Closure<O> closure, {isSingleton = true}) {
    assert(O != dynamic,
        'Insira o tipo da dependência ou objeto no parâmentro genérico O');

    if (!contains<O>()) {
      _dependency =
          Dependency<O>(closure, isLazy: false, isSingleton: isSingleton);

      _dependencies.add(_dependency);

      return _dependency.instance = _dependency.closure.call();
    } else {
      _printLog('Já existe uma instância desse objeto $O nas dependências');

      return get<O>();
    }
  }

  /// Substituir uma instância singleton
  ///
  /// Essa função se aplica em situações bem especificas quando é
  /// necessário recriar uma instância de um objeto importante.
  ///
  /// Ex: Recriar uma instância de [UserData] ou [AppConfigData] que são
  /// carregadas antes da inicialização da app e que os valores foram alterados
  /// pelo usuário na app
  static bool replaceInstanceSingleton<O>(Closure<O> closure) {
    assert(O != dynamic,
        'Insira o tipo da dependência ou objeto no parâmentro genérico O');

    if (contains<O>()) {
      remove<O>();

      _dependency = Dependency<O>(closure, isLazy: false, isSingleton: true);

      _dependency.instance = _dependency.closure.call();

      _dependencies.add(_dependency);

      return true;
    } else {
      _printLog('A instância de $O não foi encontrada nas dependências');

      return false;
    }
  }

  /// Remover um objeto e disposar o mesmo se for disposavel[Disposeble]
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
      _printLog('Objeto $O removido com sucesso');
    } else {
      _printLog('Objeto $O não encontrado na lista de dependências');
    }
  }

  /// Remover todos os objetos, e disposar os mesmos se for
  /// disposavel[Disposeble] na lista dependências
  static Future<void> removeAll() async {
    if (_dependencies.isNotEmpty) {
      await Future.forEach<Dependency>(_dependencies, (o) {
        dependencyDispose(o.instance);
      });
      _dependencies.clear();
      _printLog('Todas as instâncias foram removidas com sucesso');
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

  static void _printLog(String message, {String? name}) {
    printLog(
      message,
      name: name ?? '$Dependencies',
    );
  }
}

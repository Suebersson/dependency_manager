part of './dependencies.dart';

/// Carregar e disposar uma instância automaticamente quando um Widget for
/// uma [StatefulWidget]. Para que isso aconteça, a instância deve ser injetada/adicionada
/// dentro do gerenciador de dependências [Dependencies] e será necessário herdar a
/// classe [DependencyState] ao invés da classe [State] nativa do flutter.
///
/// Quando o Widget for carregado, a instância de um [Object] estará pronta
/// para uso, basta acessar a propriedade [dependency] que estará disponível
/// dentro do widget.
abstract class DependencyState<T extends StatefulWidget, O> extends State<T> {
  late final O _dependency;

  O get dependency => _dependency;

  @override
  void initState() {
    _dependency = Dependencies.get<O>();
    super.initState();
  }

  @override
  void dispose() {
    Dependencies.dispose<O>();
    super.dispose();
  }
}

// Exemplo de como carregar e disposar uma dependência automaticamente
// dentro de uma [StatefulWidget], desde que a mesma tenha cido adicionada
// dentro de [Dependencies]
/*
class WidgetExample extends StatefulWidget {
  const WidgetExample({ Key? key }) : super(key: key);
  @override
  State<WidgetExample> createState() => _WidgetExampleState();
}

class _WidgetExampleState extends DependencyState<WidgetExample, Controller> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('DependencyState'),
      ),
      body: Center(
        child: Text(dependency.str),
      ),
    );
  }
}

class Controller extends Disposeble{
  
  String str = 'MyController';
  
  @override
  void dispose() {
    print('---- dispose Controller ----'); 
  }

}
*/

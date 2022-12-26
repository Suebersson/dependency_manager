part of './dependencies.dart';

// Para que essa função possa ser visível e usada/reaproveitada em todo package
//
// O mesmo deve ficar como uma função global para que não fique
// limidato a uma biblioteca ou classe, embora seja uma função que
// que deveiria ser acessada apenas pela classe [Dependencies].
//
// A arquitetura está dessa forma para que partes da package funcionem
// de formas indenpêndentes sem precisar ter que misturar tudo.
// [Dependencies], [routeManger], ...

/// Verificar o tipo de objeto e disposar se necessário
void dependencyDispose(dynamic o) {
  // Gerar uma throw e para a execução caso o objeto recebido é nulo
  //ArgumentError.checkNotNull(o, 'O objeto recebido é nulo');

  if (o == null) {
    // não faça nada
  } else if (o is Sink) {
    o.close();
    printLog('Objeto ${o.runtimeType} disposado', name: 'dependencyDispose');
  } else if (o is Disposeble || o is ChangeNotifier) {
    o.dispose();
    printLog('Objeto ${o.runtimeType} disposado', name: 'dependencyDispose');
  } else {
    // Tentar chamar o método dispose caso ele exista
    try {
      o.dispose();
    } catch (e) {
      // printLog(
      //   'O método dispose não existe no objeto ${o.runtimeType}',
      //   name: 'dependencyDispose'
      // );
    }
  }
}

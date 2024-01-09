import 'package:dependency_manager/dependency_manager.dart';

void main() async{

  /// executar/carregar multiplos procedimento que serão executados aos mesmo tempo(assíncrono) e
  /// depois que completar as execuções a app será iniciada
  await Future.wait([
    Dependencies.set([
      Dependency<AnyObject>(() => AnyObject(), isLazy: false, isSingleton: false),
      Dependency<Controller>.lazySingleton(() => Controller()),
      Dependency<HttpClient>.singleton(() => HttpClient())
    ]),
  ]).whenComplete(() {

    final Controller controller = Dependencies.get<Controller>();

    controller.method();

    // run ...

  });

}

class AnyObject{
  void method(){}
}
class Controller{
  void method(){}
}
class HttpClient{
  void method(){}
}

import 'package:flutter/material.dart';
import 'package:dependency_manager/dependency_manager.dart';
import 'package:dart_dev_utils/dart_dev_utils.dart' show Disposeble;

void main() async{

  /// Executar procedimentos antes ou depois da app iniciar
  WidgetsFlutterBinding.ensureInitialized();

  /// executar/carregar multiplos procedimento que serão executados aos mesmo tempo(assíncrono), 
  /// depois que completar as execuções a app será iniciada
  await Future.wait([
    Dependencies.set([
      Dependency<Controller>.lazySingleton(() => Controller())
    ])
  ]).whenComplete(() {
    runApp(const MyApp());
  });

}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({ Key? key }) : super(key: key);
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends DependencyState<MyHomePage, Controller> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dependency manager'),
      ),
      body: Center(
        child: Text(dependency.str),
      ),
    );
  }
}

class Controller extends Disposeble {

  String str = 'my data';

  @override
  void dispose() {
    print('---- dispose Controller ----');
  }
  
}
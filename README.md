# Observações importantes:

- A passagem de tipo genérico[O] sempre será obrigatória para todas as funções

- As funções [Dependencies.set] & [Dependencies.add] sempre irão verificar se o objeto de dependência já existe, impossibilitando criar e adicionar uma instância que já existe sendo singleton ou não. No caso da função [add], ela irá retornar a instância do objeto que já existe nas dependências.

<br />
<br />

### Como definir as dependências na inicialização da app

```dart
void main() async{

  /// Executar procedimentos antes ou depois da app iniciar
  WidgetsFlutterBinding.ensureInitialized();

  /// executar/carregar multiplos procedimento que serão executados aos mesmo tempo(assíncrono) e
  /// depois que completar as execuções a app será iniciada
  await Future.wait([
    Dependencies.set([
      Dependency<AnyObject>(() => AnyObject(), isLazy: false, isSingleton: false),
      Dependency<Controller>.lazySingleton(() => Controller()),
      Dependency<HttpClient>.singleton(() => HttpClient())
    ])
  ]).whenComplete(() {
    runApp(const MyApp());
  });

}
```

### Formas de como obter uma instância

```dart
Controller controller = Dependencies.get();

Controller controller = Dependencies.get<Controller>();

var controller = Dependencies.get<Controller>();
```

### Como adicionar uma instância depois que a app foi iniciada

```dart
Controller controllers = Dependencies.add<Controller>(() => Controller());
//ou
var controllers = Dependencies.add<Controller>(() => Controller());
//ou
Controller controllers = Dependencies.add(() => Controller());
```

### Como remover e disposar uma instância de dependência

```dart
Dependencies.remove<Tata>();
```

### Como remover e disposar todas as instância de dependência 

```dart
await Dependencies.removeAll();
```

### Como disposar uma instância. Essa função deve ser chamada quando o objeto for disposavel e singleton = false

```dart
Dependencies.dispose<Controller>();
```

### Como verificar se existe um objeto de dependência registrado

```dart
bool dependencyContains = Dependencies.contains<Controller>();
```

<br />
<br />

# Outras formas de acessar as mesmas funções estáticas sem acessar diretamente a classe [Dependencies]

<br />
<br />

### Obter uma instância herdando ou mixando a classe [Dependencies] 

```dart
class Widget extends StatelessWidget with Dependencies{
  @override
  Widget build(BuildContext context) {
    
    var controller = get<Controller>();

    return AnyWidget();
  }
}
```
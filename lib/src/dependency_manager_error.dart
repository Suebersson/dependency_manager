part of './dependencies.dart';

class DependencyManagerError implements Exception {
  final String message;

  const DependencyManagerError(this.message);

  @override
  String toString() => message;
}

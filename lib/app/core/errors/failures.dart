/// Base class for all failures in the application.
/// Used in the Domain layer to return errors without exposing implementation details (like Dio exceptions).
abstract class Failure {
  final String message;
  const Failure(this.message);
}

/// Represents failures coming from the Remote Data Source (API).
class ServerFailure extends Failure {
  const ServerFailure(super.message);
}

/// Represents failures coming from the Local Data Source (Hive/Cache).
class CacheFailure extends Failure {
  const CacheFailure(super.message);
}
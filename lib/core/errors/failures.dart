abstract class Failure {
  final String message;

  const Failure([this.message = ""]);

  @override
  bool operator ==(covariant Failure other) {
    return identical(this, other) || other.message == message;
  }

  @override
  int get hashCode => message.hashCode;
}

class RouteFailure extends Failure {
  final String routeName;
  const RouteFailure(this.routeName, super.message);
}

class AuthFailure extends Failure {
  final String action;
  const AuthFailure(this.action, super.message);
}

class CoinsFailure extends Failure {
  const CoinsFailure(super.message);
}

class CacheFailure extends Failure {
  const CacheFailure(super.message);
}

class NFTsFailure extends Failure {
  const NFTsFailure(super.message);
}

class WalletFailure extends Failure {
  const WalletFailure(super.message);
}

class StakFailure extends Failure {
  const StakFailure(super.message);
}

class P2PFailure extends Failure {
  const P2PFailure(super.message);
}

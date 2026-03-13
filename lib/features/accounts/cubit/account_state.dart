import '../model/account_model.dart';

abstract class AccountState {
  final List<Account> accounts;
  const AccountState({this.accounts = const []});
}

class AccountInitial extends AccountState {
  const AccountInitial() : super(accounts: const []);
}

class AccountLoading extends AccountState {
  const AccountLoading() : super();
}

class AccountLoaded extends AccountState {
  const AccountLoaded(List<Account> accounts) : super(accounts: accounts);
}

class AccountError extends AccountState {
  final String message;
  const AccountError(this.message);
}


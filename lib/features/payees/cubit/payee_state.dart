import '../model/payee_model.dart';

abstract class PayeeState {
  final List<Payee> payees;
  PayeeState({this.payees = const []});
}

class PayeeInitial extends PayeeState {}

class PayeeLoading extends PayeeState {}

class PayeeLoaded extends PayeeState {
  PayeeLoaded(List<Payee> payees) : super(payees: payees);
}

class PayeeError extends PayeeState {
  final String message;
  PayeeError(this.message);
}


import '../model/organization_model.dart';

abstract class OrganizationState {
  final List<OrganizationModel> organizations;

  const OrganizationState({this.organizations = const []});
}

class OrganizationInitial extends OrganizationState {
  const OrganizationInitial();
}

class OrganizationLoading extends OrganizationState {
  const OrganizationLoading();
}

class OrganizationLoaded extends OrganizationState {
  const OrganizationLoaded(List<OrganizationModel> organizations)
      : super(organizations: organizations);
}

class OrganizationError extends OrganizationState {
  final String message;

  const OrganizationError(this.message);
}


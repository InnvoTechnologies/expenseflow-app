import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/network/api_service.dart';
import '../model/organization_model.dart';
import 'organization_state.dart';

class OrganizationCubit extends Cubit<OrganizationState> {
  OrganizationCubit() : super(const OrganizationInitial());

  OrganizationModel? _selectedOrganization;

  OrganizationModel? get selectedOrganization => _selectedOrganization;

  Future<void> fetchOrganizations() async {
    emit(const OrganizationLoading());

    final result = await ApiService().getOrganizations({});

    result.fold(
      (failure) => emit(OrganizationError(failure.message)),
      (response) {
        final data = response.data['data'] as List<dynamic>;
        final organizations = data
            .map(
              (json) => OrganizationModel.fromJson(
                json as Map<String, dynamic>,
              ),
            )
            .toList();
        emit(OrganizationLoaded(organizations));
      },
    );
  }

  void selectOrganization(OrganizationModel? organization) {
    _selectedOrganization = organization;
    ApiService().setOrganizationId(organization?.id);
  }
}


import 'package:expenseflow/features/tags/model/tag_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/util/extensions.dart';
import '../../../core/network/api_service.dart';
import 'tag_state.dart';

class TagCubit extends Cubit<TagState> {
  TagCubit() : super(TagInitial());

  Future<void> getTags() async {
    emit(TagLoading());

    final result = await ApiService().getTags({});

    result.fold(
      (l) {
        emit(TagError(l.toString()));
      },
      (r) {
        try {
          final List<dynamic> rawData = r.data;

          final List<Tag> tags = rawData
              .map((json) => Tag.fromJson(json))
              .toList();

          emit(TagLoaded(tags));
        } catch (e) {
          emit(TagError('Data parsing error: $e'));
        }
      },
    );
  }

  Future<bool> createTag({required String name}) async {
    final params = <String, Object>{
      'name': name,
      'color': generateRandomColorHex(),
    };

    final result = await ApiService().createTag(params);

    return result.fold(
      (l) {
        emit(TagError(l.toString()));
        return false;
      },
      (r) {
        try {
          final Tag newTag = Tag.fromJson(r.data);
          final List<Tag> updatedTags = [newTag, ...state.tags];
          emit(TagLoaded(updatedTags));
        } catch (_) {
          getTags();
        }
        return true;
      },
    );
  }

  Future<bool> updateTag({required Tag tag, required String name}) async {
    final params = <String, Object>{'name': name, 'color': tag.color};

    final result = await ApiService().updateTag(tag.id, params);

    return result.fold(
      (l) {
        emit(TagError(l.toString()));
        return false;
      },
      (r) {
        try {
          final Tag updatedTag = Tag.fromJson(r.data);
          final List<Tag> updatedTags = state.tags
              .map((t) => t.id == updatedTag.id ? updatedTag : t)
              .toList();
          emit(TagLoaded(updatedTags));
        } catch (_) {
          getTags();
        }
        return true;
      },
    );
  }

  Future<bool> deleteTag(String id) async {
    final result = await ApiService().deleteTag(id);

    return result.fold(
      (l) {
        emit(TagError(l.toString()));
        return false;
      },
      (r) {
        final List<Tag> updatedTags = state.tags
            .where((t) => t.id != id)
            .toList();
        emit(TagLoaded(updatedTags));
        return true;
      },
    );
  }
}
import 'package:expenseflow/features/tags/model/tag_model.dart';

abstract class TagState {
  final List<Tag> tags;
  TagState({this.tags = const []});
}

class TagInitial extends TagState {}

class TagLoading extends TagState {}

class TagLoaded extends TagState {
  TagLoaded(List<Tag> tags) : super(tags: tags);
}

class TagError extends TagState {
  final String message;
  TagError(this.message);
}


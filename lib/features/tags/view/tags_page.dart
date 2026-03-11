// ignore_for_file: use_build_context_synchronously

import 'package:expenseflow/core/util/widgets/app_bar.dart';
import 'package:expenseflow/features/tags/cubit/tag_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/util/const/constants.dart';
import '../../../core/util/loading/page_loading_spinner.dart';
import '../../../core/util/loading/show_loading_spinner.dart';
import '../../../core/util/widgets/dialogs.dart';
import '../cubit/tag_state.dart';
import '../model/tag_model.dart';

class TagsPage extends StatefulWidget {
  const TagsPage({super.key});

  @override
  State<TagsPage> createState() => _TagsPageState();
}

class _TagsPageState extends State<TagsPage> {
  @override
  void initState() {
    super.initState();
    context.read<TagCubit>().getTags();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        title: 'Tags',
        actions: [
          IconButton(
            onPressed: () => _openTagForm(null),
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: Padding(
        padding: kDefaultPadding,
        child: BlocBuilder<TagCubit, TagState>(
          builder: (context, state) {
            if (state is TagLoading) {
              return const Center(child: PageLoadingSpinner());
            }

            if (state is TagError) {
              return Center(child: Text('Error: ${state.message}'));
            }

            if (state.tags.isEmpty) {
              return const Center(child: Text('No tags found.'));
            }

            return ListView.builder(
              itemCount: state.tags.length,
              itemBuilder: (context, i) {
                final Tag tag = state.tags[i];
                return Card(
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: convertColorStringToFlutterColor(
                        tag.color,
                      ),
                    ),
                    title: Text(tag.name),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () => _openTagForm(tag),
                          icon: const Icon(Icons.edit),
                        ),
                        IconButton(
                          onPressed: () => _confirmDelete(tag),
                          icon: const Icon(Icons.delete_outline),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  Future<void> _openTagForm(Tag? tag) async {
    final result = await showDialog<String>(
      context: context,
      builder: (context) => NameInputDialog(
        title: tag == null ? 'New Tag' : 'Edit Tag',
        label: 'Name',
        initialValue: tag?.name ?? '',
      ),
    );

    if (result == null || result.isEmpty) return;

    if (tag == null) {
      showLoadingSpinner(context);

      final success = await context.read<TagCubit>().createTag(name: result);

      Navigator.of(context).pop();
      if (success) {
        showSuccessSnackbar('Tag created successfully');
      } else {
        showFailedSnackbar('Failed to create tag');
      }
      return;
    }

    showLoadingSpinner(context);

    final success = await context.read<TagCubit>().updateTag(
      tag: tag,
      name: result,
    );

    Navigator.of(context).pop();

    if (success) {
      showSuccessSnackbar('Tag updated successfully');
    } else {
      showFailedSnackbar('Failed to update tag');
    }
  }

  Future<void> _confirmDelete(Tag tag) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => ConfirmDeleteDialog(
        title: 'Delete Tag',
        message: 'Are you sure you want to delete "${tag.name}"?',
      ),
    );

    if (confirmed != true) return;

    showLoadingSpinner(context);

    final success = await context.read<TagCubit>().deleteTag(tag.id);

    Navigator.of(context).pop();

    if (success) {
      showSuccessSnackbar('Tag deleted successfully');
    } else {
      showFailedSnackbar('Failed to delete tag');
    }
  }
}

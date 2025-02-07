import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_task/logic/bloc/bloc/treenode_bloc.dart';
import 'package:test_task/logic/bloc/bloc/treenode_state.dart';
import 'package:test_task/logic/model/temp_data.dart';

class ExpansionTileWidget extends StatelessWidget {
  const ExpansionTileWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TreenodeBloc, TreenodeState>(
      builder: (context, state) {
        if (state is TreenodeInitial || state is TreenodeUpdated) {
          final nodes = state is TreenodeInitial
              ? state.nodes
              : (state as TreenodeUpdated).nodes;

          return ListView(
            children: nodes.map((node) => TreeNodeWidget(node: node)).toList(),
          );
        }
        return const CircularProgressIndicator();
      },
    );
  }
}

class TreeNodeWidget extends StatelessWidget {
  final TreeNode node;

  const TreeNodeWidget({super.key, required this.node});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            if (node.children.isNotEmpty)
              IconButton(
                icon: Icon(node.isExpanded ? Icons.remove : Icons.add),
                onPressed: () =>
                    context.read<TreenodeBloc>().add(ToggleExpansion(node.id)),
              ),
            Expanded(
              child: TextField(
                controller: TextEditingController(text: node.title),
                onSubmitted: (value) => context
                    .read<TreenodeBloc>()
                    .add(UpdateTitle(node.id, value)),
              ),
            ),
            Checkbox(
              value: node.isChecked,
              onChanged: (_) =>
                  context.read<TreenodeBloc>().add(ToggleCheckbox(node.id)),
            ),
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () =>
                  context.read<TreenodeBloc>().add(AddChild(node.id)),
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () =>
                  context.read<TreenodeBloc>().add(RemoveNode(node.id)),
            ),
          ],
        ),
        if (node.isExpanded)
          Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: Column(
              children: node.children
                  .map((child) => TreeNodeWidget(node: child))
                  .toList(),
            ),
          ),
      ],
    );
  }
}

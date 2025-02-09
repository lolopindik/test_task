import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:test_task/logic/bloc/bloc/treenode_state.dart';
import 'package:test_task/logic/model/temp_data.dart';

part 'treenode_event.dart';

class TreenodeBloc extends Bloc<TreenodeEvent, TreenodeState> {
  TreenodeBloc()
      : super(TreenodeInitial(nodes: [
          TreeNode(id: 'root', title: 'Корневой элемент'),
        ])) {
    on<ToggleExpansion>(_toggleExpansion);
    on<UpdateTitle>(_updateTitle);
    on<ToggleCheckbox>(_toggleCheckbox);
    on<AddChild>(_addChild);
    on<RemoveNode>(_removeNode);
  }

  void _toggleExpansion(ToggleExpansion event, Emitter<TreenodeState> emit) {
    final updatedNodes = _updateNode(state.nodes, event.nodeId, (node) {
      node.isExpanded = !node.isExpanded;
    });
    emit(TreenodeUpdated(nodes: updatedNodes));
  }

  void _updateTitle(UpdateTitle event, Emitter<TreenodeState> emit) {
    final updatedNodes = _updateNode(state.nodes, event.nodeId, (node) {
      node.title = event.newTitle;
    });
    emit(TreenodeUpdated(nodes: updatedNodes));
  }

  void _toggleCheckbox(ToggleCheckbox event, Emitter<TreenodeState> emit) {
    final updatedNodes = _updateNode(state.nodes, event.nodeId, (node) {
      node.isChecked = !node.isChecked;

      _updateChildNodes(node, node.isChecked);
    });

    final finalNodes = _updateParentCheckbox(updatedNodes);
    emit(TreenodeUpdated(nodes: finalNodes));
  }

  void _updateChildNodes(TreeNode node, bool isChecked) {
    for (var child in node.children) {
      child.isChecked = isChecked;
      _updateChildNodes(child, isChecked);
    }
  }

  void _addChild(AddChild event, Emitter<TreenodeState> emit) {
    final updatedNodes = _updateNode(state.nodes, event.nodeId, (node) {
      node.children = List.from(node.children)
        ..add(TreeNode(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          title: 'Новый элемент',
          isExpanded: false,
          isChecked: false,
        ));
    });
    emit(TreenodeUpdated(nodes: updatedNodes));
  }

  void _removeNode(RemoveNode event, Emitter<TreenodeState> emit) {
    final updatedNodes = _removeNodeById(state.nodes, event.nodeId);
    emit(TreenodeUpdated(nodes: updatedNodes));
  }

  List<TreeNode> _updateNode(
      List<TreeNode> nodes, String nodeId, void Function(TreeNode) update) {
    return nodes.map((node) {
      if (node.id == nodeId) {
        update(node);
      }
      return node.copyWith(
        children: _updateNode(node.children, nodeId, update),
      );
    }).toList();
  }

  List<TreeNode> _removeNodeById(List<TreeNode> nodes, String nodeId) {
    return nodes
        .where((node) => node.id != nodeId)
        .map((node) => node.copyWith(
              children: _removeNodeById(node.children, nodeId),
            ))
        .toList();
  }

  List<TreeNode> _updateParentCheckbox(List<TreeNode> nodes) {
    return nodes.map((node) {
      if (node.children.isNotEmpty) {
        bool allChecked = node.children.every((child) => child.isChecked);
        node.isChecked = allChecked;
      }
      return node;
    }).toList();
  }
}

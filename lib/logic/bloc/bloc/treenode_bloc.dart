import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:test_task/logic/bloc/bloc/treenode_state.dart';
import 'package:test_task/logic/model/temp_data.dart';

part 'treenode_event.dart';

class TreenodeBloc extends Bloc<TreenodeEvent, TreenodeState> {
  TreenodeBloc()
      : super(TreenodeInitial(nodes: [
          TreeNode(id: 0, title: 'Корневой элемент'),
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
    });

    final finalNodes = _updateAllParentCheckboxes(updatedNodes, event.nodeId);
    emit(TreenodeUpdated(nodes: finalNodes));
  }

  List<TreeNode> _updateAllParentCheckboxes(List<TreeNode> nodes, int changedNodeId) {
    bool updateParent(TreeNode node) {
      if (node.children.isNotEmpty) {
        bool allChecked = node.children.every((child) => child.isChecked);
        bool anyChecked = node.children.any((child) => child.isChecked);

        if (anyChecked) {
          node.isChecked = true;
        } 
        else if (!allChecked) {
          node.isChecked = false;
        } 
        else {
          node.isChecked = false; 
        }
      }
      return node.isChecked;
    }


    List<TreeNode> traverseAndUpdate(List<TreeNode> nodes) {
      return nodes.map((node) {
        node = node.copyWith(
          children: traverseAndUpdate(node.children),
        );
        if (node.children.any((child) => child.id == changedNodeId) || node.children.any((child) => child.isChecked)) {
          updateParent(node);
        }
        return node;
      }).toList();
    }

    return traverseAndUpdate(nodes);
  }

  void _addChild(AddChild event, Emitter<TreenodeState> emit) {
    final updatedNodes = _updateNode(state.nodes, event.nodeId, (node) {
      node.children = List.from(node.children)
        ..add(TreeNode(
          id: DateTime.now().millisecondsSinceEpoch,
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
      List<TreeNode> nodes, int nodeId, void Function(TreeNode) update) {
    return nodes.map((node) {
      if (node.id == nodeId) {
        update(node);
      }
      return node.copyWith(
        children: _updateNode(node.children, nodeId, update),
      );
    }).toList();
  }

  List<TreeNode> _removeNodeById(List<TreeNode> nodes, int nodeId) {
    return nodes
        .where((node) => node.id != nodeId)
        .map((node) => node.copyWith(
              children: _removeNodeById(node.children, nodeId),
            ))
        .toList();
  }
}

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
    Map<int, TreeNode> nodeMap = {};
    
    void mapNodes(List<TreeNode> nodes) {
      for (var node in nodes) {
        nodeMap[node.id] = node;
        mapNodes(node.children);
      }
    }

    mapNodes(nodes);

    void updateParent(int nodeId) {
      var parent = nodeMap.values.firstWhere(
        (node) => node.children.any((child) => child.id == nodeId),
        orElse: () => TreeNode(id: -1, title: '', children: []),
      );

      if (parent.id != -1) {
        bool allChecked = parent.children.every((child) => child.isChecked);
        bool anyChecked = parent.children.any((child) => child.isChecked);

        parent.isChecked = allChecked ? true : anyChecked ? true : false;
        updateParent(parent.id);
      }
    }

    updateParent(changedNodeId);
    return nodes;
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

part of 'treenode_bloc.dart';

@immutable
abstract class TreenodeEvent {}

class ToggleExpansion extends TreenodeEvent {
  final int nodeId;
  ToggleExpansion(this.nodeId);
}

class UpdateTitle extends TreenodeEvent {
  final int nodeId;
  final String newTitle;
  UpdateTitle(this.nodeId, this.newTitle);
}

class ToggleCheckbox extends TreenodeEvent {
  final int nodeId;
  ToggleCheckbox(this.nodeId);
}

class AddChild extends TreenodeEvent {
  final int nodeId;
  AddChild(this.nodeId);
}

class RemoveNode extends TreenodeEvent {
  final int nodeId;
  RemoveNode(this.nodeId);
}

part of 'treenode_bloc.dart';

@immutable
abstract class TreenodeEvent {}

class ToggleExpansion extends TreenodeEvent {
  final String nodeId;
  ToggleExpansion(this.nodeId);
}

class UpdateTitle extends TreenodeEvent {
  final String nodeId;
  final String newTitle;
  UpdateTitle(this.nodeId, this.newTitle);
}

class ToggleCheckbox extends TreenodeEvent {
  final String nodeId;
  ToggleCheckbox(this.nodeId);
}

class AddChild extends TreenodeEvent {
  final String nodeId;
  AddChild(this.nodeId);
}

class RemoveNode extends TreenodeEvent {
  final String nodeId;
  RemoveNode(this.nodeId);
}

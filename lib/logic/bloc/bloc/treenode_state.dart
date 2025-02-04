// ignore_for_file: use_super_parameters

import 'package:meta/meta.dart';
import 'package:test_task/logic/model/temp_data.dart';

@immutable
abstract class TreenodeState {
  final List<TreeNode> nodes;
  const TreenodeState({required this.nodes});
}

class TreenodeInitial extends TreenodeState {
  const TreenodeInitial({required List<TreeNode> nodes}) : super(nodes: nodes);
}

class TreenodeUpdated extends TreenodeState {
  const TreenodeUpdated({required List<TreeNode> nodes}) : super(nodes: nodes);
}

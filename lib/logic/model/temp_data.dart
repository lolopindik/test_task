class TreeNode {
  int id;
  String title;
  bool isExpanded;
  bool isChecked;
  List<TreeNode> children;

  TreeNode({
    required this.id,
    required this.title,
    this.isExpanded = false,
    this.isChecked = false,
    this.children = const [],
  });

  TreeNode copyWith({
    int? id,
    String? title,
    bool? isExpanded,
    bool? isChecked,
    List<TreeNode>? children,
  }) {
    return TreeNode(
      id: id ?? this.id,
      title: title ?? this.title,
      isExpanded: isExpanded ?? this.isExpanded,
      isChecked: isChecked ?? this.isChecked,
      children: children ?? this.children,
    );
  }
}

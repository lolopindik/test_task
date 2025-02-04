import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_task/logic/bloc/bloc/treenode_bloc.dart';
import 'package:test_task/presentation/widget/expansion_tile_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TreenodeBloc(),
      child: Scaffold(
        body: Container(
          margin: EdgeInsets.all(15),
          child: ExpansionTileWidget()),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:push_app/presentation/blocs/notifications/notifications_bloc.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {

final textStyle = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: context.select(
          (NotificationsBloc bloc)=> Text('${bloc.state.status}',style: textStyle.bodyLarge,)
          ),
        actions: [IconButton(onPressed: () {
          context.read<NotificationsBloc>().requestPermission();
        
        }, icon: Icon(Icons.settings))],
      ),
      body: _HomeView(),
    );
  }
}

class _HomeView extends StatelessWidget {
  const _HomeView();

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 1,
      itemBuilder: (BuildContext context, int index) {
        return const ListTile();
      },
    );    
  }
}

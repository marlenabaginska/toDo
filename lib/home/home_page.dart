import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wydatki/home/category_widget.dart';
import 'package:wydatki/home/cubit/home_cubit.dart';

class HomePage extends StatelessWidget {
  HomePage({
    Key? key,
  }) : super(key: key);

  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeCubit()..start(),
      child: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Do kupienia:'),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                context.read<HomeCubit>().add(
                      controller: controller.text,
                    );
                controller.clear();
              },
              child: const Icon(
                Icons.add,
              ),
            ),
            body: BlocProvider(
              create: (context) => HomeCubit()..start(),
              child: BlocBuilder<HomeCubit, HomeState>(
                builder: (context, state) {
                  if (state.errorMessage.isNotEmpty) {
                    return Center(
                      child: Text(
                        'Wystąpił nieoczekiwany problem: ${state.errorMessage}',
                      ),
                    );
                  }
                  if (state.isLoading) {
                    return const Center(
                      child: Text('Proszę czekać trwa ładowanie danych'),
                    );
                  }
                  final documents = state.documents;

                  return ListView(
                    children: [
                      for (final document in documents) ...[
                        Dismissible(
                          key: ValueKey(document.id),
                          onDismissed: (_) {
                            context
                                .read<HomeCubit>()
                                .delete(document: document.id);
                          },
                          child: CategoryWidget(
                            document['title'],
                          ),
                        ),
                      ],
                      TextField(
                        controller: controller,
                      ),
                    ],
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}

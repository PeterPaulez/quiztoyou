import 'package:flutter/material.dart';
import 'package:quiztoyou/app/home/jobs/empty_content.dart';
import 'package:quiztoyou/app/home/models/job.dart';

typedef ItemWidgetBuilder<T> = Widget Function(BuildContext context, T item);

class ListItemsBuilder<T> extends StatelessWidget {
  final AsyncSnapshot<List<T>?> snapshot;
  final ItemWidgetBuilder<T> itemBuilder;
  const ListItemsBuilder(
      {Key? key, required this.snapshot, required this.itemBuilder})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (snapshot.hasData) {
      final List<T>? items = snapshot.data;
      if (items != null) {
        print('Hello');
        items.map((e) => print(e));
        _buildList(items);
      } else {
        return EmptyContent();
      }
    } else if (snapshot.hasError) {
      return EmptyContent(
        title: 'Something went wrong',
        message: 'Cannot load items right now',
      );
    }

    return Container(child: CircularProgressIndicator());
  }

  Widget _buildList(List<T> items) {
    print('Hello 2 ${items.length}');
    final job = items[0] as Job;
    print(job.ratePerHour);
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        print('Hello 3');
        print(items[index]);
        return itemBuilder(context, items[index]);
      },
    );
  }
}

import 'package:flutter/material.dart';

class NewJobPage extends StatefulWidget {
  NewJobPage({Key? key}) : super(key: key);

  static Future<void> show(BuildContext context) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => NewJobPage(),
        fullscreenDialog: true,
      ),
    );
  }

  @override
  _NewJobPageState createState() => _NewJobPageState();
}

class _NewJobPageState extends State<NewJobPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        title: Text('New Job'),
      ),
    );
  }
}

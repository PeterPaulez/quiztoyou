import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quiztoyou/app/home/models/job.dart';
import 'package:quiztoyou/services/database.dart';

class NewJobPage extends StatefulWidget {
  final Database database;
  NewJobPage({Key? key, required this.database}) : super(key: key);

  static Future<void> show(BuildContext context) async {
    /// The context is from jobs_page instead of new_jobs_page
    /// instead of few lines bellow where the context is from the new_jobs_page
    final database = Provider.of<Database>(context, listen: false);
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => NewJobPage(database: database),
        fullscreenDialog: true,
      ),
    );
  }

  @override
  _NewJobPageState createState() => _NewJobPageState();
}

class _NewJobPageState extends State<NewJobPage> {
  GlobalKey<FormState> _formKey = GlobalKey();
  String? _name;
  int? _ratePerHour;

  bool _validateAndSaveForm() {
    final form = _formKey.currentState!;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  void _submit() async {
    if (_validateAndSaveForm()) {
      print('Form Saved');
      print('Name: $_name');
      print('Rate: $_ratePerHour');
      final job = Job(name: _name!, ratePerHour: _ratePerHour!);
      await widget.database.createJob(job);
      Navigator.of(context).pop();

      /// It is not working because new_jobs_page is not a child of provider database
      /// So the best solution is pass the database to the constructor of new_jobs_page
      //final database = Provider.of<Database>(context, listen: false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        title: Text('New Job'),
        actions: [
          TextButton(
            onPressed: _submit,
            child: Text(
              'Save',
              style: TextStyle(
                fontSize: 18,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
      body: _buildContents(),
      backgroundColor: Colors.grey[200],
    );
  }

  Widget _buildContents() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: _buildForm(),
          ),
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: _buildFormChildren(),
      ),
    );
  }

  List<Widget> _buildFormChildren() {
    return [
      TextFormField(
        decoration: InputDecoration(labelText: 'Job name'),
        onSaved: (value) => _name = value,
        validator: (value) => value!.isNotEmpty ? null : 'Name canot be empty',
      ),
      TextFormField(
        decoration: InputDecoration(labelText: 'Rate per hour'),
        keyboardType: TextInputType.numberWithOptions(
          signed: false,
          decimal: false,
        ),
        onSaved: (value) {
          print('Value: $value');
          _ratePerHour = 0;
          if (value != '') {
            try {
              _ratePerHour = int.parse(value!);
            } catch (e) {}
          }
        },
      ),
    ];
  }
}
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quiztoyou/app/home/models/job.dart';
import 'package:quiztoyou/common_widgets/dialog.dart';
import 'package:quiztoyou/services/database.dart';

class JobPageDetail extends StatefulWidget {
  final Database database;
  final Job? job;
  JobPageDetail({Key? key, required this.database, this.job}) : super(key: key);

  static Future<void> show(BuildContext context, {Job? job}) async {
    /// The context is from jobs_page instead of new_jobs_page
    /// instead of few lines bellow where the context is from the new_jobs_page
    final database = Provider.of<Database>(context, listen: false);
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => JobPageDetail(database: database, job: job),
        fullscreenDialog: true,
      ),
    );
  }

  @override
  _JobPageDetailState createState() => _JobPageDetailState();
}

class _JobPageDetailState extends State<JobPageDetail> {
  GlobalKey<FormState> _formKey = GlobalKey();
  String? _name;
  int? _ratePerHour;

  @override
  void initState() {
    super.initState();
    if (widget.job != null) {
      _name = widget.job!.name;
      _ratePerHour = widget.job!.ratePerHour;
    }
  }

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
      ProgressDialog.show(context);
      try {
        /// Testing repeated Job firstable
        /// .first is very important to have the newest version of the data IMPORTANT
        final jobs = await widget.database.jobsStream().first;
        final allNames = jobs!.map((job) => job.name).toList();
        if (allNames.contains(_name)) {
          ProgressDialog.dissmiss(context);
          TextDialog.alert(
            context,
            title: 'Name already used',
            content: 'Please choose a different name',
            textOK: 'Ok',
          );
        } else {
          ProgressDialog.dissmiss(context);
          final job = Job(name: _name!, ratePerHour: _ratePerHour!);
          await widget.database.createJob(job);
          Navigator.of(context).pop();
        }
      } on FirebaseException catch (err) {
        ProgressDialog.dissmiss(context);
        ShowExceptionDialog.alert(
          context: context,
          title: 'Form submitted Failed',
          exception: err,
        );
      }

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
        title: Text(widget.job == null ? 'New Job' : 'Edit Job'),
        actions: [
          TextButton(
            onPressed: _submit,
            child: Text(
              widget.job == null ? 'Save' : 'Edit',
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
        initialValue: _name,
        decoration: InputDecoration(labelText: 'Job name'),
        onSaved: (value) => _name = value,
        validator: (value) => value!.isNotEmpty ? null : 'Name canot be empty',
      ),
      TextFormField(
        initialValue: _ratePerHour != null ? _ratePerHour.toString() : null,
        decoration: InputDecoration(labelText: 'Rate per hour'),
        keyboardType: TextInputType.numberWithOptions(
          signed: false,
          decimal: false,
        ),
        onSaved: (value) {
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

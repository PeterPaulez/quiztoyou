import 'package:flutter/material.dart';
import 'package:quiztoyou/app/home/models/job.dart';

class JobsListTile extends StatelessWidget {
  final Job job;
  final VoidCallback onTap;
  const JobsListTile({
    Key? key,
    required this.job,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(job.name),
      subtitle: Text(job.ratePerHour.toString() + ' Hours'),
      trailing: Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}

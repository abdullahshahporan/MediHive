import 'package:flutter/material.dart';
import 'package:medi_hive/UI/utils/appcolor.dart';

class TaskCard extends StatefulWidget {
  const TaskCard({
    super.key,
   // required this.taskModel,
    required this.onRefreshList,
  });
  //final TaskModel taskModel;
  final VoidCallback onRefreshList;
  @override
  State<TaskCard> createState() => _TaskCardState();
}

class _TaskCardState extends State<TaskCard> {
  String _selectedStatus = '';

  bool _changeStatusInProgress = false;
  bool _deleteTaskInProgress = false;

  @override
  void initState() {
    super.initState();
    //_selectedStatus = widget.taskModel.status!;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Colors.white,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              /*widget.taskModel.title ??*/
              'Shahporan',
              style: Theme
                  .of(context)
                  .textTheme
                  .titleSmall,
            ),
            Text(
              /*widget.taskModel.description ??*/
              'aaaa',
              style: Theme
                  .of(context)
                  .textTheme
                  .bodySmall,
            ),
            Text(
              /*'Date: ${widget.taskModel.createdDate ?? ''},}'*/
              'date',
              style: Theme
                  .of(context)
                  .textTheme
                  .bodySmall,
            ),
            const SizedBox(
              height: 8,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buidTaskStatusChip(),
                Wrap(
                  children: [
                    Visibility(
                      visible: _changeStatusInProgress == false,
                      replacement: const CircularProgressIndicator(),
                      child: IconButton(
                        onPressed: _onTapEditButton,
                        icon: Icon(Icons.edit),
                      ),
                    ),
                    Visibility(
                      visible: _deleteTaskInProgress == false,
                      replacement: const CircularProgressIndicator(),
                      child: IconButton(
                        onPressed: _onTapDeleteButton,
                        icon: Icon(Icons.delete),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _onTapEditButton() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Edit Status'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: ['New', 'Completed', 'Cancelled', 'Progress'].map((e) {
                return ListTile(
                  onTap: () {
                    _changeStatus(e);
                    Navigator.pop(context);
                  },
                  title: Text(e),
                  selected: _selectedStatus == e,
                  trailing: _selectedStatus == e ? Icon(Icons.check) : null,
                );
              }).toList(),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Cancel'),
              ),
              TextButton(
                onPressed: () {},
                child: Text('Ok'),
              ),
            ],
          );
        });
  }

  Future<void> _onTapDeleteButton() async {
    /* _deleteTaskInProgress= true;
    setState(() {});
    final NetworkResponse response = await NetworkCaller.getRequest(
        url: Urls.deleteTask(widget.taskModel.sId!));
    if(response.isSuccess)
    {
      widget.onRefreshList();
      _deleteTaskInProgress=false;
      setState(() {});
    }
    else
    {
      _deleteTaskInProgress=false;
      setState(() {});

      showSnackBarMessage(context, response.errorMessage);
    }*/

  }

  Widget _buidTaskStatusChip() {
    return Chip(
      label: Text(

        /// widget.taskModel.status!,
        'status',
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      side: BorderSide(color: AppColor.themeColor),
    );
  }

  Future<void> _changeStatus(String newStatus) async {
    /* _changeStatusInProgress = true;
    setState(() {});
    final NetworkResponse response = await NetworkCaller.getRequest(
        url: Urls.changeTaskStatus(widget.taskModel.sId!, newStatus));
    if(response.isSuccess)
    {
      widget.onRefreshList();
      _changeStatusInProgress=false;
      setState(() {});
    }
    else
    {
      _changeStatusInProgress=false;
      setState(() {});

      showSnackBarMessage(context, response.errorMessage);
    }
  }*/
  }
}
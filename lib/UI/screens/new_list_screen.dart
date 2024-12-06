
import 'package:flutter/material.dart';
import 'package:medi_hive/widgets/centre_circular_progress_indicator.dart';

import 'add_new_screen.dart';

class NewMedicineScreen extends StatefulWidget {
  const NewMedicineScreen({
    super.key,
  });

  @override
  State<NewMedicineScreen> createState() => _NewMedicineScreenState();
}

class _NewMedicineScreenState extends State<NewMedicineScreen> {
  bool _getNewTaskListInProgress = false;
  bool _getTaskStatusCountListInProgress = false;

  //List<TaskModel> _newTaskList = [];
  //List<TaskStatusModel> _taskStatusCountList = [];

  @override
  void initState() {
    super.initState();
    _getNewTaskList();
    //  _getTaskStatusCount();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          _getNewTaskList();
          // _getTaskStatusCount();
        },
        child: Column(
          children: [
            _buildSummarySection(),
            Expanded(
              child: Visibility(
                visible: !_getNewTaskListInProgress,
                replacement: const CenterCircularProgressIndicator(),
                child: ListView.separated(
                  itemCount: 20,
                  itemBuilder: (context, index) {
                    /*return TaskCard(
                      taskModel: _newTaskList[index],
                      onRefreshList: () {
                        _getNewTaskList();
                      },
                    );*/
                  },
                  separatorBuilder: (context, index) {
                    return const SizedBox(
                      height: 8,
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _onTapFABButton,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildSummarySection() {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Visibility(
        visible: _getTaskStatusCountListInProgress == false,
        replacement: const CenterCircularProgressIndicator(),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            //children: _getTaskSummaryCardList(),
          ),
        ),
      ),
    );
  }

  /*List<TaskSummaryCard> _getTaskSummaryCardList()
  {
    List<TaskSummaryCard> taskSummaryCardList=[];
    for(TaskStatusModel t in _taskStatusCountList)
    {
      taskSummaryCardList.add(TaskSummaryCard(title: t.sId!, count: t.sum ?? 0));
    }
    return taskSummaryCardList;
  }*/
  Future<void> _onTapFABButton() async {
    /*final bool ? _shouldRefresh=await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AddNewTaskScreen(),
      ),
    );
    if(_shouldRefresh==true)
    {
      _getNewTaskList();
    }*/
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>AddNewMedicineScreen()), (route) => false);
  }

  Future<void> _getNewTaskList() async {
    /*_newTaskList.clear();
    _getNewTaskListInProgress = true;
    setState(() {});
    final NetworkResponse response =
    await NetworkCaller.getRequest(url: Urls.newTaskList);
    if (response.isSuccess) {
      final TaskListModel taskListModel =
      TaskListModel.fromJson(response.responseData);
      _newTaskList = taskListModel.taskList ?? [];
    } else {
      showSnackBarMessage(context, response.errorMessage, true);
    }
    _getNewTaskListInProgress = false;
    setState(() {});
  }
  Future<void> _getTaskStatusCount() async {
    _taskStatusCountList.clear();
    _getTaskStatusCountListInProgress = true;
    setState(() {});
    final NetworkResponse response =
    await NetworkCaller.getRequest(url: Urls.taskStatusCount);
    if (response.isSuccess) {
      final TaskStatusCountModel taskStatusCountModel =
      TaskStatusCountModel.fromJson(response.responseData);
      _taskStatusCountList = taskStatusCountModel.taskStatusCountList ?? [];
    } else {
      showSnackBarMessage(context, response.errorMessage, true);
    }
    _getTaskStatusCountListInProgress = false;
    setState(() {});
  }*/
  }
}
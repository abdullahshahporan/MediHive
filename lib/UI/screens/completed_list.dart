import 'package:flutter/material.dart';
import 'package:medi_hive/widgets/centre_circular_progress_indicator.dart';

class CompleteMedicineScreen extends StatefulWidget {
  const CompleteMedicineScreen({super.key});

  @override
  State<CompleteMedicineScreen> createState() => _CompleteMedicineScreenState();
}

class _CompleteMedicineScreenState extends State<CompleteMedicineScreen> {
  bool _getCompletedMedicineListInProgress = false;

  // List<TaskModel> _completedTaskList = [];

  @override
  void initState() {
    super.initState();
    _getCompletedTaskList();
  }

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: !_getCompletedMedicineListInProgress,
      replacement: const CenterCircularProgressIndicator(),
      child: RefreshIndicator(
        onRefresh: () async {
          _getCompletedTaskList();
        },
        child: ListView.separated(
          itemCount: 10,
          itemBuilder: (context, index) {
            /*return TaskCard(
              taskModel: _completedTaskList[index],
              onRefreshList: _getCompletedTaskList,
            );*/
          },
          separatorBuilder: (context, index) {
            return const SizedBox(height: 8);
          },
        ),
      ),
    );
  }

  Future<void> _getCompletedTaskList() async {
    /*_completedTaskList.clear();
    _getCompletedTaskListInProgress = true;
    setState(() {});
    final NetworkResponse response =
    await NetworkCaller.getRequest(url: Urls.completedTaskList);
    if (response.isSuccess) {
      final TaskListModel taskListModel =
      TaskListModel.fromJson(response.responseData);
      _completedTaskList = taskListModel.taskList ?? [];
    } else {
      showSnackBarMessage(context, response.errorMessage, true);
    }
    _getCompletedTaskListInProgress = false;
    setState(() {});
  }*/
  }
}
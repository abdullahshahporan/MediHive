import 'package:flutter/material.dart';
import 'package:medi_hive/widgets/centre_circular_progress_indicator.dart';

class AddNewMedicineScreen extends StatefulWidget {
  const AddNewMedicineScreen({super.key});

  @override
  State<AddNewMedicineScreen> createState() => _AddNewMedicineScreenState();
}

class _AddNewMedicineScreenState extends State<AddNewMedicineScreen> {
  final TextEditingController _titleTEController = TextEditingController();
  final TextEditingController _descriptionTEController =
  TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _addNewTaskInProgress = false;
  bool _shouldRefreshPreviousPage = false;


  @override
  Widget build(BuildContext context) {
    return PopScope(
        canPop: false,
       /* onPopInvokedWithResult: (didPop, result) {
          if (didPop) {
            return;
          }
          Navigator.pop(context, _shouldRefreshPreviousPage);
        },*/
        child: Scaffold(
          appBar: AppBar(),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 42),
                    Text(
                      'Add New Task',
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge
                          ?.copyWith(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 24),
                    TextFormField(
                      controller: _titleTEController,
                      decoration: const InputDecoration(hintText: 'Title'),
                      validator: (String? value) {
                        if (value?.trim().isEmpty ?? true) {
                          return 'Enter a value';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _descriptionTEController,
                      maxLines: 5,
                      decoration:
                      const InputDecoration(hintText: 'Description'),
                      validator: (String? value) {
                        if (value?.trim().isEmpty ?? true) {
                          return 'Enter a value';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    Visibility(
                      visible: !_addNewTaskInProgress,
                      replacement: const CenterCircularProgressIndicator(),
                      child: ElevatedButton(
                        onPressed: _onTapSubmitButton,
                        child: const Icon(Icons.arrow_circle_right_outlined),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }

  void _onTapSubmitButton() {
    if (_formKey.currentState!.validate()) {
      _addNewTask();
    }
  }

  Future<void> _addNewTask() async {

    /*_addNewTaskInProgress = true;
    setState(() {});
    Map<String, dynamic> requestBody = {
      'title': _titleTEController.text.trim(),
      'description': _descriptionTEController.text.trim(),
      'status': 'New',
    };
    final NetworkResponse response = await NetworkCaller.postRequest(
        url: Urls.addNewTask, body: requestBody);
    _addNewTaskInProgress = false;
    setState(() {});
    if (response.isSuccess) {
      _shouldRefreshPreviousPage=true;
      _clearTextFields();
      showSnackBarMessage(context, 'New task added!');
    } else {
      showSnackBarMessage(context, response.errorMessage, true);
    }*/
  }

  void _clearTextFields() {
    _titleTEController.clear();
    _descriptionTEController.clear();
  }

  @override
  void dispose() {
    _titleTEController.dispose();
    _descriptionTEController.dispose();
    super.dispose();
  }
}
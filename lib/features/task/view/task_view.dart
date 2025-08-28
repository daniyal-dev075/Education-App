import 'package:education_app/res/components/loader.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../res/app_colors.dart';
import '../view_model/task_view_model.dart';
import '../../auth_and_profile/view_model/user_view_model.dart';
import '../../../res/components/task_tile.dart';
import '../../../utils/utils.dart';

class TaskView extends StatefulWidget {
  const TaskView({super.key});

  @override
  State<TaskView> createState() => _TaskViewState();
}

class _TaskViewState extends State<TaskView> {
  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final taskVM = Provider.of<TaskViewModel?>(context);
    final userVM = Provider.of<UserViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Text(
          "Task Manager",
          style: TextStyle(
            color: AppColors.secondaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppColors.primaryColor,
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: AppColors.secondaryColor,),
            onPressed: taskVM == null
                ? null
                : () {
              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  backgroundColor: AppColors.secondaryColor,
                  title: const Text("Add Task Title",style: TextStyle(color: AppColors.primaryColor),),
                  content: TextField(
                      controller: controller,
                    decoration: const InputDecoration(
                      hintText: "Enter task details",
                      hintStyle: TextStyle(color: Colors.white),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: AppColors.primaryColor),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: AppColors.primaryColor, width: 2),
                      ),
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        final taskTitle = controller.text.trim();
                        if (taskTitle.isEmpty) {
                          Utils().toastMessage("Task title cannot be empty");
                          return;
                        }
                        taskVM.addTask(taskTitle);
                        controller.clear();
                        Navigator.pop(context);
                      },
                      child: const Text(
                        "Add",
                        style: TextStyle(color: AppColors.primaryColor),
                      ),
                    )
                  ],
                ),
              );
            },
          )
        ],
      ),
      body: taskVM == null
          ? const Center(child: Text("Please login to see your tasks"))
          : taskVM.isLoading
          ? const Center(child: Loader()) // <-- loader
          : taskVM.tasks.isEmpty
          ? const Center(
        child: Text("No tasks available", style: TextStyle(fontSize: 20)),
      )
          : Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: ListView.separated(
          itemCount: taskVM.tasks.length,
          itemBuilder: (context, index) {
            final task = taskVM.tasks[index];
            return TaskTile(
              task: task,
              onToggleCompletion: () => taskVM.toggleCompletion(task.id),
              onDelete: () => taskVM.deleteTask(task.id),
              onUpdateDetails: (details) =>
                  taskVM.updateTaskDetails(task.id, details),
            );
          },
          separatorBuilder: (_, __) => const SizedBox(height: 10),
        ),
      ),
    );
  }
}

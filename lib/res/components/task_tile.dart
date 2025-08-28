import 'package:education_app/res/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../features/task/model/task_model.dart';
import '../../utils/utils.dart';

class TaskTile extends StatefulWidget {
  final Task task;
  final VoidCallback? onToggleCompletion;
  final VoidCallback? onDelete;
  final Function(String)? onUpdateDetails;

  const TaskTile({
    super.key,
    required this.task,
    this.onToggleCompletion,
    this.onDelete,
    this.onUpdateDetails,
  });

  @override
  State<TaskTile> createState() => _TaskTileState();
}

class _TaskTileState extends State<TaskTile> {
  final TextEditingController _detailsController = TextEditingController();

  @override
  void dispose() {
    _detailsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 4.h),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.r),
      ),
      tileColor: AppColors.primaryColor,
      subtitle: widget.task.details.trim().isNotEmpty
          ? Text(
        Utils.getPreviewText(widget.task.details),
        style: TextStyle(color: AppColors.secondaryColor),
      )
          : null,
      leading: Checkbox(
        checkColor: AppColors.primaryColor,
        fillColor: MaterialStateProperty.resolveWith<Color>((states) {
          if (states.contains(MaterialState.selected)) {
            return AppColors.secondaryColor; // when checked
          }
          return Colors.transparent; // when unchecked
        }),
        value: widget.task.isCompleted,
        onChanged: (_) {
          if (widget.onToggleCompletion != null) widget.onToggleCompletion!();
        },
      ),
      title: Text(
        widget.task.title,
        style: TextStyle(
          decoration: widget.task.isCompleted ? TextDecoration.lineThrough : null,
          color: Colors.white,
          decorationColor: AppColors.primaryColor,
          decorationThickness: 4
        ),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Edit button
          IconButton(
            icon: const Icon(Icons.edit,color: AppColors.secondaryColor,),
            onPressed: () {
              _detailsController.text = widget.task.details;
              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  backgroundColor: AppColors.secondaryColor,
                  title: const Text("Edit Task Details",style: TextStyle(color: AppColors.primaryColor),),
                  content: TextField(
                    cursorColor: AppColors.primaryColor,
                    controller: _detailsController,
                    maxLines: 5,
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
                        final newDetails = _detailsController.text.trim();
                        if (widget.onUpdateDetails != null) {
                          widget.onUpdateDetails!(newDetails);
                        }
                        Navigator.pop(context);
                        Utils().toastMessage("Task details updated");
                      },
                      child: const Text(
                        "Save",
                        style: TextStyle(color: AppColors.primaryColor),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          // Delete button
          IconButton(
            icon: const Icon(Icons.delete,color: AppColors.secondaryColor,),
            onPressed: () {
              if (widget.onDelete != null) widget.onDelete!();
            },
          ),
        ],
      ),
    );
  }
}

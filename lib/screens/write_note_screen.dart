import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:note_app/boxes/boxes.dart';
import 'package:note_app/models/notes_model.dart';

class WriteNoteScreen extends StatefulWidget {
  final bool isUpdating;
  final NotesModel? note;
  const WriteNoteScreen({super.key, this.isUpdating = false, this.note});

  @override
  State<WriteNoteScreen> createState() => _WriteNoteScreenState();
}

class _WriteNoteScreenState extends State<WriteNoteScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController detailsController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey();
  @override
  void initState() {
    super.initState();
    if (widget.isUpdating) {
      titleController.text = widget.note?.title ?? '';
      detailsController.text = widget.note?.details ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        titleSpacing: -5,
        title:
            Text(widget.isUpdating ? "Edit Note" : "New Note", style: const TextStyle(color: Colors.white)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              TextFormField(
                controller: titleController,
                validator: validator,
                decoration: const InputDecoration(hintText: "Title"),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: detailsController,
                validator: validator,
                maxLines: null,
                keyboardType: TextInputType.multiline,
                decoration: const InputDecoration(hintText: "Notes..."),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16).copyWith(top: 0),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 45),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                backgroundColor: theme.primaryColor,
                foregroundColor: Colors.white),
            onPressed: widget.isUpdating ? updateNote : addNewNote,
            child: const Text("Save"),
          ),
        ),
      ),
    );
  }

  void addNewNote() {
    if (formKey.currentState!.validate()) {
      final note = NotesModel(title: titleController.text, details: detailsController.text);
      final box = Boxes.getData();
      box.add(note);
      //note.save();
      //titleController.clear();
      //detailsController.clear();
      Get.back();
    }
  }

  void updateNote() {
    // final note = NotesModel(title: titleController.text, details: detailsController.text);
    // final box = Boxes.getData();
    // box.add(note);
    // note.save();
    // titleController.clear();
    // detailsController.clear();
    widget.note?.title = titleController.text;
    widget.note?.details = detailsController.text;
    widget.note?.save();
    Get.back();
  }

  String? validator(String? value) {
    if (value?.isEmpty ?? true) {
      return "Enter Text";
    }
    return null;
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:note_app/boxes/boxes.dart';
import 'package:note_app/screens/write_note_screen.dart';

import '../models/notes_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 2,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("assets/images/appLogo.png", height: 28),
            const SizedBox(width: 8),
            const Text("FluttNote", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
          ],
        ),
      ),
      body: ValueListenableBuilder<Box<NotesModel>>(
        valueListenable: Boxes.getData().listenable(),
        builder: (context, box, _) {
          var notes = box.values.toList().reversed.toList().cast<NotesModel>();
          return ListView.separated(
            padding: const EdgeInsets.all(12),
            itemCount: box.length,
            separatorBuilder: (c, i) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              var note = notes[index];
              return Slidable(
                startActionPane: startActionPane(theme: theme, note: note),
                endActionPane: endActionPane(note: note),
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () => Get.to(() => WriteNoteScreen(isUpdating: true, note: note)),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: theme.primaryColor.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          note.title.toString(),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(height: 5),
                        Text(note.details.toString(), maxLines: 3, overflow: TextOverflow.ellipsis),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
      // Column(
      //   children: [
      //     TextButton(
      //         onPressed: () async {
      //           Box box = await Hive.openBox("Demo");
      //           box.put("name", "Zunayed");
      //           setState(() {});
      //         },
      //         child: const Text("Create New data")),
      //     TextButton(
      //         onPressed: () async {
      //           Box box = await Hive.openBox("Demo");
      //           box.delete("name");
      //           setState(() {});
      //         },
      //         child: const Text("Delete data")),
      //   ],
      // ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.to(() => const WriteNoteScreen()),
        child: const Icon(CupertinoIcons.add_circled),
      ),
    );
  }

  ActionPane endActionPane({required NotesModel note}) {
    return ActionPane(
      motion: const ScrollMotion(),
      children: [
        SlidableAction(
          onPressed: (context) => deleteNote(note),
          backgroundColor: Colors.red,
          foregroundColor: Colors.white,
          icon: Icons.delete,
        )
      ],
    );
  }

  ActionPane startActionPane({required ThemeData theme, required NotesModel note}) {
    return ActionPane(
      motion: const ScrollMotion(),
      children: [
        SlidableAction(
          onPressed: (context) => Get.to(() => WriteNoteScreen(isUpdating: true, note: note)),
          backgroundColor: theme.primaryColor,
          foregroundColor: Colors.white,
          icon: Icons.edit,
        )
      ],
    );
  }

  void deleteNote(NotesModel note) {
    note.delete();
  }
}

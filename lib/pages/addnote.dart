import 'package:app7/Database/database.dart';
import 'package:app7/Database/globals.dart';

import 'package:flutter/material.dart';

class Addnote extends StatefulWidget {
  Addnote({super.key, required this.userid});
  int userid;

  @override
  State<Addnote> createState() => _AddnoteState();
}

class _AddnoteState extends State<Addnote> {
  TextEditingController titleController = TextEditingController();
  TextEditingController noteController = TextEditingController();
  DateTime dateTime = DateTime.now();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  SqlDb myDb = SqlDb();

  List<Color> colors = [
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.pink,
    Colors.white,
    Colors.orange,
    const Color(0xff151515),
  ];

  Color selectedColor = const Color(0xff151515);

  Color getTextColor(Color backgroundColor) {
    return backgroundColor.computeLuminance() > 0.5
        ? Colors.black
        : Colors.white;
  }

  Future<void> saveNote() async {
    await myDb.insert(
      'INSERT INTO "NOTES" ("TITLE", "NOTE", "COLOR", "USER_ID") VALUES (?, ?, ?, ?)',
      [
        titleController.text,
        noteController.text,
        selectedColor.value.toString(),
        widget.userid
      ],
    );
  }

  void addnote() {
    notes.add({
      "TITLE": titleController.text,
      "NOTE": noteController.text,
      "COLOR": selectedColor.value.toString(),
      "USER_ID": widget.userid,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: selectedColor,
      key: scaffoldKey,
      bottomSheet: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        height: 50,
        decoration: const BoxDecoration(
          color: Color(0xff2b2b2e),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            InkWell(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  builder: (context) {
                    return Container(
                      padding: const EdgeInsets.all(10),
                      height: 250,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: List.generate(
                                  colors.length,
                                  (index) => GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        selectedColor = colors[index];
                                      });
                                      Navigator.pop(
                                          context); // Close the bottom sheet
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 4.0),
                                      child: CircleAvatar(
                                        radius: 15,
                                        backgroundColor: colors[index],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const ListTile(
                            leading: Icon(Icons.mic_none_outlined),
                            title: Text("Recording"),
                          ),
                          const ListTile(
                            leading: Icon(Icons.photo),
                            title: Text("Add image"),
                          ),
                          const ListTile(
                            leading: Icon(Icons.camera_alt_outlined),
                            title: Text("Take a photo"),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
              child: const Icon(Icons.add_circle_outline_rounded),
            ),
            Text("${dateTime.toLocal()}"
                .split(' ')[0]), // Displays the date in a cleaner format
            InkWell(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  builder: (context) {
                    return Container(
                      padding: const EdgeInsets.all(20),
                      child: const Text("More Options"),
                    );
                  },
                );
              },
              child: const Icon(Icons.more_horiz_outlined),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: InkWell(
              onTap: () {
                // Action for pinning the note
              },
              child: const Icon(Icons.push_pin_outlined),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: InkWell(
              onTap: () {
                // Action for archiving the note
              },
              child: const Icon(Icons.archive_outlined),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: InkWell(
              onTap: () async {
                await saveNote();
                setState(() {
                  addnote();
                });
                Navigator.pop(context); // Close the Addnote screen after saving
              },
              child: const Icon(Icons.done_rounded),
            ),
          ),
        ],
      ),
      body: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: MediaQuery.of(context).size.height,
        ),
        child: IntrinsicHeight(
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: titleController,
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: getTextColor(selectedColor),
                    ),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Title",
                      hintStyle: TextStyle(
                        fontSize: 25,
                        color: getTextColor(selectedColor).withOpacity(0.5),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: noteController,
                    minLines: 1,
                    maxLines: null,
                    autofocus: true,
                    style: TextStyle(
                      fontSize: 18,
                      color: getTextColor(selectedColor),
                    ),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Note",
                      hintStyle: TextStyle(
                        color: getTextColor(selectedColor).withOpacity(0.5),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:app7/Database/globals.dart';
import 'package:app7/widgets/drawer.dart';
import 'package:flutter/material.dart';
import 'package:app7/Database/database.dart';
import 'package:app7/widgets/addbutton.dart';
import 'package:app7/widgets/bottomnavigationbar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.user_id});
  final int user_id;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final SqlDb _myDb = SqlDb();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final FocusNode _focusNode = FocusNode();

  Future<void> _getData(int userId) async {
    List response = await _myDb.getdata('''
      SELECT * 
      FROM "NOTES"
      WHERE "USER_ID" = ?
    ''', [userId]);

    setState(() {
      notes = response;
    });
  }

  Future<void> _deleteNoteFromDb(int noteId) async {
    await _myDb.delete('''
      DELETE FROM "NOTES"
      WHERE "ID" = ?
    ''', [noteId]);
  }

  @override
  void initState() {
    super.initState();
    _getData(widget.user_id);
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      floatingActionButton: AddButton(userid: widget.user_id),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      bottomNavigationBar: const Bottomnavigationbar(),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: null,
        title: const Text(
          "Notes",
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
        ),
        toolbarHeight: 80,
      ),
      drawer: const MyDrawer(),
      body: GestureDetector(
        onTap: () => _focusNode.unfocus(),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              SearchBar(
                leading: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    onTap: () {
                      _scaffoldKey.currentState!.openDrawer();
                    },
                    child: const Icon(
                      Icons.filter_list,
                      size: 30,
                    ),
                  ),
                ),
                hintText: "Search your notes",
                hintStyle: const WidgetStatePropertyAll(
                    TextStyle(color: Colors.grey, fontSize: 18)),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: notes.length,
                  itemBuilder: (context, i) {
                    final note = notes[i];
                    final int noteId = note['ID'];
                    final Color noteColor = Color(int.parse(note['COLOR']));
                    final bool isDarkBackground =
                        noteColor.computeLuminance() < 0.5;
                    return Dismissible(
                      key: Key(noteId.toString()), // Use a unique key
                      onDismissed: (direction) async {
                        // Delete from the database
                        await _deleteNoteFromDb(noteId);

                        // Remove from the list
                        setState(() {
                          notes.removeAt(i);
                        });

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("${note['TITLE']} dismissed")),
                        );
                      },
                      background: Container(
                        color: Colors.red,
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: const Icon(Icons.delete, color: Colors.white),
                      ),
                      child: Material(
                        borderRadius: BorderRadius.circular(20),
                        elevation: 6,
                        child: Container(
                          padding: const EdgeInsets.all(16.0),
                          decoration: BoxDecoration(
                            color: noteColor,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${note["TITLE"]}",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: isDarkBackground
                                      ? Colors.white
                                      : Colors.black,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Expanded(
                                child: Text(
                                  "${note["NOTE"]}",
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 4,
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: isDarkBackground
                                        ? Colors.white70
                                        : Colors.grey[800],
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.bottomRight,
                                child: Text(
                                  "${note["DATE"]}",
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: isDarkBackground
                                        ? Colors.white70
                                        : Colors.grey[800],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:app7/pages/addnote.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddButton extends StatefulWidget {
  AddButton({super.key, required this.userid});
  int userid;

  @override
  State<AddButton> createState() => _AddButtonState();
}

class _AddButtonState extends State<AddButton> {
  Future<void> saveuserid(int userid) async {
    try {
      userid = -1;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      bool result = await prefs.setInt("userid", userid);
      if (!result) {
        print("Failed to save userid");
      }
    } catch (e) {
      print("Error saving userid: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: FloatingActionButton(
        onPressed: () {
          saveuserid(widget.userid);
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Addnote(
                      userid: widget.userid,
                    )),
          );
        },
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
        backgroundColor: const Color(0xff4e33ff),
        child: const Icon(
          Icons.add,
          size: 30,
        ),
      ),
    );
  }
}

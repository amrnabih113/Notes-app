import 'package:app7/pages/addnote.dart';
import 'package:flutter/material.dart';

class AddButton extends StatefulWidget {
  const AddButton({super.key, required this.userid, required this.onNoteAdded});
  final int userid;
  final Function(Map<String, dynamic>) onNoteAdded;

  @override
  State<AddButton> createState() => _AddButtonState();
}

class _AddButtonState extends State<AddButton> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: FloatingActionButton(
        onPressed: ()  {
           Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Addnote(
                userid: widget.userid,
                onNoteAdded: widget.onNoteAdded, // Pass the callback function
              ),
            ),
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

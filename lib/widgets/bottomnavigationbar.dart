
import 'package:flutter/material.dart';

class Bottomnavigationbar extends StatefulWidget {
  const Bottomnavigationbar({super.key});

  @override
  State<Bottomnavigationbar> createState() => _BottomnavigationbarState();
}

class _BottomnavigationbarState extends State<Bottomnavigationbar> {
  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 0,
        height: 70,
        surfaceTintColor: const Color.fromARGB(168, 0, 0, 0),
        color:
             const Color(0xff2b2b2e)
           ,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: InkWell(
                onTap: () {},
                child: const Icon(
                  Icons.checklist_rtl_rounded,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: InkWell(onTap: () {}, child: const Icon(Icons.mic_none)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: InkWell(
                  onTap: () {}, child: const Icon(Icons.camera_alt_outlined)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: InkWell(
                  onTap: () {}, child: const Icon(Icons.brush_outlined)),
            ),
          ],
        ),
      );
  }
}
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer({super.key});

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          InkWell(
            onTap: () {},
            child: const ListTile(
              title: Text(
                "Notes",
                style: TextStyle(fontSize: 18),
              ),
              leading: Icon(
                Icons.lightbulb,
                size: 23,
              ),
            ),
          ),
          InkWell(
            onTap: () {},
            child: const ListTile(
              title: Text(
                "Archive",
                style: TextStyle(fontSize: 18),
              ),
              leading: Icon(
                Icons.archive_outlined,
                size: 23,
              ),
            ),
          ),
          InkWell(
            onTap: () {},
            child: const ListTile(
              title: Text("Trash", style: TextStyle(fontSize: 18)),
              leading: Icon(
                Icons.delete,
                size: 23,
              ),
            ),
          ),
          InkWell(
            onTap: () {},
            child: const ListTile(
              title: Text("Settings", style: TextStyle(fontSize: 18)),
              leading: Icon(
                Icons.settings,
                size: 23,
              ),
            ),
          ),
          InkWell(
            onTap: () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              bool result = await prefs.setInt("userid", -1);
              print("log out userid = ${prefs.getInt("userid")}");
              if (!result) {
                print("Failed to save userid");
              }
              Navigator.of(context).pushNamed("loginpage");
            },
            child: const ListTile(
              title: Text(
                "Log Out",
                style: TextStyle(fontSize: 18),
              ),
              leading: Icon(
                Icons.exit_to_app,
                size: 23,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

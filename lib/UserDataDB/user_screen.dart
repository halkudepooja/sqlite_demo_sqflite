import 'package:flutter/material.dart';
import 'package:sqlite_demo/UserDataDB/user_db.dart';

class UserList_screen extends StatefulWidget {
  const UserList_screen({super.key});

  @override
  State<UserList_screen> createState() => _UserList_screenState();
}

class _UserList_screenState extends State<UserList_screen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  List<Map<String, dynamic>> usersList = [];

  @override
  void initState() {
    super.initState();
    loadUserData();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("UserList")),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              TextField(
                decoration: InputDecoration(label: Text("Name")),
                controller: nameController,
              ),
              SizedBox(height: 20),
              TextField(
                decoration: InputDecoration(label: Text("Age")),
                controller: ageController,
              ),
              SizedBox(height: 20),
              TextField(
                decoration: InputDecoration(label: Text("Email Id")),
                controller: emailController,
              ),
                          SizedBox(height: 20),
          
              ElevatedButton(
                onPressed: _addUser,
                child: Text('Add User'),
              ),
              SizedBox(height: 20),
              // Display users
              Expanded(
                child: ListView.builder(
                  itemCount: usersList.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(usersList[index]['name']),
                      subtitle: Column(crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Age: ${usersList[index]['age']}'
                          ),
                          Text('Email: ${usersList[index]['email']}'
                          ),
                        ],
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
  
  Future<void> loadUserData() async {
     final users = await DBHelperUser.getUsers();
    setState(() {
      usersList = users;
    });
  }


  // Add a new user
  _addUser() async {
    if (nameController.text.isNotEmpty && ageController.text.isNotEmpty && emailController.text.isNotEmpty) {
      await DBHelperUser.inserUsers(nameController.text, int.parse(ageController.text), emailController.text);
      nameController.clear();
      ageController.clear();
      emailController.clear();
      loadUserData();
    }
  }
}

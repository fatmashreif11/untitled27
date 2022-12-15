import 'dart:async';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'info_model.dart';
import 'package:untitled27/preferences_helper.dart';

class HomeScreen extends StatefulWidget {

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<InfoModel> data = [];
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  get id => null;

  Future<List<InfoModel>> getData() async {
    data = await DatabaseHelper.instance.readALLInfo();
    print('DATA:${data.length}');
    return data;
  }
  Future<void> editInfo(id,name,phone,email) async{
    InfoModel infoModel = InfoModel();
    final data = await DatabaseHelper.editInfo(infoModel);
    return data;
  }
  void deleteInfo(int id ) async{
    InfoModel infoModel = InfoModel();
    final data = await DatabaseHelper.deleteInfo(id);
    return data;
  }


  @override
  void initState()  {
    super.initState();
    getData();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (preferencesHelper.instance.getIsOpened() == false) {
        welcomeAlert();
      }
    });
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          topBar(),
          const SizedBox(
            height: 10,
          ),
          FutureBuilder(
            future: getData(),
            builder: (context, snapshot) => snapshot.hasData
                ? dataList(data)
                : snapshot.hasError
                    ? const Text('Sorry Something went wrong')
                    : const CircularProgressIndicator(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showAlert();
        },
        backgroundColor: Colors.indigo,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget topBar() => Container(
        decoration: const BoxDecoration(
          color: Colors.indigo,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(30),
            bottomRight: Radius.circular(30),
          ),
        ),
        height: 150,
        width: double.infinity,
        child: SafeArea(
          child: Column(
            children: const [
              SizedBox(height: 10,),
              Text(
                'Welcome In Note App',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10)
            ],
          ),
        ),
      );

  Widget dataList(List<InfoModel> noteList) => noteList.isEmpty
      ? const Text(
          'No Data Found',
          style: TextStyle(fontSize: 18),
        )
      : ListView.builder(
          itemCount: noteList.length,
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          itemBuilder: (context, index) => ListTile(
              title: Text(
                'Name:${noteList[index].name}',

              ),
              subtitle: Text('Email : ${noteList[index].email}'),
              leading: CircleAvatar(
                radius: 40,
                backgroundColor: Colors.indigo[400],
                child: Text(
                  (noteList[index].name ?? '').substring(0, 2).toUpperCase(),
                  style: const TextStyle(
                    color: Colors.indigo,
                    fontWeight: FontWeight.bold,
                  ),
                ),

              ),
            trailing: Wrap(
              children: [
                IconButton(
                    onPressed: (){
                      editInfo(id, nameController.text, phoneController.text,emailController.text);
                    },
                    icon: const Icon(Icons.edit,
                    color:  Colors.indigo,
                    ),),
                IconButton(
                  onPressed: (){},
                  icon: const Icon(Icons.delete,
                  color: Colors.red,
                  ),

                )
              ],
            ),
          )

  );

  void showAlert() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'Add User',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Colors.indigo,
          ),
        ),
        content: Wrap(
          children: [
            Column(
              children: [
                TextFormField(
                  controller: nameController,
                  decoration: fieldDecoration('Name'),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: phoneController,
                  decoration: fieldDecoration('Phone'),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: emailController,
                  decoration: fieldDecoration('Email'),
                ),
              ],
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              DatabaseHelper.instance
                  .insertInfo(
                    InfoModel(
                      name: nameController.text,
                      phone: phoneController.text,
                      email: emailController.text,
                    ),
                  )
                  .then((value) => {
                        getData(),
                        setState(() {}),
                      })
                  .whenComplete(() {
                Navigator.pop(context);
                nameController.clear();
                phoneController.clear();
                emailController.clear();
              });
            },
            style: ElevatedButton.styleFrom(
              primary: Colors.indigo,
            ),
            child: const Text('Save'),
          )
        ],
      ),
    );
  }

  void welcomeAlert() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text(
          'Welcome in Note App',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Colors.indigo,
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              preferencesHelper.instance.setIsOpened(true);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              primary: Colors.indigo,
            ),
            child: const Text('Confirm'),
          )
        ],
      ),
    );
  }

  InputDecoration fieldDecoration(String hint) => InputDecoration(
        hintText: hint,
        border: const OutlineInputBorder(),
      );
}

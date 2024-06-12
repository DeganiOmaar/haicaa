import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:haica/Screens/adduser.dart';
import 'package:haica/Screens/updateuser.dart';
import 'package:haica/allscreens.dart';
import 'package:haica/shared/constant.dart';
import 'package:haica/shared/employecard.dart';

class Employee extends StatefulWidget {
  const Employee({super.key});

  @override
  State<Employee> createState() => _EmployeeState();
}

class _EmployeeState extends State<Employee> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        elevation: 1,
        centerTitle: true,
        title: const Text(
          "Liste d'utilisateurs",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const AddUser()));
              },
              icon: const Icon(Icons.add_circle_outline))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream:
                    FirebaseFirestore.instance.collection('users').snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return const Text('Something went wrong');
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: blackColor,
                      ),
                    );
                  }

                  return ListView(
                    children:
                        snapshot.data!.docs.map((DocumentSnapshot document) {
                      Map<String, dynamic> data =
                          document.data()! as Map<String, dynamic>;
                      return EmployeeCard(
                          nom: data['fullname'],
                          email: data['email'],
                          adress: data['adress'],
                          role: data['role'],
                          onPressedModifier: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => UpdateUser(
                                        userId: data['uid'],
                                        fullname: data['fullname'],
                                        matricule: data['matricule'],
                                        telephone: data['telephone'],
                                        anniversaire: data['anniversaire'],
                                        cin: data['cin'])));
                          },
                          onPressedSupprimer: () async {
                            await FirebaseFirestore.instance
                                .collection("users")
                                .doc(data['uid'])
                                .delete();
                            if (!mounted) return;
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const UserScreen()));
                          });
                    }).toList(),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    ));
  }
}

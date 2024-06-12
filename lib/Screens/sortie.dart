import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:haica/Screens/chefsortie.dart';
import 'package:haica/shared/constant.dart';
import 'package:haica/shared/showsnackbar.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class Sortie extends StatefulWidget {
  const Sortie({super.key});

  @override
  State<Sortie> createState() => _SortieState();
}

class _SortieState extends State<Sortie> {
  Map userData = {};
  bool isfinding = true;

  getData() async {
    setState(() {
      isfinding = true;
    });
    try {
      DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
          .instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();

      userData = snapshot.data()!;
    } catch (e) {
      if (!mounted) return;
      showSnackBar(context, e.toString());
    }
    setState(() {
      isfinding = false;
    });
  }

  @override
  void initState() {
    super.initState();
    // getDataFromDB();
    getData();
  }

  addSortieEmployee() async {
    String newId = const Uuid().v1();
    try {
      FirebaseFirestore.instance.collection('sortieEmployee').doc(newId).set({
        // 'status': 'pending',
        'role': userData['role'],
        'sortieId': newId,
        'uid': FirebaseAuth.instance.currentUser!.uid,
        'nom': userData['fullname'],
        'sortie': sortieController.text,
        'entre': entreController.text,
        'date': DateTime.now(),
        'status': 'pending',
      });
    } catch (e) {}
  }

  addSortieChef() async {
    String newId = const Uuid().v1();
    try {
      FirebaseFirestore.instance.collection('sortieChef').doc(newId).set({
        // 'status': 'pending',
        'role': userData['role'],
        'sortieId': newId,
        'uid': FirebaseAuth.instance.currentUser!.uid,
        'nom': userData['fullname'],
        'sortie': sortieController.text,
        'entre': entreController.text,
        'date': DateTime.now(),
        'status': 'pending',
      });
    } catch (e) {}
  }

  TextEditingController sortieController = TextEditingController();
  TextEditingController entreController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return isfinding
        ? const Center(
            child: Scaffold(
              body: Center(
                child: CircularProgressIndicator(
                  color: blackColor,
                ),
              ),
            ),
          )
        : SafeArea(
            child: Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              elevation: 1,
              centerTitle: true,
              title: const Text(
                "Autorisation de sortie",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                    "Heure de sortie",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: blackColor, width: 0.6),
                        borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 9.0),
                      child: TextFormField(
                        controller: sortieController,
                        keyboardType: TextInputType.text,
                        style: const TextStyle(color: blackColor),
                        decoration: const InputDecoration(
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            // hintText: "Adresse de résidance pendant le congee",
                            hintStyle:
                                TextStyle(color: greyColor, fontSize: 17)),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                    "Heure de rentrée",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: blackColor, width: 0.6),
                        borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 9.0),
                      child: TextFormField(
                        controller: entreController,
                        keyboardType: TextInputType.text,
                        style: const TextStyle(color: blackColor),
                        decoration: const InputDecoration(
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            // hintText: "Adresse de résidance pendant le congee",
                            hintStyle:
                                TextStyle(color: greyColor, fontSize: 17)),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.blue)),
                          onPressed: () async {
                            userData['role'] == 'Employe'
                                ? await addSortieEmployee()
                                : addSortieChef();
                            setState(() {
                              sortieController.clear();
                              entreController.clear();
                            });
                            // Action to perform when the button is pressed
                          },
                          child: const Text(
                            'Enregistrer',
                            style: TextStyle(color: whiteColor),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      const Text(
                        "Liste de sorties",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 17),
                      ),
                      const Spacer(),
                      userData['role'] == 'Employe'
                          ? Container()
                          : InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const ChefSortie()));
                              },
                              child: const Text(
                                'Votre Liste',
                                style: TextStyle(
                                    color: Colors.indigo,
                                    decoration: TextDecoration.underline),
                              )),
                      const SizedBox(
                        width: 20,
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Expanded(
                    child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('sortieEmployee')
                          .snapshots(),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasError) {
                          return const Text('Something went wrong');
                        }

                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(
                              color: blackColor,
                            ),
                          );
                        }

                        return ListView(
                          children: snapshot.data!.docs
                              .map((DocumentSnapshot document) {
                            Map<String, dynamic> data =
                                document.data()! as Map<String, dynamic>;
                            return Container(
                              margin: const EdgeInsets.only(bottom: 10),
                              decoration: BoxDecoration(
                                  border: Border.all(color: blackColor),
                                  borderRadius: BorderRadius.circular(12)),
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Row(
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                          data['nom'],
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        Text(data['sortie']),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        Text(data['entre']),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                          DateFormat('MMMM d,' 'y')
                                              .format(data['date'].toDate()),
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                      ],
                                    ),
                                    const Spacer(),
                                    data['status'] == 'pending'
                                        ? Column(
                                            children: [
                                              ElevatedButton(
                                                style: ButtonStyle(
                                                    backgroundColor:
                                                        MaterialStateProperty
                                                            .all(Colors.green)),
                                                onPressed: () async {
                                                  userData['role'] == 'Employe'
                                                      ? null
                                                      : await FirebaseFirestore
                                                          .instance
                                                          .collection(
                                                              'sortieEmployee')
                                                          .doc(data['sortieId'])
                                                          .update({
                                                          'status': 'accepter',
                                                        });
                                                },
                                                child: Text(
                                                  userData['role'] == 'Employe'
                                                      ? 'Modifier'
                                                      : 'Accepter',
                                                  style: const TextStyle(
                                                      color: whiteColor),
                                                ),
                                              ),
                                              ElevatedButton(
                                                style: ButtonStyle(
                                                    backgroundColor:
                                                        MaterialStateProperty
                                                            .all(Colors.red)),
                                                onPressed: () async {
                                                  userData['role'] == 'Employe'
                                                      ? await FirebaseFirestore
                                                          .instance
                                                          .collection(
                                                              'sortieEmployee')
                                                          .doc(data['sortieId'])
                                                          .delete()
                                                      : await FirebaseFirestore
                                                          .instance
                                                          .collection(
                                                              'sortieEmployee')
                                                          .doc(data['sortieId'])
                                                          .update({
                                                          'status': 'refuser',
                                                        });
                                                },
                                                child: Text(
                                                  userData['role'] == 'Employe'
                                                      ? 'Supprmer'
                                                      : 'Refuser',
                                                  style: const TextStyle(
                                                      color: whiteColor),
                                                ),
                                              ),
                                            ],
                                          )
                                        : data['status'] == 'accepter'
                                            ? const Text(
                                                "Sotie accepté",
                                                style: TextStyle(
                                                    color: Colors.green),
                                              )
                                            : const Text(
                                                "Sortie refuse",
                                                style: TextStyle(
                                                    color: Colors.red),
                                              )
                                  ],
                                ),
                              ),
                            );
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

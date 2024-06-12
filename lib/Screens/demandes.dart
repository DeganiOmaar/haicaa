import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:haica/shared/constant.dart';
import 'package:haica/shared/showsnackbar.dart';
import 'package:intl/intl.dart';

class Demandes extends StatefulWidget {
  const Demandes({super.key});

  @override
  State<Demandes> createState() => _DemandesState();
}

class _DemandesState extends State<Demandes> {
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

    getData();
  }

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
                "Les Demandes des Chefs",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  Expanded(
                    child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('congeChef')
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
                                        Text(
                                          DateFormat('MMMM d,' 'y').format(
                                            data['debut'].toDate(),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                          DateFormat('MMMM d,' 'y').format(
                                            data['fin'].toDate(),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        Text(data['remplacent']),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        Text(data['type']),
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
                                                  await FirebaseFirestore
                                                      .instance
                                                      .collection('congeChef')
                                                      .doc(data['congeId'])
                                                      .update({
                                                    'status': 'accepter',
                                                  });
                                                },
                                                child: const Text(
                                                  'Accepter',
                                                  style: TextStyle(
                                                      color: whiteColor),
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              ElevatedButton(
                                                style: ButtonStyle(
                                                    backgroundColor:
                                                        MaterialStateProperty
                                                            .all(Colors.red)),
                                                onPressed: () async {
                                                  await FirebaseFirestore
                                                      .instance
                                                      .collection('congeChef')
                                                      .doc(data['congeId'])
                                                      .update({
                                                    'status': 'refuser',
                                                  });
                                                },
                                                child: const Text(
                                                  'Refuser',
                                                  style: TextStyle(
                                                      color: whiteColor),
                                                ),
                                              ),
                                            ],
                                          )
                                        : data['status'] == 'accepter'
                                            ? const Text(
                                                "Congé accepté",
                                                style: TextStyle(
                                                    color: Colors.green),
                                              )
                                            : const Text(
                                                "Congé refuse",
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

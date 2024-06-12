import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:haica/shared/constant.dart';
import 'package:intl/intl.dart';

class ListeSortie extends StatefulWidget {
  const ListeSortie({super.key});

  @override
  State<ListeSortie> createState() => _ListeSortieState();
}

class _ListeSortieState extends State<ListeSortie> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        elevation: 1,
        centerTitle: true,
        title: const Text(
          "Liste de sortie de Chefs",
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
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('sortieChef')
                    .snapshots(),
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
                                crossAxisAlignment: CrossAxisAlignment.start,
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
                                                  MaterialStateProperty.all(
                                                      Colors.green)),
                                          onPressed: () async {
                                            await FirebaseFirestore.instance
                                                .collection('sortieChef')
                                                .doc(data['sortieId'])
                                                .update({
                                              'status': 'accepter',
                                            });
                                          },
                                          child: const Text(
                                            'Accepter',
                                            style: TextStyle(color: whiteColor),
                                          ),
                                        ),
                                        ElevatedButton(
                                          style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStateProperty.all(
                                                      Colors.red)),
                                          onPressed: () async {
                                            await FirebaseFirestore.instance
                                                .collection('sortieChef')
                                                .doc(data['sortieId'])
                                                .update({
                                              'status': 'refuser',
                                            });
                                          },
                                          child: const Text(
                                            'Refuser',
                                            style: TextStyle(color: whiteColor),
                                          ),
                                        ),
                                      ],
                                    )
                                  : data['status'] == 'accepter'
                                      ? const Text(
                                          "Sortie accepté",
                                          style: TextStyle(color: Colors.green),
                                        )
                                      : const Text(
                                          "Sortie refuse",
                                          style: TextStyle(color: Colors.red),
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

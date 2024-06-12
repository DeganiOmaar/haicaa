import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:haica/allscreens.dart';
import 'package:haica/registerScreens/login.dart';
import 'package:haica/shared/showsnackbar.dart';
import 'package:uuid/uuid.dart';

import '../shared/constant.dart';

class Congee extends StatefulWidget {
  const Congee({super.key});

  @override
  State<Congee> createState() => _CongeeState();
}

class _CongeeState extends State<Congee> {
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

  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now();
  bool isPicking = false;
  bool isPicking2 = false;
  TextEditingController typeController = TextEditingController();
  TextEditingController telephoneController = TextEditingController();
  TextEditingController adressController = TextEditingController();
  TextEditingController remplacentController = TextEditingController();
  TextEditingController nomController = TextEditingController();

  addCongeEmployee() async {
    String newId = const Uuid().v1();
    try {
      FirebaseFirestore.instance.collection('congeEmployee').doc(newId).set({
        'status': 'pending',
        'congeId': newId,
        'uid': FirebaseAuth.instance.currentUser!.uid,
        'nom' : nomController.text,
        'type': typeController.text,
        'telephone': telephoneController.text,
        'adress': adressController.text,
        'debut': startDate,
        'fin': endDate,
        'remplacent': remplacentController.text,
      });
    } catch (e) {}
  }
  addCongeChef() async {
    String newId = const Uuid().v1();
    try {
      FirebaseFirestore.instance.collection('congeChef').doc(newId).set({
        'status': 'pending',
        'congeId': newId,
        'uid': FirebaseAuth.instance.currentUser!.uid,
         'nom' : nomController.text,
        'type': typeController.text,
        'telephone': telephoneController.text,
        'adress': adressController.text,
        'debut': startDate,
        'fin': endDate,
        'remplacent': remplacentController.text,
      });
    } catch (e) {}
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
            resizeToAvoidBottomInset: true,
            appBar: AppBar(
              actions: [
                GestureDetector(
                  onTap: ()async{
                     await FirebaseAuth.instance.signOut();
                                        if (!mounted) return;
                                        Navigator.of(context)
                                            .pushAndRemoveUntil(
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        const Login()),
                                                (route) => false);
                  },
                  child: const Icon(Icons.logout))
              ],
              elevation: 1,
              centerTitle: true,
              title: const Text(
                "Ajouter Un congé",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                     const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      "Nom",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
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
                          controller: nomController,
                          keyboardType: TextInputType.text,
                          style: const TextStyle(color: blackColor),
                          decoration: const InputDecoration(
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              // hintText: "Telephone",
                              hintStyle:
                                  TextStyle(color: greyColor, fontSize: 17)),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      "Type de conge",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
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
                          controller: typeController,
                          keyboardType: TextInputType.text,
                          style: const TextStyle(color: blackColor),
                          decoration: const InputDecoration(
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              // hintText: "Telephone",
                              hintStyle:
                                  TextStyle(color: greyColor, fontSize: 17)),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      "Téléphone",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
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
                          controller: telephoneController,
                          keyboardType: TextInputType.number,
                          style: const TextStyle(color: blackColor),
                          decoration: const InputDecoration(
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              // hintText: "Telephone",
                              hintStyle:
                                  TextStyle(color: greyColor, fontSize: 17)),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      "Adresse de résidance",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
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
                          controller: adressController,
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
                      "Date début",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () async {
                              DateTime? newStartDate = await showDatePicker(
                                  context: context,
                                  initialDate: startDate,
                                  firstDate: DateTime(2000),
                                  lastDate: DateTime(2100));
                              if (newStartDate == null) return;

                              setState(() {
                                isPicking = true;
                                startDate = newStartDate;
                              });
                            },
                            child: Container(
                              height: 48,
                              width: MediaQuery.sizeOf(context).width * 0.43,
                              decoration: BoxDecoration(
                                  border:
                                      Border.all(color: blackColor, width: 0.6),
                                  borderRadius: BorderRadius.circular(12)),
                              child: Center(
                                  child: isPicking
                                      ? Text(
                                          "${startDate.day}/${startDate.month}/${startDate.year}",
                                          style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w700),
                                        )
                                      : const Text("")),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      "Date Fin",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () async {
                              DateTime? newStartDate = await showDatePicker(
                                  context: context,
                                  initialDate: startDate,
                                  firstDate: DateTime(2000),
                                  lastDate: DateTime(2100));
                              if (newStartDate == null) return;

                              setState(() {
                                isPicking2 = true;
                                endDate = newStartDate;
                              });
                            },
                            child: Container(
                              height: 48,
                              width: MediaQuery.sizeOf(context).width * 0.43,
                              decoration: BoxDecoration(
                                  border:
                                      Border.all(color: blackColor, width: 0.6),
                                  borderRadius: BorderRadius.circular(12)),
                              child: Center(
                                  child: isPicking2
                                      ? Text(
                                          "${endDate.day}/${endDate.month}/${endDate.year}",
                                          style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w700),
                                        )
                                      : const Text("")),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      "Remplacent",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
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
                          controller: remplacentController,
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
                    //  const  Spacer(),
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
                              userData['role'] == 'Employe' || userData['role'] == 'Employe a distance'
                                  ? await addCongeEmployee()
                                  : await addCongeChef();
                              if (!mounted) return;
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const UserScreen()));
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
                  ],
                ),
              ),
            ),
          ));
  }
}

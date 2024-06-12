import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:haica/Screens/custombutton.dart';
import 'package:haica/Screens/tfield.dart';

// ignore: must_be_immutable
class UpdateUser extends StatelessWidget {
  final String userId;
  final String fullname;
  final String matricule;
  final String telephone;
  final String anniversaire;
  final String cin;
  UpdateUser(
      {super.key,
      required this.userId,
      required this.fullname,
      required this.matricule,
      required this.telephone,
      required this.anniversaire,
      required this.cin,});

  GlobalKey<FormState> formstate = GlobalKey<FormState>();

  TextEditingController fullnameController = TextEditingController();

  TextEditingController matriculeController = TextEditingController();

  TextEditingController telephoneController = TextEditingController();

  TextEditingController anniversaireController = TextEditingController();

  TextEditingController cinController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
          appBar: AppBar(
    centerTitle: true,
    backgroundColor: Colors.white,
    title: const Text(
      "Mettre a jour les données",
      style: TextStyle(
          color: Colors.black, fontWeight: FontWeight.w600, fontSize: 19),
    ),
          ),
          body: SingleChildScrollView(
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Form(
        key: formstate,
        child: Column(
          children: [
            const Gap(20),
            Tfield(
              title: '',
              text: fullname,
              controller: fullnameController,
              validator: (value) {
                return value!.isEmpty ? "ne peut être vide" : null;
              },
            ),
            const Gap(10),
            Tfield(
              title: '',
              text: matricule,
              controller: matriculeController,
              validator: (value) {
                return value!.isEmpty ? "ne peut être vide" : null;
              },
            ),
            const Gap(10),
            Tfield(
              title: '',
              text: telephone,
              controller: telephoneController,
              validator: (value) {
                return value!.isEmpty ? "ne peut être vide" : null;
              },
            ),
            const Gap(10),
            Tfield(
              title: '',
              text: anniversaire,
              controller: anniversaireController,
              validator: (value) {
                return value!.isEmpty ? "ne peut être vide" : null;
              },
            ),
            const Gap(10),
            Tfield(
              title: '',
              text: cin,
              controller: cinController,
              validator: (value) {
                return value!.isEmpty ? "ne peut être vide" : null;
              },
            ),
            
            const Gap(20),
            Row(
              children: [
                Expanded(
                    child: ProfileButton(
                        onPressed: () async {
                          await FirebaseFirestore.instance
                              .collection('users')
                              .doc(userId)
                              .update({
                            "fullname": fullnameController.text == ""
                                ? fullname
                                : fullnameController.text,
                            "matricule":
                                matriculeController.text == ""
                                    ? matricule
                                    : matriculeController.text,
                            "telephone": telephoneController.text == ""
                                ? telephone
                                : telephoneController.text,
                            "anniversaire": anniversaireController.text == ""
                                ? anniversaire
                                : anniversaireController.text,
                            "cin": cinController.text == ""
                                ? cin
                                : cinController.text,
                         
                          });
                          // if(!mounted) return;
                           // ignore: use_build_context_synchronously
                        
                        },
                        textButton: "Mettre à jour les données")),
              ],
            ),
          ],
        ),
      ),
    ),
          ),
        );
  }
}
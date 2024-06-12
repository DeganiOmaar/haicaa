import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:haica/Screens/conge.dart';
import 'package:haica/Screens/demandes.dart';
import 'package:haica/Screens/employee.dart';
import 'package:haica/Screens/listeconge.dart';
import 'package:haica/Screens/listesortie.dart';
import 'package:haica/Screens/profile.dart';
import 'package:haica/Screens/sortie.dart';
import 'package:haica/Screens/validation.dart';
import 'package:haica/shared/constant.dart';
import 'package:haica/shared/showsnackbar.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({Key? key}) : super(key: key);

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
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

  final PageController _pageController = PageController();

  int currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
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
        : Scaffold(
            backgroundColor: Colors.white,
            bottomNavigationBar: Padding(
              padding: const EdgeInsets.only(
                  left: 20.0, right: 20, top: 8, bottom: 4),
              child: GNav(
                gap: 8,
                color: Colors.grey,
                activeColor: Colors.indigo,
                curve: Curves.decelerate,
                padding: const EdgeInsets.only(
                    bottom: 10, left: 6, right: 6, top: 4),
                onTabChange: (index) {
                  _pageController.jumpToPage(index);
                  setState(() {
                    currentPage = index;
                  });
                },
                tabs: [
                  GButton(
                    icon: userData['role'] == 'SuperAdmin'
                        ? CupertinoIcons.person
                        : Icons.add_circle_outline_rounded,
                    text: userData['role'] == 'SuperAdmin'
                        ? 'Utilisateurs'
                        : 'Congé',
                  ),
                  GButton(
                    icon: userData['role'] == 'SuperAdmin'
                        ? Icons.settings
                        : Icons.add_circle_outline_rounded,
                    text: userData['role'] == 'SuperAdmin'
                        ? 'Demandes'
                        : 'Sortie',
                  ),
                  GButton(
                    icon: userData['role'] == "Chef d'unite"
                        ? Icons.verified
                        : userData['role'] == 'SuperAdmin' ? Icons.note_add_rounded : Icons.note_add_rounded,
                    text: userData['role'] == "Chef d'unite"
                        ? 'Validation'
                        : userData['role'] == 'SuperAdmin' ? 'Liste des sorties' : 'Liste des congés',
                  ),
                    GButton(
                    icon: userData['role'] == "Chef d'unite"
                        ? Icons.note_add_rounded
                        : CupertinoIcons.person,
                    text: userData['role'] == "Chef d'unite"
                        ? 'Liste de Conge'
                        : 'Profile',
                  ),
                ],
              ),
            ),
            body: PageView(
              onPageChanged: (index) {},
              physics: const NeverScrollableScrollPhysics(),
              controller: _pageController,
              children: [
                userData['role'] == 'SuperAdmin' || userData['role'] == 'Directeur general'? Employee() : Congee(),
                userData['role'] == 'SuperAdmin'|| userData['role'] == 'Directeur general' ? Demandes() : Sortie(),
                userData['role'] == "Chef d'unite" ? Validation() :  userData['role'] == 'SuperAdmin'|| userData['role'] == 'Directeur general'? ListeSortie() :ListeCongee(),
                userData['role'] == "Chef d'unite" ? ListeCongee() :  Profile(),
                // Demandes(),
                // Validation(),
              ],
            ),
          );
  }
}

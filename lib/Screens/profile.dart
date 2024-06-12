import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:haica/registerScreens/login.dart';
import 'package:haica/shared/settingcard.dart';
class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  Future<void> _launchUrl(phoneNumber) async {
   
  }



  Map userData = {};
  bool isLoading = true;

  getData() async {
    setState(() {
      isLoading = true;
    });
    try {
      DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
          .instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();

      userData = snapshot.data()!;
    } catch (e) {
      print(e.toString());
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(
            child: CircularProgressIndicator(color: 
            Colors.black,)
          )
        : SafeArea(
            child: Scaffold(
              backgroundColor: Colors.white,
              body: Padding(
                padding: const EdgeInsets.all(25.0),
                child: ListView(
                  children: [
                    const Row(
                      children: [
                        Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            'Profile',
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'myFont',
                            ),
                          ),
                        ),
                        Spacer(),
                        Icon(
                          Icons.notifications_none_outlined,
                          size: 30,
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Row(
                      children: [
                    //                           CircleAvatar(
                    //                              backgroundColor: const Color.fromARGB(255, 225, 225, 225),
                    //                           radius: 35,
                    //                             backgroundImage: NetworkImage(userData['imgLink'],
                    
                          
                    // ),
                          //  ClipRRect(
                          //    child: Image.network(
                          //           userData['imgLink'],
                          //                     fit: BoxFit.cover,
                          //                     // width: MediaQuery.of(context).size.width * 0.4,
                          //                     height: 30,
                          //                                ),
                          //  ),
                        // ),
                        ClipRRect(
  borderRadius: BorderRadius.circular(15.0), // Setting all corners to 15.0 radius
  child: Image.network(
    userData['imgLink'],
    fit: BoxFit.cover,
    height: 35,
    errorBuilder: (context, error, stackTrace) {
      return const CircleAvatar(
        backgroundColor: const Color.fromARGB(255, 225, 225, 225),
        radius: 25,
        backgroundImage: const AssetImage("assets/images/avatar.png"),
      ); // Show an error icon if the image fails to load
    },
  ),
),

                        
                        const SizedBox(
                          width: 12,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                userData['fullname'],
                                style: const TextStyle(
                                    color: Colors.black87,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'myFont',
                                    fontSize: 16),
                              ),
                              const SizedBox(
                                height: 2,
                              ),
                              const Text(
                                'Afficher Profile',
                                style: TextStyle(
                                    color: Colors.black54, fontSize: 15),
                              ),
                            ],
                          ),
                        ),
                        const Spacer(),
                        const Icon(
                          Icons.keyboard_arrow_right_rounded,
                          size: 28,
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Divider(
                      thickness: 1,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
               
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 47,
                            child: profileButton('Appelez-moi', () async {
                             
                            }, Icons.phone_outlined, Colors.black54),
                          ),
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        Expanded(
                          child: SizedBox(
                            height: 47,
                            child: profileButton('message', () async {
                              
                            }, Icons.message_outlined, Colors.indigo.shade400),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: Colors.black54),
                      ),
                      child: Column(
                        children: [
                          profileCard('Nom et Prénom', userData['fullname']),
                          const Divider(
                            thickness: 1,
                            color: Colors.black54,
                          ),
                          profileCard('Email', userData['email']),
                          const Divider(
                            thickness: 1,
                            color: Colors.black54,
                          ),
                          profileCard('Téléphone', "(+216) ${userData['telephone']}"),
                          const SizedBox(
                            height: 10,
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Divider(
                      thickness: 1,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const SettingCard(
                        text: "Obtenir de l'aide", icon: Icons.find_in_page_outlined),
                    const SizedBox(
                      height: 10,
                    ),
                    GestureDetector(
                      onTap: (){
                      
                      },
                      child: const SettingCard(
                          text: 'À propos de nous',
                          icon: Icons.security_update_warning_outlined),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    GestureDetector(
                      onTap: () async {
                        await FirebaseAuth.instance.signOut();
                        if (!mounted) return;
                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                                builder: (context) => const Login()),
                            (route) => false);
                      },
                      child: const SettingCard(
                          text: 'Se déconnecter', icon: Icons.logout_rounded),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const SettingCard(
                        text: 'Supprimer le compte',
                        icon: Icons.delete_outline_rounded),
                  ],
                ),
              ),
            ),
          );
  }

  Widget profileButton(
      String text, VoidCallback onPressed, IconData icon, Color colors) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      style: ButtonStyle(
          foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
          backgroundColor: MaterialStateProperty.all<Color>(colors),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)))),
      icon: Icon(
        icon,
        size: 22,
      ),
      label: Text(
        text,
        style: const TextStyle(fontSize: 14, fontFamily: 'myFont'),
      ),
    );
  }

  Widget profileCard(String title, String text) {
    return Padding(
      padding:
          const EdgeInsets.only(left: 15.0, right: 15, top: 15, bottom: 10),
      child: Row(
        children: [
          Text(
            title,
            style: const TextStyle(
              fontFamily: 'myFont',
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          Text(
            text,
            style: const TextStyle(fontSize: 16, color: Colors.black54),
          )
        ],
      ),
    );
  }
}
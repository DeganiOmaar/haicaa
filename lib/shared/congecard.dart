import 'package:flutter/material.dart';
import 'package:haica/shared/constant.dart';

class CongeCard extends StatelessWidget {
  final String nom;
  final String datedebut;
  final String datefin;
  final String remplacemnt;
  final VoidCallback? onPressedModifier;
  final VoidCallback? onPressedSupprimer;
  const CongeCard(
      {super.key,
      required this.nom,
      required this.datedebut,
      required this.datefin,
      required this.remplacemnt,
      required this.onPressedModifier,
      required this.onPressedSupprimer});

  @override
  Widget build(BuildContext context) {
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
                  nom,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(datedebut),
                const SizedBox(
                  height: 5,
                ),
                Text(datefin),
                const SizedBox(
                  height: 5,
                ),
                Text(remplacemnt),
                const SizedBox(
                  height: 5,
                ),
              ],
            ),
            const Spacer(),
            Column(
              children: [
                ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.green)),
                  onPressed: onPressedModifier,
                  child: const Text(
                    'Modifier',
                    style: TextStyle(color: whiteColor),
                  ),
                ),
                ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.red)),
                  onPressed: onPressedSupprimer,
                  child: const Text(
                    'Supprmer',
                    style: TextStyle(color: whiteColor),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

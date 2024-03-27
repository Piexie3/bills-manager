import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Carouselslider extends StatefulWidget {
  final data;
  final int index;
  const Carouselslider({super.key, required this.data, required this.index});

  @override
  State<Carouselslider> createState() => _CarouselsliderState();
}

class _CarouselsliderState extends State<Carouselslider> {
  User? user;

  @override
  Widget build(BuildContext context) {
    return Container(
      //alignment:  Alignment.centerLeft,
      //width: MediaQuery.of(context).size.width,
      height: 140,
      margin: EdgeInsets.only(left: 0, right: 0, bottom: 20),
      padding: EdgeInsets.only(left: 0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            Colors.purple,
            Colors.purple.shade700,
          ],
        ),
      ),
      child: GestureDetector(
        child: Stack(
          children: [
            Image.asset(
              'assets/414.jpg',
              fit: BoxFit.fitHeight,
            ),
            Container(
              padding: EdgeInsets.only(top: 7, right: 5),
              alignment: Alignment.topRight,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    widget.data['name'],
                    style: GoogleFonts.lato(
                      color: Colors.lightBlue[900],
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  Icon(
                    Icons.chevron_right_rounded,
                    color: Colors.lightBlue[900],
                    size: 20,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

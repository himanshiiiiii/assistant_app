import 'package:assistant_app/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FeatureWidget extends StatelessWidget {
  final Color color;
  final String heading;
  final String content;
 const  FeatureWidget({Key? key ,required this.color,required this.heading,required this.content}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 35,vertical: 10),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 20),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(heading,style: GoogleFonts.sora(
                  fontSize: 18,color: Pallete.blackColor,
                  fontWeight: FontWeight.w600
              ),),
            ),
           const SizedBox(height: 3,),
            Text(content,style: GoogleFonts.poppins(
                fontSize: 15,color: Pallete.mainFontColor,
                height: 1.5,
                fontWeight: FontWeight.w500
            ),),
          ],
        ),
      ),
    );
  }
}

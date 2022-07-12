import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';


class CommentCard extends StatefulWidget {
  var snap;
   CommentCard({Key? key,this.snap}) : super(key: key);

  @override
  State<CommentCard> createState() => _CommentCardState();
}

class _CommentCardState extends State<CommentCard> {
  @override
  Widget build(BuildContext context) {

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
        CircleAvatar(
          backgroundImage: NetworkImage( widget.snap["picUrl"] ),
        ),
        SizedBox(width: 10,),
        Expanded(
          child: Column(
             crossAxisAlignment: CrossAxisAlignment.start,
             // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RichText(
                  text: TextSpan(
                      children: [
                TextSpan(
                  //TODO username
                    text: "${widget.snap["name"]}",
                    style: GoogleFonts.roboto(
                        fontWeight: FontWeight.bold, fontSize: 18)),
                TextSpan(
                  //TODO user comment
                    text: "  ${widget.snap["Comment"]}",
                    style: GoogleFonts.lato(fontSize: 15),),


              ])),
              Padding(padding: EdgeInsets.only(top: 5),
                  //TODO time
                  child: Text("${DateFormat.MMMMEEEEd().format(widget.snap["time"].toDate())}",style: GoogleFonts.lato(color: Colors.grey,fontWeight: FontWeight.bold),)),
            ],
          ),
        ),
        Icon(
          Icons.favorite,
          color: Colors.red,
        ),
      ]),
    );
  }
}

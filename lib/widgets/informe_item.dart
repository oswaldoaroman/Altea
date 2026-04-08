import 'package:flutter/material.dart';

class InformeItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 6),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(Icons.picture_as_pdf, color: Colors.blue),

          SizedBox(width: 10),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Informe médico"),
                Text("(03 abr 2026)", style: TextStyle(fontSize: 12)),
              ],
            ),
          ),

          Icon(Icons.download, color: Colors.green)
        ],
      ),
    );
  }
}

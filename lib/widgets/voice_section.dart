import 'package:flutter/material.dart';

class VoiceSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _card(
      child: Column(
        children: [
          Text("Registros por voz", style: TextStyle(fontSize: 20)),

          ListTile(
            title: Text("Resumen Diario"),
            subtitle: Text("03 abril 2026"),
            trailing: Icon(Icons.play_arrow),
          ),

          ListTile(
            title: Text("Resumen Diario"),
            subtitle: Text("03 abril 2026"),
            trailing: Icon(Icons.play_arrow),
          ),

          SizedBox(height: 10),

          ElevatedButton.icon(
            onPressed: () {},
            icon: Icon(Icons.mic),
            label: Text("Grabar"),
          )
        ],
      ),
    );
  }

  Widget _card({required Widget child}) {
    return Container(
      margin: EdgeInsets.all(12),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: child,
    );
  }
}

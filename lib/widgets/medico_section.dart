import 'package:flutter/material.dart';

class MedicoSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Médicos y Laboratorios", style: TextStyle(fontSize: 20)),

          ListTile(
            leading: Icon(Icons.person),
            title: Text("Dr. Ejemplo"),
            subtitle: Text("0.6 km"),
          ),

          ListTile(
            leading: Icon(Icons.science),
            title: Text("Laboratorio XYZ"),
            subtitle: Text("0.6 km"),
          ),

          SizedBox(height: 10),

          ElevatedButton(
            onPressed: () {},
            child: Text("Ver en mapa"),
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

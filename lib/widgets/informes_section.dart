import 'package:flutter/material.dart';
import 'informe_item.dart';

class InformesSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Informes Recientes", style: TextStyle(fontSize: 20)),

          SizedBox(height: 10),

          InformeItem(),
          InformeItem(),
          InformeItem(),

          SizedBox(height: 10),

          ElevatedButton(
            onPressed: () {},
            child: Text("Generar Informe PDF Completo"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF004A99),
            ),
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

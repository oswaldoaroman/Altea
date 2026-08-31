import 'package:flutter/material.dart';
import '../../widgets_reutilizables/app_card.dart';
import '../../widgets_reutilizables/responsive_body.dart';
import '../result/result_screen.dart';
import 'screens_eval_widgets/measurements_card.dart';
import 'screens_eval_widgets/lifestyle_card.dart';

class EvalScreen extends StatefulWidget {
  const EvalScreen({super.key});

  @override
  EvalScreenState createState() => EvalScreenState();
}

class EvalScreenState extends State<EvalScreen> {
  double _peso = 76;
  double _estatura = 175;
  int _actividadFisica = 1;
  int _colesterol = 1;
  int _glucosa = 1;
  bool _fuma = true;
  bool _alcohol = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: ResponsiveBody(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const TopTitle(title: 'Evaluación corporal', subtitle: 'Paso 1 de 2'),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  child: Column(
                    children: [
                      MeasurementsCard(
                        peso: _peso,
                        estatura: _estatura,
                        onPesoChanged: (v) => setState(() => _peso = v),
                        onEstaturaChanged: (v) => setState(() => _estatura = v),
                      ),
                      const SizedBox(height: 14),
                      LifestyleCard(
                        actividadFisica: _actividadFisica,
                        colesterol: _colesterol,
                        glucosa: _glucosa,
                        fuma: _fuma,
                        alcohol: _alcohol,
                        onActividadChanged: (i) => setState(() => _actividadFisica = i),
                        onColesterolChanged: (i) => setState(() => _colesterol = i),
                        onGlucosaChanged: (i) => setState(() => _glucosa = i),
                        onFumaChanged: (v) => setState(() => _fuma = v),
                        onAlcoholChanged: (v) => setState(() => _alcohol = v),
                      ),
                      const SizedBox(height: 16),
                      PillButton(
                        label: 'Calcular mi riesgo',
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const ResultScreen()),
                          );
                        },
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

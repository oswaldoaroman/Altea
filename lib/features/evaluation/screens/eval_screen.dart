import 'package:flutter/material.dart';
import 'package:altea/core/widgets/app_card.dart';
import 'package:altea/core/widgets/responsive_body.dart';
import 'package:altea/features/evaluation/screens/result_screen.dart';
import 'package:altea/features/evaluation/widgets/measurements_card.dart';
import 'package:altea/features/evaluation/widgets/lifestyle_card.dart';

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
  int _presion = 1;
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
                const TopTitle(
                  title: 'Evaluación corporal',
                  subtitle: 'Paso 1 de 2',
                ),
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
                        presion: _presion,
                        fuma: _fuma,
                        alcohol: _alcohol,
                        onActividadChanged: (i) =>
                            setState(() => _actividadFisica = i),
                        onColesterolChanged: (i) =>
                            setState(() => _colesterol = i),
                        onGlucosaChanged: (i) => setState(() => _glucosa = i),
                        onPresionChanged: (i) => setState(() => _presion = i),
                        onFumaChanged: (v) => setState(() => _fuma = v),
                        onAlcoholChanged: (v) => setState(() => _alcohol = v),
                      ),
                      const SizedBox(height: 16),
                      PillButton(
                        label: 'Calcular mi riesgo',
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ResultScreen(),
                            ),
                          );
                          print("El valor de colesterol es: $_colesterol");
                          print("El valor de glucosa es: $_glucosa");
                          print("El valor de presion es: $_presion");
                          print(
                            "El valor de actividad física es: $_actividadFisica",
                          );
                          print("El valor de peso es: $_peso");
                          print("El valor de estatura es: $_estatura");
                          print("El valor de fuma es: $_fuma");
                          print("El valor de alcohol es: $_alcohol");
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

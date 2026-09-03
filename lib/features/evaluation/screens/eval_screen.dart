import 'package:flutter/material.dart';
import 'package:altea/core/widgets/app_card.dart';
import 'package:altea/core/widgets/responsive_body.dart';
import 'package:altea/features/evaluation/screens/result_screen.dart';
import 'package:altea/features/evaluation/widgets/measurements_card.dart';
import 'package:altea/features/evaluation/widgets/lifestyle_card.dart';
import 'package:altea/features/evaluation/service/evaluacion_service.dart';

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
                          // Aquí puedes realizar la evaluación y obtener el resultado
                          //Cambio de valores representativos a valores numéricos para la evaluación
                          final presionValue =
                              EvaluacionService.convertirPresion(
                                _presion + 1,
                                30,
                                _peso,
                              );
                          //Evaluación de riesgo cardiovascular con los valores obtenidos
                          final resultado = EvaluacionService.evaluar(
                            age: 20,
                            weight: _peso,
                            height: _estatura,
                            cholesterol: _colesterol.toDouble() + 1,
                            gluc: _glucosa.toDouble() + 1,
                            smoke: _fuma ? 1 : 0,
                            alco: _alcohol ? 1 : 0,
                            active: _actividadFisica.toDouble(),
                            apHi: presionValue['apHi'],
                            apLo: presionValue['apLo'],
                          );

                          // Navegar a la pantalla de resultados con el resultado
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ResultScreen(resultado: resultado),
                            ),
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

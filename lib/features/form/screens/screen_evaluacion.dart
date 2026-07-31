import 'package:altea/features/result/screens/screen_resultado.dart';
import 'package:flutter/material.dart';
import '../service/evaluacion_service.dart';
import '../../../core/theme/colors.dart';
import '../widgets/formulario/header_card.dart';
import '../widgets/formulario/form_input_field.dart';
import '../widgets/formulario/form_dropdown_field.dart';
import '../widgets/formulario/sustancias_section.dart';
import '../widgets/formulario/actividad_section.dart';
import '../widgets/formulario/submit_button.dart';
import '../../home/service/recomendacion_service.dart';

class EvaluacionScreen extends StatefulWidget {
  const EvaluacionScreen({super.key});

  @override
  State<EvaluacionScreen> createState() => _EvaluacionScreenState();
}

class _EvaluacionScreenState extends State<EvaluacionScreen> {
  final _edad = TextEditingController();
  final _peso = TextEditingController();
  final _estatura = TextEditingController();

  String? _colesterol;
  String? _glucosa;
  String? _sexo;
  String? _presion;
  String? _actividad;
  bool _cigarro = false;
  bool _alcohol = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const HeaderCard(),
              const SizedBox(height: 16),
              const Text(
                'Ingrese los siguientes datos:',
                style: TextStyle(fontSize: 15),
              ),
              const SizedBox(height: 12),
              FormInputField(
                controller: _edad,
                hint: 'Edad',
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 10),
              FormDropdownField(
                hint: 'Sexo',
                value: _sexo,
                items: const ['Masculino', 'Femenino'],
                onChanged: (v) => setState(() => _sexo = v),
              ),
              const SizedBox(height: 10),
              FormInputField(
                controller: _peso,
                hint: 'Peso (kg)',
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 10),
              FormInputField(
                controller: _estatura,
                hint: 'Estatura (cm)',
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 20),
              SustanciasSection(
                cigarro: _cigarro,
                alcohol: _alcohol,
                onCigarroChanged: (v) => setState(() => _cigarro = v!),
                onAlcoholChanged: (v) => setState(() => _alcohol = v!),
              ),
              const SizedBox(height: 16),
              ActividadSection(
                actividad: _actividad,
                onChanged: (v) => setState(() => _actividad = v),
              ),
              const SizedBox(height: 16),
              Opacity(
                opacity: 0.7,
                child: const Text('Opcionales', style: TextStyle(fontSize: 15)),
              ),
              const SizedBox(height: 10),
              FormDropdownField(
                hint: 'Presión arterial',
                value: _presion,
                items: const ['Normal', 'Elevada', 'Alta'],
                onChanged: (v) => setState(() => _presion = v),
              ),
              const SizedBox(height: 10),
              FormDropdownField(
                hint: 'Colesterol',
                value: _colesterol,
                items: const ['Normal', 'Elevado', 'Alto'],
                onChanged: (v) => setState(() => _colesterol = v),
              ),
              const SizedBox(height: 10),
              FormDropdownField(
                hint: 'Nivel de glucosa',
                value: _glucosa,
                items: const ['Normal', 'Elevada', 'Muy elevada'],
                onChanged: (v) => setState(() => _glucosa = v),
              ),
              const SizedBox(height: 24),
              // Aquí iría la lógica de validación y procesamiento de datos
              SubmitButton(
                onPressed: () {
                  // =========================
                  // VALIDACIÓN
                  // =========================

                  if (_edad.text.isEmpty ||
                      _peso.text.isEmpty ||
                      _estatura.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Por favor, complete los campos obligatorios.',
                        ),
                      ),
                    );

                    return;
                  }

                  // =========================
                  // CONVERSIÓN DE DATOS
                  // =========================

                  double edad = double.tryParse(_edad.text) ?? 0;

                  double peso = double.tryParse(_peso.text) ?? 0;

                  double estatura = double.tryParse(_estatura.text) ?? 0;

                  double colesterol = EvaluacionService.convertirColesterol(
                    _colesterol,
                  );

                  // =========================
                  // BOOLEANOS → NUMÉRICOS
                  // =========================

                  double alcohol = _alcohol ? 1 : 0;

                  double cigarro = _cigarro ? 1 : 0;

                  double actividad = _actividad == 'Activo' ? 1 : 0;

                  // =========================
                  // TRATAMIENTO DE DATOS
                  // =========================

                  final presion = EvaluacionService.convertirPresion(
                    _presion,
                    edad.toInt(),
                    peso,
                  );

                  double apHi = presion['apHi']!;

                  double apLo = presion['apLo']!;

                  double gluc = EvaluacionService.convertirGlucosa(_glucosa);

                  // =========================
                  // CÁLCULO DE RIESGO
                  // =========================

                  double riesgo = EvaluacionService.evaluar(
                    apHi: apHi,
                    apLo: apLo,
                    age: edad,
                    cholesterol: colesterol,
                    gluc: gluc,
                    weight: peso,
                    height: estatura,
                    smoke: cigarro,
                    alco: alcohol,
                    active: actividad,
                  );

                  print("Riesgo cardiovascular: $riesgo %");

                  // =========================
                  // FACTORES DETECTADOS
                  // =========================

                  final factores = RecomendacionService.generarFactores(
                    fuma: _cigarro,
                    alcohol: _alcohol,
                    actividad: _actividad ?? '',
                    colesterol: colesterol,
                  );

                  // =========================
                  // RECOMENDACIONES
                  // =========================

                  final recomendaciones =
                      RecomendacionService.generarRecomendaciones(
                        fuma: _cigarro,
                        alcohol: _alcohol,
                        actividad: _actividad ?? '',
                        colesterol: colesterol,
                      );

                  // =========================
                  // NAVEGACIÓN
                  // =========================

                  Navigator.push(
                    context,

                    MaterialPageRoute(
                      builder: (_) => ResultadoScreen(
                        riesgo: riesgo,
                        factores: factores,
                        recomendaciones: recomendaciones,
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

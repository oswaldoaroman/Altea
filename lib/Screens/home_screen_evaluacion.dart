import 'package:flutter/material.dart';
import '../service/EvaluacionService.dart';
import '../../topics/colors.dart';
import '../homeFormulario/header_card.dart';
import '../homeFormulario/form_input_field.dart';
import '../homeFormulario/form_dropdown_field.dart';
import '../homeFormulario/sustancias_section.dart';
import '../homeFormulario/actividad_section.dart';
import '../homeFormulario/submit_button.dart';

class EvaluacionScreen extends StatefulWidget {
  const EvaluacionScreen({super.key});

  @override
  State<EvaluacionScreen> createState() => _EvaluacionScreenState();
}

class _EvaluacionScreenState extends State<EvaluacionScreen> {
  final _edad = TextEditingController();
  final _peso = TextEditingController();
  final _estatura = TextEditingController();
  final _colesterol = TextEditingController();

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
              FormInputField(
                controller: _colesterol,
                hint: 'Colesterol total',
                keyboardType: TextInputType.number,
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

                  double edad = double.tryParse(_edad.text) ?? 0;
                  double peso = double.tryParse(_peso.text) ?? 0;
                  double estatura = double.tryParse(_estatura.text) ?? 0;
                  double colesterol = double.tryParse(_colesterol.text) ?? 0;

                  //quitar estas varialbes y buscar otra solucion
                  double alcohol = _alcohol == true ? 1 : 0;
                  double cigarro = _cigarro == true ? 1 : 0;
                  double actividad = _actividad == 'Activo' ? 1 : 0;

                  final presion = EvaluacionService.convertirPresion(
                    _presion,
                    edad.toInt(),
                    peso,
                  );

                  double apHi = presion['apHi']!;
                  double apLo = presion['apLo']!;
                  double gluc = EvaluacionService.convertirGlucosa(_glucosa);

                  double riesgo = EvaluacionService.evaluar(
                    apHi: apHi,
                    apLo: apLo,
                    age: edad.toDouble(),
                    cholesterol: colesterol,
                    gluc: gluc,
                    weight: peso.toDouble(),
                    height: estatura.toDouble(),
                    smoke: cigarro,
                    alco: alcohol,
                    active: actividad,
                  );

                  print("Riesgo cardiovascular: $riesgo %");

                  //Nombre de las variables:
                  // print("Edad: $edad");
                  // print("Sexo: $_sexo");
                  // print("Peso: $peso");
                  // print("Estatura: $estatura");
                  // print("Colesterol: $colesterol");
                  //print("Fuma: $_cigarro");
                  //print("Alcohol: $_alcohol");
                  // print("Presión arterial: $_presion");
                  //print("Actividad física: $_actividad");
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

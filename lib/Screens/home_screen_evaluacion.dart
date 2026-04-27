import 'package:flutter/material.dart';
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
              const Text('Ingrese los siguientes datos:', style: TextStyle(fontSize: 15)),
              const SizedBox(height: 12),
              FormInputField(controller: _edad, hint: 'Edad', keyboardType: TextInputType.number),
              const SizedBox(height: 10),
              FormDropdownField(
                hint: 'Sexo',
                value: _sexo,
                items: const ['Masculino', 'Femenino'],
                onChanged: (v) => setState(() => _sexo = v),
              ),
              const SizedBox(height: 10),
              FormInputField(controller: _peso, hint: 'Peso (kg)', keyboardType: TextInputType.number),
              const SizedBox(height: 10),
              FormInputField(controller: _estatura, hint: 'Estatura (cm)', keyboardType: TextInputType.number),
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
              Opacity(opacity: 0.7, child: const Text('Opcionales', style: TextStyle(fontSize: 15))),
              const SizedBox(height: 10),
              FormDropdownField(
                hint: 'Presión arterial',
                value: _presion,
                items: const ['Normal', 'Elevada', 'Alta'],
                onChanged: (v) => setState(() => _presion = v),
              ),
              const SizedBox(height: 10),
              FormInputField(controller: _colesterol, hint: 'Colesterol total', keyboardType: TextInputType.number),
              const SizedBox(height: 24),
              SubmitButton(onPressed: () {}),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

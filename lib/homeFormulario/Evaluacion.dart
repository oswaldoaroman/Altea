import 'package:flutter/material.dart';
import '../topics/colors.dart';

class EvaluacionScreen extends StatefulWidget {
  const EvaluacionScreen({super.key});

  @override
  State<EvaluacionScreen> createState() => _EvaluacionScreenState();
}

class _EvaluacionScreenState extends State<EvaluacionScreen> {
  final _edadCtrl = TextEditingController();
  final _pesoCtrl = TextEditingController();
  final _estaturaCtrl = TextEditingController();
  final _presionCtrl = TextEditingController();
  final _colesterolCtrl = TextEditingController();

  String? _sexo;
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
              _HeaderCard(),
              const SizedBox(height: 16),
              const Text('Ingrese los siguientes datos:', style: TextStyle(fontSize: 15)),
              const SizedBox(height: 12),
              _inputField(_edadCtrl, 'Edad', TextInputType.number),
              const SizedBox(height: 10),
              _dropdownField('Sexo', _sexo, ['Masculino', 'Femenino'], (v) => setState(() => _sexo = v)),
              const SizedBox(height: 10),
              _inputField(_pesoCtrl, 'Peso (kg)', TextInputType.number),
              const SizedBox(height: 10),
              _inputField(_estaturaCtrl, 'Estatura (cm)', TextInputType.number),
              const SizedBox(height: 20),
              _sectionLabel('¿Consumes alguna de las siguientes sustancias?'),
              const SizedBox(height: 8),
              _checkRow('Cigarro', Icons.smoking_rooms, _cigarro, (v) => setState(() => _cigarro = v!)),
              _checkRow('Alcohol', Icons.local_bar, _alcohol, (v) => setState(() => _alcohol = v!)),
              const SizedBox(height: 16),
              _sectionLabel('¿Cual es tu nivel de actividad física?'),
              const SizedBox(height: 8),
              ..._actividadOptions(),
              const SizedBox(height: 20),
              Opacity(
                opacity: 0.7,
                child: const Text('Opcionales', style: TextStyle(fontSize: 15)),
              ),
              const SizedBox(height: 10),
              _dropdownField('Presión arterial', null, ['Normal', 'Elevada', 'Alta'], (_) {}),
              const SizedBox(height: 10),
              _inputField(_colesterolCtrl, 'Colesterol total', TextInputType.number),
              const SizedBox(height: 24),
              _submitButton(),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _inputField(TextEditingController ctrl, String hint, TextInputType type) {
    return TextField(
      controller: ctrl,
      keyboardType: type,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.black.withOpacity(0.45)),
        filled: true,
        fillColor: AppColors.primary.withOpacity(0.15),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide.none),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      ),
    );
  }

  Widget _dropdownField(String hint, String? value, List<String> items, ValueChanged<String?> onChanged) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.15),
        borderRadius: BorderRadius.circular(30),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          hint: Text(hint, style: TextStyle(color: Colors.black.withOpacity(0.45), fontSize: 15)),
          items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _checkRow(String label, IconData icon, bool value, ValueChanged<bool?> onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(children: [
        Checkbox(value: value, onChanged: onChanged, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4))),
        Icon(icon, size: 18, color: AppColors.dark),
        const SizedBox(width: 8),
        Text(label, style: const TextStyle(fontSize: 15)),
      ]),
    );
  }

  List<Widget> _actividadOptions() {
    return ['Activo', 'Ligero', 'Sedentario'].map((op) => RadioListTile<String>(
      title: Text(op, style: const TextStyle(fontSize: 15)),
      value: op,
      groupValue: _actividad,
      onChanged: (v) => setState(() => _actividad = v),
      contentPadding: EdgeInsets.zero,
      dense: true,
    )).toList();
  }

  Widget _submitButton() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [Color(0xFF008E05), Color(0xFFA6EDA9)]),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.15), blurRadius: 8, offset: const Offset(0, 4))],
      ),
      child: ElevatedButton.icon(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: StadiumBorder(),
        ),
        icon: const Icon(Icons.play_arrow, color: Colors.white),
        label: const Text('INICIAR EVALUACIÓN',
            style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600, letterSpacing: 0.5)),
      ),
    );
  }

  Widget _sectionLabel(String text) {
    return Opacity(
      opacity: 0.7,
      child: Text(text, style: const TextStyle(fontSize: 15)),
    );
  }
}

class _HeaderCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [AppColors.primary, Colors.white],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.12), blurRadius: 8, offset: const Offset(0, 4))],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: const [
              Text('Evaluación Corporal Básica',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: Color(0xFF3D3D3D))),
              SizedBox(height: 8),
              Text('Completa los campos basicos para evaluar tu riesgo cardiovascular',
                  style: TextStyle(fontSize: 13, height: 1.4)),
            ]),
          ),
          const SizedBox(width: 12),
          const Icon(Icons.favorite, color: Colors.red, size: 32),
        ],
      ),
    );
  }
}

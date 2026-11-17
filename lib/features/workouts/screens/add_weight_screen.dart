import 'package:fit_track_pro/features/workouts/models/weight_model.dart';
import 'package:flutter/material.dart';

class AddWeightScreen extends StatefulWidget {
  const AddWeightScreen({super.key});

  @override
  State<StatefulWidget> createState() => _AddWeightScreenState();
}

class _AddWeightScreenState extends State<AddWeightScreen> {
  final _formKey = GlobalKey<FormState>();

  final _fechaController = TextEditingController();
  final _pesoController = TextEditingController();

  void _saveWeight() {
    if (_formKey.currentState!.validate()) {
      final newWeight = WeightModel(
        fecha: _fechaController.text,
        pesoKilos: double.parse(_pesoController.text),
      );

      Navigator.pop(context, newWeight);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registrar peso'),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _fechaController,
                decoration: InputDecoration(
                  labelText: 'Fecha',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.calendar_today),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Por favor ingresa la fecha';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _pesoController,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  labelText: 'Peso (kg)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.monitor_weight),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Ingresa el peso';
                  }

                  final peso = double.tryParse(value);

                  if (peso == null) {
                    return 'Por favor ingrese un número válido';
                  }

                  if (peso <= 0) {
                    return 'El peso debe ser mayor a 0';
                  }

                  return null;
                },
              ),
              Spacer(),
              ElevatedButton(
                onPressed: _saveWeight,
                child: Text('Guardar peso', style: TextStyle(fontSize: 18)),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  backgroundColor: Colors.blueAccent,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

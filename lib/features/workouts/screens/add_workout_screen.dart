
import 'package:fit_track_pro/features/workouts/models/workout_model.dart';
import 'package:flutter/material.dart';

class AddWorkoutScreen extends StatefulWidget {
  const AddWorkoutScreen({super.key});

  @override
  State<StatefulWidget> createState() => _AddWorkoutScreenState();
  
}

class _AddWorkoutScreenState extends State<AddWorkoutScreen>{

  final _formKey = GlobalKey<FormState>();

  final _titleController = TextEditingController();
  final _durationController = TextEditingController();

  String _selectedCategory = 'Fuerza';
  final List<String> _categories = ['Fuerza', 'Cardio', 'Flexibilidad', 'Equilibrio'];

  void _saveWorkout() {
    if (_formKey.currentState!.validate()) {
      final newWorkout = WorkoutModel(
        title: _titleController.text,
        category: _selectedCategory,
        durationMinutes: int.parse(_durationController.text),
      );

      Navigator.pop(context, newWorkout);
    }
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nueva Rutina'),
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
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'Nombre',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.title),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Por favor ingresa un nombre';
                  }
                  if(value.length < 3){
                    return 'El nombre debe tener al menos 3 caracteres';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              DropdownButtonFormField<String>(
                initialValue: _selectedCategory,
                decoration: InputDecoration(
                  labelText: 'Categoría',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.category),
                ),
                items: _categories.map((String category) {
                  return DropdownMenuItem<String>(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedCategory = newValue!;
                  });
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _durationController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Duración (minutos)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.timer),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Ingresa los minutos';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Por favor ingrese un número válido';
                  }
                  return null;
                },
              ),
              Spacer(),
              ElevatedButton(
                onPressed: _saveWorkout,
                child: Text('Guardar rutina', style: TextStyle(fontSize: 18)),
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
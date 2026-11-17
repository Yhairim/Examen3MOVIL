import 'package:fit_track_pro/core/storage/local_storage_service.dart';
import 'package:fit_track_pro/features/auth/screens/login_screen.dart';
import 'package:fit_track_pro/features/workouts/models/workout_model.dart';
import 'package:fit_track_pro/features/workouts/models/weight_model.dart';
import 'package:fit_track_pro/features/workouts/screens/add_weight_screen.dart';
import 'package:fit_track_pro/features/workouts/screens/add_workout_screen.dart';
import 'package:fit_track_pro/features/workouts/services/local_workout_service.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final LocalWorkoutService _dbService = LocalWorkoutService();

  List<WorkoutModel> _workouts = [];
  List<WeightModel> _weightRecords = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadWorkouts();
  }

  Future<void> _loadWorkouts() async {
    setState(() {
      _isLoading = true;
    });

    final workouts = await _dbService.getWorkouts();

    setState(() {
      _workouts = workouts;
      _isLoading = false;
    });
  }

  void _logout() async {
    final _storage = LocalStorageService();
    await _storage.deleteToken();

    if (!mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
      (Route<dynamic> route) => false,
    );
  }

  // void _showAddWorkoutDialog() {
  //   final titleController = TextEditingController();
  //   final categotyController = TextEditingController();
  //   final durationMinutesController = TextEditingController();

  //   showDialog(
  //     context: context,
  //     builder: (context) => AlertDialog(
  //       title: Text('Nueva rutina'),
  //       content: Column(
  //         mainAxisSize: MainAxisSize.min,
  //         children: [
  //           TextField(
  //             controller: titleController,
  //             decoration: InputDecoration(labelText: "Nombre"),
  //           ),
  //           TextField(
  //             controller: categotyController,
  //             decoration: InputDecoration(labelText: "Categoría"),
  //           ),
  //           TextField(
  //             controller: durationMinutesController,
  //             decoration: InputDecoration(labelText: "Duración (minutos)"),
  //             keyboardType: TextInputType.number,
  //           ),
  //         ],
  //       ),
  //       actions: [
  //         TextButton(
  //           onPressed: () => Navigator.of(context),
  //           child: Text('Cancelar'),
  //         ),
  //         ElevatedButton(onPressed: () async {
  //           if (titleController.text.isNotEmpty &&
  //             durationMinutesController.text.isNotEmpty &&
  //             categotyController.text.isNotEmpty) {
  //           final newWorkout = WorkoutModel(
  //             title: titleController.text,
  //             category: categotyController.text,
  //             durationMinutes: int.parse(durationMinutesController.text),
  //           );

  //             await _dbService.insertWorkout(newWorkout);

  //             if (mounted) {
  //               Navigator.pop(context);
  //               _loadWorkouts();
  //             }
  //           }
  //         }, child: Text('Guardar')),
  //       ]
  //     ),
  //   );
  // }

  Future<void> _navigateToAddWorkout() async {
    final newWorkout = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddWorkoutScreen()),
    );

    if (newWorkout != null && newWorkout is WorkoutModel) {
      await _dbService.insertWorkout(newWorkout);
      _loadWorkouts();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Runtina agregada exitosamente'),
            backgroundColor: Colors.green,
          ),
        );
      }
    }
  }

  Future<void> _navigateToAddWeight() async {
    final newWeight = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddWeightScreen()),
    );

    if (newWeight != null && newWeight is WeightModel) {
      setState(() {
        _weightRecords.add(newWeight);
      });
    }
  }

  Future<void> _deleteWorkout(int id, String title) async {
    await _dbService.deleteWorkout(id);

    if (mounted) {
      _loadWorkouts();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Runtina eliminada: $title')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Mis entrenamientos"),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: _navigateToAddWorkout,
            icon: Icon(Icons.fitness_center),
            tooltip: 'Agregar rutina',
          ),
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('Cerrar sesión'),
                  content: Text('Tendras que volver a ingresar tus datos'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('Cancelar'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        _logout();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                      ),
                      child: Text(
                        'Salir',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              );
            },
            icon: Icon(Icons.logout),
          ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: 2 +
                  (_workouts.isEmpty ? 1 : _workouts.length) +
                  (_weightRecords.isEmpty ? 1 : _weightRecords.length),
              itemBuilder: (context, index) {
                if (index == 0) {
                  return Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      'Mis entrenamientos',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                }

                final workoutCount =
                    _workouts.isEmpty ? 1 : _workouts.length;

                if (index <= workoutCount) {
                  if (_workouts.isEmpty) {
                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text('No tienes rutinas creadas'),
                    );
                  }

                  final workout = _workouts[index - 1];

                  return Card(
                    margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: ListTile(
                      leading: CircleAvatar(
                        child: Icon(Icons.fitness_center),
                      ),
                      title: Text(
                        workout.title,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      trailing: IconButton(
                        onPressed: () =>
                            _deleteWorkout(workout.localId!, workout.title),
                        icon: Icon(Icons.delete, color: Colors.red),
                      ),
                      subtitle: Text(
                        '${workout.category} - ${workout.durationMinutes} min',
                      ),
                    ),
                  );
                }

                final weightTitleIndex = workoutCount + 1;

                if (index == weightTitleIndex) {
                  return Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      'Registro de peso',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                }

                if (_weightRecords.isEmpty) {
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text('No hay registros'),
                  );
                }

                final weightIndex = index - weightTitleIndex - 1;
                final record = _weightRecords[weightIndex];

                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    leading: CircleAvatar(
                      child: Icon(Icons.monitor_weight),
                    ),
                    title: Text('${record.pesoKilos} kg'),
                    subtitle: Text(record.fecha),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAddWeight,
        child: Icon(Icons.add),
      ),
    );
  }
}

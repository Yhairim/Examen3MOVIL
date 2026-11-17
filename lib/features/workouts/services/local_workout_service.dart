import 'package:fit_track_pro/core/database/database_helper.dart';
import 'package:fit_track_pro/features/workouts/models/workout_model.dart';

class LocalWorkoutService {
  final dbHelper = DatabaseHelper.instance;

  //Crear
  Future<int> insertWorkout(WorkoutModel workout) async {
    final db = await dbHelper.database;
    return await db.insert('workouts', workout.toMap());
  }

  //Lectura
  Future<List<WorkoutModel>> getWorkouts() async {
    final db = await dbHelper.database;

    final List<Map<String, dynamic>> maps = await db.query('workouts');

    return List.generate(maps.length, (i) {
      return WorkoutModel.fromMap(maps[i]);
    }); 
  }

  //Eliminación
  Future<int> deleteWorkout(int id) async {
    final db = await dbHelper.database;
    return await db.delete(
      'workouts',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:rescuelink/features/incidents/domain/incident_model.dart';
import 'package:rescuelink/core/constants/enums.dart';

class LocalDatabase {
  static Database? _db;

  Future<Database> get database async {
    _db ??= await _initDb();
    return _db!;
  }

  Future<Database> _initDb() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'rescuelink.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE incidents (
            id TEXT PRIMARY KEY,
            user_id TEXT,
            category TEXT,
            description TEXT,
            latitude REAL,
            longitude REAL,
            priority TEXT,
            status TEXT,
            created_at TEXT,
            photo_url TEXT,
            local_photo_path TEXT,
            sync_status TEXT,
            people_affected INTEGER,
            road_blocked INTEGER
          )
        ''');
      },
    );
  }

  Future<void> saveIncident(IncidentModel incident) async {
    final db = await database;
    await db.insert(
      'incidents',
      incident.toLocalDbJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<IncidentModel>> getUnsyncedIncidents() async {
    final db = await database;
    final maps = await db.query(
      'incidents',
      where: 'sync_status = ?',
      whereArgs: [SyncStatus.pending.name],
    );
    return maps.map((e) => IncidentModel.fromJson(e)).toList();
  }

  Future<List<IncidentModel>> getAllIncidents() async {
    final db = await database;
    final maps = await db.query('incidents', orderBy: 'created_at DESC');
    return maps.map((e) => IncidentModel.fromJson(e)).toList();
  }

  Future<void> updateSyncStatus(String id, SyncStatus status, {String? remotePhotoUrl}) async {
    final db = await database;
    final updateData = <String, dynamic>{
      'sync_status': status.name,
    };
    if (remotePhotoUrl != null) {
      updateData['photo_url'] = remotePhotoUrl;
    }
    await db.update(
      'incidents',
      updateData,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> clearAll() async {
    final db = await database;
    await db.delete('incidents');
  }
}

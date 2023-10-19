import 'package:hive_flutter/adapters.dart';
part 'notes_model.g.dart';

@HiveType(typeId: 0)
class notes_Model extends HiveObject{
  @HiveField(0)
  String title;

  @HiveField(1)
  String description;

  notes_Model({required this.title, required this.description});
}
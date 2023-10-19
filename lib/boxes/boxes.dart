
import 'package:demo/models/notes_model.dart';
import 'package:hive/hive.dart';

class Boxes{
  static Box<notes_Model> getData() => Hive.box<notes_Model>('Notes');
}
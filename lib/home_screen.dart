import 'package:demo/boxes/boxes.dart';
import 'package:demo/models/notes_model.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';

class home_screem extends StatefulWidget {
  const home_screem({super.key});

  @override
  State<home_screem> createState() => _home_screemState();
}

class _home_screemState extends State<home_screem> {
  final title_controller = TextEditingController();
  final description_controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Notes'),
      ),
      body: ValueListenableBuilder<Box<notes_Model>>(
        valueListenable: Boxes.getData().listenable(),
        builder: (context,box,_){
          var data = box.values.toList().cast<notes_Model>();
          return ListView.builder(
            reverse: true,
              shrinkWrap: true,
              itemCount: box.length,
              itemBuilder: (context, index){
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(data[index].title.toString()),
                            const Spacer(),
                            InkWell(
                              onTap: (){
                                editNotes(data[index], data[index].title.toString(), data[index].description.toString());
                              },
                                child: const Icon(Icons.edit, color: Colors.black,)),
                            const SizedBox(width: 15,),
                            InkWell(
                                onTap: (){
                                  delete_note(data[index]);
                                },
                                child: const Icon(Icons.delete, color: Colors.red,)),
                          ],
                        ),
                        Text(data[index].description.toString()),
                      ],
                    ),
                  ),
                );
              });
        },
      ),
      floatingActionButton: FloatingActionButton(onPressed: (){
        notesDialog();
      },
        child: Icon(Icons.add),
      ),
    );
  }

  void delete_note(notes_Model note) async{
    await note.delete();
  }

  Future<void> notesDialog() async{
    return showDialog(context: context, builder: (context){
      return AlertDialog(
        title: Text('Add Notes'),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextFormField(
                controller: title_controller,
                decoration: InputDecoration(
                  hintText: 'Enter Title',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20,),
              TextFormField(
                controller: description_controller,
                decoration: InputDecoration(
                  hintText: 'Enter Description',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: (){
            Navigator.pop(context);
          }, child: Text('Cancel')),

          TextButton(onPressed: (){
            final data = notes_Model(title: title_controller.text, description: description_controller.text);
            final box = Boxes.getData();
            box.add(data);
            data.save();
            title_controller.clear();
            description_controller.clear();
            Navigator.pop(context);
          }, child: Text('Add')),
        ],
      );
    });
  }

  Future<void> editNotes(notes_Model notes, String title, String description) async{
    title_controller.text = title;
    description_controller.text = description;
    return showDialog(context: context, builder: (context){
      return AlertDialog(
        title: Text('Edit Notes'),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextFormField(
                controller: title_controller,
                decoration: InputDecoration(
                  hintText: 'Enter Title',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20,),
              TextFormField(
                controller: description_controller,
                decoration: InputDecoration(
                  hintText: 'Enter Description',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: (){
            Navigator.pop(context);
          }, child: Text('Cancel')),

          TextButton(onPressed: (){
            notes.title = title_controller.text.toString();
            notes.description = description_controller.text.toString();
            notes.save();
            title_controller.clear();
            description_controller.clear();
            Navigator.pop(context);
          }, child: Text('Edit')),
        ],
      );
    });
  }
}

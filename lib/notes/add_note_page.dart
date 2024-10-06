import 'package:flutter/material.dart';
import 'package:Ncrypt/clients/notes_client.dart';
import 'package:Ncrypt/models/attributes.dart';
import 'package:Ncrypt/models/note.dart';
import 'package:Ncrypt/utils/custom_toast.dart';

class AddNotePage extends StatefulWidget {
  const AddNotePage({super.key});

  @override
  State<AddNotePage> createState() => _AddNotePageState();
}

class _AddNotePageState extends State<AddNotePage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = new TextEditingController();
  final TextEditingController _contentController = new TextEditingController();
  bool _isFavourite = false;
  bool _isLocked = false;

  void save() {
    Note note = Note(
        title: _titleController.text,
        content: _contentController.text,
        attributes: Attributes(
            isFavourite: _isFavourite, requireMasterPassword: _isLocked),
        createdDateTime: DateTime.now().toIso8601String());
    NotesClient().addNote(note).then((value) {
      if (context.mounted) {
        if (value == null || (value is String && value.isEmpty)) {
          CustomToast.success(context, "Successfully added");
          Navigator.of(context).pop();
        } else {
          CustomToast.error(context, value);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add note"),
        elevation: 2,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Container(
                      child: TextFormField(
                        controller: _titleController,
                        decoration: InputDecoration(
                          hintText: "Enter tile",
                          label: RichText(
                              text: TextSpan(children: [
                            TextSpan(
                              text: "Title ",
                              style: Theme.of(context).textTheme.bodyMedium
                            ),
                            TextSpan(
                                text: "*",
                                style: TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold))
                          ])),
                        ),
                        maxLength: 25,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Title cannot be empty";
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        _isFavourite = !_isFavourite;
                      });
                    },
                    icon: _isFavourite
                        ? Icon(Icons.favorite)
                        : Icon(Icons.favorite_border),
                  ),
                  Text("Favourite"),
                  Tooltip(
                    verticalOffset: 10,
                    message: "Requires master password to view account password, edit and delete data.",
                    child: IconButton(
                      onPressed: () {
                        setState(() {
                          _isLocked = !_isLocked;
                        });
                      },
                      icon:
                          _isLocked ? Icon(Icons.lock) : Icon(Icons.lock_outline),
                    ),
                  ),
                  Text("Locked"),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Expanded(
                child: TextFormField(
                  controller: _contentController,
                  maxLines: 100,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Content cannot be empty";
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      save();
                    }
                  },
                  child: Text(
                    "Save".toUpperCase(),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

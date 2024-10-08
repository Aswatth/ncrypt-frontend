import 'package:flutter/material.dart';
import 'package:Ncrypt/clients/notes_client.dart';
import 'package:Ncrypt/general_pages/validate_master_password.dart';
import 'package:Ncrypt/models/note.dart';
import 'package:Ncrypt/notes/add_note_page.dart';
import 'package:Ncrypt/notes/edit_note_page.dart';
import 'package:Ncrypt/utils/custom_toast.dart';

import '../utils/DateTimeFormatter.dart';

class NotePage extends StatefulWidget {
  const NotePage({super.key});

  @override
  State<NotePage> createState() => _NotePageState();
}

class _NotePageState extends State<NotePage> {
  List<Note> noteList = [];
  List<Note> _filteredDataList = [];
  Note? selectedNote;

  TextEditingController _searchController = TextEditingController();
  bool _showFavourites = false;
  bool _showRequireMasterPassword = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getAllNotes();
  }

  void _filterNotes() {
    setState(() {
      _filteredDataList = noteList;

      if (_searchController.text.isNotEmpty) {
        _filteredDataList = _filteredDataList
            .where((m) => m.title.startsWith(_searchController.text))
            .toList();
      }

      if (_showFavourites) {
        _filteredDataList =
            _filteredDataList.where((m) => m.attributes.isFavourite).toList();
      }

      if (_showRequireMasterPassword) {
        _filteredDataList = _filteredDataList
            .where((m) => m.attributes.requireMasterPassword)
            .toList();
      }

      selectedNote = null;
    });
  }

  void getAllNotes() {
    NotesClient().getAllNotes().then((value) {
      if (value != null && value is List<dynamic>) {
        setState(() {
          noteList = value.map((m) => m as Note).toList();
          _filteredDataList = noteList;
        });
      } else {
        if (context.mounted) {
          if (value != null && value is String && value.isNotEmpty) {
            CustomToast.error(context, value);
          }
        }
      }
    });
  }

  Future<String> getContent() async {
    dynamic result =
        await NotesClient().getContent(selectedNote!.createdDateTime);
    if (result != null && (result is String && result.isNotEmpty)) {
      return result;
    } else {
      if (context.mounted) {
        CustomToast.error(context, "Error fetching content");
      }
      return "";
    }
  }

  void updateNote(Note updatedNote) {
    NotesClient()
        .updateNote(updatedNote.createdDateTime, updatedNote)
        .then((value) {
      if (context.mounted) {
        if (value != null) {
          CustomToast.error(context, value);
        }
      }
    });
  }

  void deleteNote(Note toDelete) {
    showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: Text("Are you sure?"),
          contentPadding: const EdgeInsets.all(20),
          children: [
            Text("Delete ${toDelete.title} note?"),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    label: Text("No"),
                    icon: Icon(Icons.close),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      NotesClient()
                          .deleteNote(toDelete.createdDateTime)
                          .then((value) {
                        if (context.mounted) {
                          if (value == null) {
                            CustomToast.success(
                                context, "Successfully deleted");
                            setState(() {
                              selectedNote = null;
                              noteList.remove(toDelete);
                              _filteredDataList = noteList;
                              Navigator.of(context).pop();
                            });
                          } else {
                            CustomToast.error(context, value);
                            Navigator.of(context).pop();
                          }
                        }
                      });
                    },
                    label: Text("Yes"),
                    icon: Icon(Icons.check),
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          Theme.of(context).scaffoldBackgroundColor,
                      // Background color
                      foregroundColor:
                          Theme.of(context).textTheme.bodyMedium?.color,
                      // Text color
                      side: BorderSide(
                        color: Theme.of(context)
                            .textTheme
                            .bodyMedium!
                            .color!, // Border color
                        width: 2, // Border width
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  void navigate(Widget destinationWidget) {
    Navigator.of(context)
        .push(
      MaterialPageRoute(builder: (context) => destinationWidget),
    )
        .then((_) {
      getAllNotes();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _searchController,
                        decoration: InputDecoration(
                            hintText: "Search",
                            prefixIcon: Icon(Icons.search),
                            filled: true,
                            suffixIcon: SizedBox(
                              width: 80,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      setState(() {
                                        _showFavourites = !_showFavourites;
                                        _filterNotes();
                                      });
                                    },
                                    icon: _showFavourites
                                        ? Icon(Icons.favorite)
                                        : Icon(Icons.favorite_border),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      setState(() {
                                        _showRequireMasterPassword =
                                            !_showRequireMasterPassword;
                                        _filterNotes();
                                      });
                                    },
                                    icon: _showRequireMasterPassword
                                        ? Icon(Icons.lock)
                                        : Icon(Icons.lock_outline),
                                  )
                                ],
                              ),
                            )),
                        onChanged: (value) {
                          _filterNotes();
                        },
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.of(context)
                            .push(MaterialPageRoute(
                                builder: (context) => AddNotePage()))
                            .then((_) {
                          setState(() {
                            selectedNote = null;
                            getAllNotes();
                          });
                        });
                      },
                      icon: Icon(Icons.add),
                      label: Text("Add".toUpperCase()),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Expanded(
                  child: ListView(
                    children: _filteredDataList.map((note) {
                      return ListTile(
                        leading: SizedBox(
                          width: 100,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              IconButton(
                                onPressed: () {
                                  setState(() {
                                    note.attributes.isFavourite =
                                        !note.attributes.isFavourite;
                                    updateNote(note);
                                  });
                                },
                                icon: note.attributes.isFavourite
                                    ? Icon(
                                        Icons.favorite,
                                      )
                                    : Icon(Icons.favorite_border),
                              ),
                              note.attributes.requireMasterPassword
                                  ? Icon(
                                      Icons.lock,
                                    )
                                  : Container()
                            ],
                          ),
                        ),
                        title: Text(note.title),
                        subtitle: Text(DateTimeFormatter().formatDateTime(
                            DateTime.parse(note.createdDateTime))),
                        trailing: Icon(Icons.chevron_right_sharp),
                        onTap: () {
                          if (note.attributes.requireMasterPassword) {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return ValidateMasterPassword();
                              },
                            ).then((value) {
                              if (value == true) {
                                setState(() {
                                  selectedNote = note;
                                });
                              }
                            });
                          } else {
                            setState(() {
                              selectedNote = note;
                            });
                          }
                        },
                      );
                    }).toList(),
                  ),
                )
              ],
            ),
          ),
          selectedNote != null
              ? Expanded(
                  child: FutureBuilder(
                  future: getContent(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: double.infinity,
                              child: ListTile(
                                title: Text(selectedNote!.title,
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                subtitle: Text(
                                  DateTimeFormatter().formatDateTime(
                                    DateTime.parse(
                                      selectedNote!.createdDateTime,
                                    ),
                                  ),
                                ),
                                trailing: SizedBox(
                                  width: 120,
                                  child: Row(
                                    children: [
                                      IconButton(
                                        onPressed: () {
                                          if (selectedNote!.attributes
                                              .requireMasterPassword) {
                                            showDialog(
                                              context: context,
                                              builder: (context) {
                                                return ValidateMasterPassword();
                                              },
                                            ).then((value) {
                                              if (value == true) {
                                                if (context.mounted) {
                                                  Navigator.of(context)
                                                      .push(
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          EditNotePage(
                                                              noteToEdit:
                                                                  selectedNote!),
                                                    ),
                                                  )
                                                      .then((_) {
                                                    selectedNote = null;
                                                    getAllNotes();
                                                  });
                                                }
                                              }
                                            });
                                          } else {
                                            Navigator.of(context)
                                                .push(
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    EditNotePage(
                                                        noteToEdit:
                                                            selectedNote!),
                                              ),
                                            )
                                                .then((_) {
                                              setState(() {
                                                selectedNote = null;
                                                getAllNotes();
                                              });
                                            });
                                          }
                                        },
                                        icon: Icon(Icons.edit),
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          if (selectedNote!.attributes
                                              .requireMasterPassword) {
                                            showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return ValidateMasterPassword();
                                                }).then((value) {
                                              if (value == true) {
                                                deleteNote(selectedNote!);
                                              }
                                            });
                                          } else {
                                            deleteNote(selectedNote!);
                                          }
                                        },
                                        icon: Icon(Icons.delete),
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          setState(() {
                                            selectedNote = null;
                                          });
                                        },
                                        icon: Icon(
                                          Icons.close,
                                          color: Theme.of(context).textTheme.bodyMedium?.color,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Divider(
                              color: Theme.of(context).primaryColor,
                            ),
                            Expanded(
                              child: SingleChildScrollView(
                                child: Text(snapshot.data!),
                              ),
                            ),
                          ],
                        ),
                      );
                    } else {
                      return Center(child: CircularProgressIndicator());
                    }
                  },
                ))
              : Container()
        ],
      ),
    );
  }
}

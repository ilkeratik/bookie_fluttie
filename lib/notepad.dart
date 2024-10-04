import 'package:flutter/cupertino.dart';
import 'package:share_plus/share_plus.dart';
import 'package:uuid/uuid.dart';

import 'functions.dart';

class Notepad extends StatefulWidget {
  const Notepad({super.key});

  @override
  NotepadState createState() => NotepadState();
}

class NotepadState extends State<Notepad> with AutomaticKeepAliveClientMixin {
  var uuid = const Uuid();
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _detailsController = TextEditingController();
  List<Map<String, dynamic>> _items = [];
  bool expandNewNoteFields = false;
  bool editingEnabled = false;

  @override
  void initState() {
    super.initState();
    debugPrint('--->init state');
    loadItemsFromStorage('iky-notepad-items').then((data) => {
          if (data != null)
            {
              setState(() {
                _items = data;
              })
            }
        });
  }

  void _addItem() {
    if (_subjectController.text.isNotEmpty) {
      setState(() {
        _items.add({
          'id': uuid.v1(),
          'subject': _subjectController.text,
          'details': _detailsController.text,
          'isDone': false
        });
        _subjectController.clear();
        _detailsController.clear();
        _toggleExpandNewNoteFields();
      });
      saveItemsToStorage('iky-notepad-items', _items);
    }
  }

  void _updateItem(String id, String newSubject, String newDetails) {
    if (newSubject.isNotEmpty) {
      setState(() {
        var item = _items.firstWhere((el) => el['id'] == id, orElse: () => {});
        if (item.isNotEmpty) {
          item['subject'] = newSubject;
          item['details'] = newDetails;
        }
      });
    }
    saveItemsToStorage('iky-notepad-items', _items);
  }

  void _removeItem(String id) {
    setState(() {
      var item = _items.firstWhere((el) => el['id'] == id, orElse: () => {});
      if (item.isNotEmpty) {
        _items.remove(item);
      }
    });
    saveItemsToStorage('iky-notepad-items', _items);
  }

  void _updateItemIsDone(String id, bool isDone) {
    setState(() {
      var item = _items.firstWhere((el) => el['id'] == id, orElse: () => {});
      if (item.isNotEmpty) {
        item['isDone'] = isDone;
      }
    });
    saveItemsToStorage('iky-notepad-items', _items);
  }

  void _navigateToDetail(BuildContext context, dynamic item) {
    Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) =>
            DetailView(item: item, removeItem: _removeItem, save: _updateItem),
      ),
    );
  }

  void _toggleExpandNewNoteFields() {
    setState(() {
      expandNewNoteFields = !expandNewNoteFields;
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.tertiarySystemBackground,
      navigationBar: const CupertinoNavigationBar(
        backgroundColor: CupertinoColors.secondarySystemBackground,
        middle: Text('Note'),
      ),
      child: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: _items.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: const EdgeInsets.symmetric(vertical: 5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: CupertinoColors.secondarySystemBackground,
                      ),
                      child: GestureDetector(
                        onLongPress: () => _updateItemIsDone(
                            _items[index]['id'], !_items[index]['isDone']),
                        child: CupertinoListTile(
                          padding: const EdgeInsets.all(25),
                          leadingSize: 10,
                          leadingToTitle: 24,
                          leading: Transform.scale(
                            scale: 1.8,
                            child: CupertinoCheckbox(
                              value: _items[index]['isDone'],
                              onChanged: (bool? newValue) {
                                _updateItemIsDone(
                                    _items[index]['id'], newValue!);
                              },
                              side: const BorderSide(
                                  width: 0.4,
                                  color: CupertinoColors.systemGrey3),
                              activeColor: CupertinoColors.activeGreen,
                              inactiveColor: CupertinoColors.secondaryLabel,
                            ),
                          ),
                          title: Row(
                            children: [
                              Text(
                                _items[index]['subject'].length > 30
                                    ? '${_items[index]['subject'].substring(0, 27)}...'
                                    : _items[index]['subject'],
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          onTap: () =>
                              _navigateToDetail(context, _items[index]),
                        ),
                      ),
                    );
                  },
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: CupertinoColors.secondarySystemBackground,
                ),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 2),
                  child: Column(
                    children: [
                      if (expandNewNoteFields) ...[
                        CupertinoTextFormFieldRow(
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: CupertinoColors.systemGrey, width: .3),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          prefix: const Padding(
                            padding: EdgeInsets.only(right: 10.0),
                            child: Text('Subject'),
                          ),
                          maxLines: 1,
                          placeholder: 'Enter subject',
                          controller: _subjectController,
                        ),
                        const SizedBox(height: 20),
                        CupertinoTextFormFieldRow(
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: CupertinoColors.systemGrey, width: .3),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          prefix: const Padding(
                            padding: EdgeInsets.only(right: 16.0),
                            child: Text('Details'),
                          ),
                          maxLines: 4,
                          placeholder: 'Enter details',
                          controller: _detailsController,
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CupertinoButton(
                              color: CupertinoColors.activeBlue,
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 60),
                              onPressed: _addItem,
                              child: const Text(
                                'Add Note',
                                style: TextStyle(fontSize: 15),
                              ),
                            ),
                            const SizedBox(width: 8),
                            CupertinoButton(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 40),
                              color: CupertinoColors.systemGrey,
                              onPressed: _toggleExpandNewNoteFields,
                              child: const Text(
                                'Cancel',
                                style: TextStyle(fontSize: 15),
                              ),
                            ),
                          ],
                        )
                      ] else
                        CupertinoButton(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 50),
                          onPressed: _toggleExpandNewNoteFields,
                          child: const Icon(CupertinoIcons.add),
                        )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class DetailView extends StatefulWidget {
  final dynamic item;

  final dynamic removeItem;

  final dynamic save;

  const DetailView(
      {super.key,
      required this.item,
      required this.removeItem,
      required this.save});
  @override
  _DetailViewState createState() => _DetailViewState();
}

class _DetailViewState extends State<DetailView> {
  bool editingEnabled = false;
  late final void Function(String, String, String) save;

  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _detailsController = TextEditingController();

  void _toggleEditingEnabled() {
    setState(() {
      editingEnabled = !editingEnabled;
    });
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.item;
    final removeItem = widget.removeItem;
    final save = widget.save;

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        backgroundColor: CupertinoColors.secondarySystemBackground,
        middle: Text(item['subject'].length > 30
            ? '${item['subject'].substring(0, 27)}...'
            : item['subject'] ?? ''),
      ),
      child: CupertinoScrollbar(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: CupertinoColors.secondarySystemBackground,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (editingEnabled) ...[
                  CupertinoTextFormFieldRow(
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: CupertinoColors.systemGrey, width: .3),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    prefix: const Padding(
                      padding: EdgeInsets.only(right: 10.0),
                      child: Text('Subject'),
                    ),
                    maxLines: 1,
                    controller: _subjectController,
                  ),
                  const SizedBox(height: 20),
                  CupertinoTextFormFieldRow(
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: CupertinoColors.systemGrey, width: .3),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    prefix: const Padding(
                      padding: EdgeInsets.only(right: 16.0),
                      child: Text('Details'),
                    ),
                    maxLines: 7,
                    placeholder: 'Enter details',
                    controller: _detailsController,
                  ),
                ] else ...[
                  Text(
                    item['subject'],
                    style: const TextStyle(
                        fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    item['details'],
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.w300),
                  )
                ],
                const SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    CupertinoButton.filled(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 50),
                      onPressed: () => editingEnabled
                          ? {
                              save(item['id'], _subjectController.text,
                                  _detailsController.text),
                              _toggleEditingEnabled()
                            }
                          : {
                              _subjectController.text = item['subject'],
                              _detailsController.text = item['details'],
                              _toggleEditingEnabled()
                            },
                      child: Text(
                        editingEnabled ? 'Save' : 'Edit',
                        style: TextStyle(fontSize: 15),
                      ),
                    ),
                    const SizedBox(width: 12),
                    CupertinoButton(
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                      color: const Color.fromARGB(255, 220, 54, 45),
                      onPressed: () {
                        removeItem(item['id']);
                        Navigator.pop(context);
                      },
                      child:
                          const Text('Delete', style: TextStyle(fontSize: 15)),
                    ),
                    const SizedBox(width: 12),
                    CupertinoButton(
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                      color: const Color.fromARGB(255, 86, 24, 144),
                      onPressed: () => {
                        Share.share(
                            'Subject: ${item['subject']}\nDetails:  ${item['details']}')
                      },
                      child:
                          const Text('Share', style: TextStyle(fontSize: 15)),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: CupertinoButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Back', style: TextStyle(fontSize: 15)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

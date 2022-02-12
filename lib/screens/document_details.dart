import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:parichaya_frontend/screens/page_not_found.dart';
import 'package:parichaya_frontend/widgets/options_modal_buttom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';

import '../providers/documents.dart';
import '../utils/string.dart';
import './edit_document.dart';
import './full_screen_image.dart';

enum selectionValue {
  edit,
  delete,
}

class DocumentDetails extends StatefulWidget {
  const DocumentDetails({Key? key}) : super(key: key);

  static const routeName = '/document_details';

  @override
  State<DocumentDetails> createState() => _DocumentDetailsState();
}

class _DocumentDetailsState extends State<DocumentDetails> {
  Future<void> pickImage(
      BuildContext context, ImageSource source, int documentId) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      log(documentId.toString());
      if (image == null) return;
      Provider.of<Documents>(context, listen: false)
          .addDocumentImage(documentId, image.path);
      const snackBar = SnackBar(content: Text('Image Successfully Added'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } on PlatformException catch (_) {
      return;
    }
  }

  Future<bool> showDeleteConfirmationDialog() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Are you sure?"),
          content: const Text(
            "Deleting the document will delete all the images in it and cannot be undone.",
          ),
          actions: [
            TextButton(
              child: const Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            TextButton(
              child: const Text("Continue"),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    );

    if (result == null) {
      return false;
    }
    return result;
  }

  void showOptions(
    BuildContext context,
    int documentId,
  ) {
    showOptionsModalButtomSheet(
      context,
      children: [
        const Text('Select Actions'),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.edit),
          title: const Text('Edit Document'),
          onTap: () {
            Navigator.of(context)
                .popAndPushNamed(EditDocument.routeName, arguments: documentId);
            // Navigator.of(context).pop();
          },
        ),
        ListTile(
          leading: const Icon(Icons.delete),
          title: const Text('Delete Document'),
          onTap: () async {
            Navigator.of(context).pop();
            final isConfirmed = await showDeleteConfirmationDialog();
            if (isConfirmed) {
              Navigator.of(context).pop();
              Provider.of<Documents>(context, listen: false)
                  .deleteDocument(documentId);
              const snackBar =
                  SnackBar(content: Text('Document Deleted Successfully'));
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            }

            // Navigator.popUntil(
            //   context,
            //   ModalRoute.withName('/'),
            // );
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final routeDocumentId = ModalRoute.of(context)?.settings.arguments as int;
    log('Document id received through router' + routeDocumentId.toString());

    final documentsProvider = Provider.of<Documents>(
      context,
    );
    if (!documentsProvider.checkIfDocumentExists(routeDocumentId)) {
      return const PageNotFound();
    }

    final document = documentsProvider.getDocumentById(routeDocumentId);

    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Theme.of(context).primaryColor),
        title: Text(
          generateLimitedLengthText(document.title, 25),
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        actions: [
          IconButton(
              onPressed: () {
                showOptions(
                  context,
                  document.id,
                );
                // showModalBottomSheet<void>(
                //   isScrollControlled: true,
                //   context: context,
                //   shape: const RoundedRectangleBorder(
                //     borderRadius: BorderRadius.only(
                //         topLeft: Radius.circular(10),
                //         topRight: Radius.circular(10)),
                //   ),
                //   builder: (BuildContext context) {
                //     return Padding(
                //       padding: MediaQuery.of(context).viewInsets,
                //       child: Container(
                //         padding: const EdgeInsets.all(20),
                //         child: Wrap(
                //           children: [
                //             const Text('Select Actions'),
                //             const Divider(),
                //             ListTile(
                //               leading: const Icon(Icons.edit),
                //               title: const Text('Edit Document'),
                //               onTap: () {
                //                 Navigator.of(context).popAndPushNamed(
                //                     EditDocument.routeName,
                //                     arguments: document.id);
                //               },
                //             ),
                //             ListTile(
                //               leading: const Icon(Icons.delete),
                //               title: const Text('Delete Document'),
                //               onTap: () {
                //                 Navigator.of(context).pop();
                //                 showDialog(
                //                   context: context,
                //                   builder: (BuildContext context) {
                //                     return AlertDialog(
                //                       title: const Text("Are you sure?"),
                //                       content: const Text(
                //                         "Deleting the document will delete all the images in it and cannot be undone.",
                //                       ),
                //                       actions: [
                //                         TextButton(
                //                           child: const Text("Cancel"),
                //                           onPressed: () {
                //                             Navigator.of(context).pop();
                //                           },
                //                         ),
                //                         TextButton(
                //                           child: const Text("Continue"),
                //                           onPressed: () {
                //                             Navigator.popUntil(
                //                               context,
                //                               ModalRoute.withName('/'),
                //                             );
                //                             Provider.of<Documents>(context)
                //                                 .deleteDocument(document.id,
                //                                     notify: false);
                //                             const snackBar = SnackBar(
                //                                 content: Text(
                //                                     'Document Deleted Successfully'));
                //                             ScaffoldMessenger.of(context)
                //                                 .showSnackBar(snackBar);
                //                           },
                //                         ),
                //                       ],
                //                     );
                //                   },
                //                 );
                //               },
                //             ),
                //           ],
                //         ),
                //       ),
                //     );
                //   },
                // );
              },
              icon: const Icon(Icons.more_vert)),
        ],
      ),
      body: LayoutBuilder(builder: (ctx, constraints) {
        return SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  document.title,
                  style: Theme.of(context).textTheme.headline3,
                ),
                Text(document.images.length.toString()),
                const SizedBox(
                  height: 10,
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  document.note,
                  style: Theme.of(context).textTheme.bodyText1,
                ),
                const SizedBox(
                  height: 10,
                ),
                Column(
                  children: [
                    ...document.images.map((image) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: GestureDetector(
                          child: Image.file(
                            File(image.path),
                            height: 200,
                            width: 200,
                            fit: BoxFit.cover,
                          ),
                          onTap: () {
                            Navigator.of(context).pushNamed(
                                FullScreenImage.routeName,
                                arguments: image);
                          },
                        ),
                      );
                    }).toList(),
                  ],
                ),
                // for (var image in document.images)
              ],
            ),
          ),
        );
      }),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add_photo_alternate_rounded),
        tooltip: 'Add Image',
        elevation: 2,
        onPressed: () {
          showModalBottomSheet<void>(
            isScrollControlled: true,
            context: context,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10), topRight: Radius.circular(10)),
            ),
            builder: (BuildContext context) {
              return Padding(
                padding: MediaQuery.of(context).viewInsets,
                child: Container(
                  padding: const EdgeInsets.all(20),
                  child: Wrap(
                    children: [
                      const Text('Select Actions'),
                      const Divider(),
                      ListTile(
                        leading: const Icon(Icons.file_upload_rounded),
                        title: const Text('Upload Image'),
                        onTap: () {
                          Navigator.of(context).pop();
                          pickImage(context, ImageSource.gallery, document.id);
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.camera_alt_rounded),
                        title: const Text('Take a Photo'),
                        onTap: () {
                          pickImage(context, ImageSource.camera, document.id);
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}

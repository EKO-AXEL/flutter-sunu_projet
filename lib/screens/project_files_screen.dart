import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import '../config/constants_colors.dart';
import '../config/size_config.dart';
import 'package:url_launcher/url_launcher.dart';


class FilesTab extends StatefulWidget {
  final String projectId;

  const FilesTab({super.key, required this.projectId});

  @override
  State<FilesTab> createState() => _FilesTabState();
}

class _FilesTabState extends State<FilesTab> {
  Future<void> _uploadFile() async {
    // Sélectionner un fichier
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'jpg', 'png'],
    );

    if (result != null && result.files.single.path != null) {
      final file = result.files.single;
      final fileName = file.name;
      final filePath = file.path!;

      try {
        // Télécharger dans Firebase Storage
        final storageRef = FirebaseStorage.instance
            .ref()
            .child('projects/${widget.projectId}/files/$fileName');
        await storageRef.putFile(File(filePath));

        // Récupérer l'URL de téléchargement
        final downloadUrl = await storageRef.getDownloadURL();

        // Enregistrer les métadonnées dans Firestore
        await FirebaseFirestore.instance
            .collection('projects')
            .doc(widget.projectId)
            .collection('files')
            .add({
          'name': fileName,
          'url': downloadUrl,
          'uploadedAt': FieldValue.serverTimestamp(),
          'size': file.size,
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Fichier téléchargé avec succès")),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Erreur lors du téléchargement : $e")),
        );
      }
    }
  }

  Future<void> _previewFile(String url, String name) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Impossible d'ouvrir le fichier")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(SizeConfig.getProportinateScreenWidth(5)),
          child: ElevatedButton(
            onPressed: _uploadFile,
            style: ElevatedButton.styleFrom(
              backgroundColor: kPrimaryColor,
              padding: EdgeInsets.symmetric(
                vertical: SizeConfig.getProportinateScreenheight(5),
                horizontal: SizeConfig.getProportinateScreenWidth(120),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              "Ajouter un fichier",
              style: TextStyle(fontSize: 13, color: Colors.white),
            ),
          ),
        ),
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('projects')
                .doc(widget.projectId)
                .collection('files')
                .orderBy('uploadedAt', descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Center(
                  child: Text("Aucun fichier trouvé"),
                );
              }

              final files = snapshot.data!.docs;

              return ListView.builder(
                padding: EdgeInsets.symmetric(
                  horizontal: SizeConfig.getProportinateScreenWidth(16),
                ),
                itemCount: files.length,
                itemBuilder: (context, index) {
                  final file = files[index];
                  final name = file['name'] as String;
                  final url = file['url'] as String;
                  final size = file['size'] as int;
                  final uploadedAt =
                  (file['uploadedAt'] as Timestamp?)?.toDate();

                  return Card(
                    elevation: 2,
                    margin: EdgeInsets.symmetric(
                      vertical: SizeConfig.getProportinateScreenheight(8),
                    ),
                    child: ListTile(
                      leading: Icon(
                        name.endsWith('.pdf')
                            ? Icons.picture_as_pdf
                            : Icons.image,
                        color: kPrimaryColor,
                      ),
                      title: Text(name),
                      subtitle: Text(
                        "Taille: ${(size / 1024).toStringAsFixed(2)} KB\n"
                            "Ajouté le: ${uploadedAt != null ? "${uploadedAt.day}/${uploadedAt.month}/${uploadedAt.year}" : "Inconnu"}",
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.visibility),
                        onPressed: () => _previewFile(url, name),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
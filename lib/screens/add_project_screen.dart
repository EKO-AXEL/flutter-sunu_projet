import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sunu_projet/config/constants_colors.dart';
import 'package:sunu_projet/config/size_config.dart';
import 'package:sunu_projet/providers/project/project_service.dart';
import 'package:sunu_projet/screens/project_screen.dart';
import '../config/inputs_fields.dart'; // Assurez-vous que le chemin est correct

class AddProjectScreenState extends StatefulWidget {
  const AddProjectScreenState({super.key});

  @override
  State<AddProjectScreenState> createState() => _AddProjectScreenState();
}

class _AddProjectScreenState extends State<AddProjectScreenState> {
  final _formKey = GlobalKey<FormState>();
  String _selectedOption = '';
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();
  // Liste des options priorite
  final List<String> _options = ["Basse", "Moyenne", "Haute", "Urgente"];

  DateTime? _startDate;
  DateTime? _endDate;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _startDateController.dispose();
    _endDateController.dispose();
    super.dispose();
  }

  DateTime parseCustomDate(String dateString) {
    final parts = dateString.split('/');
    if (parts.length == 3) {
      final day = int.parse(parts[0]);
      final month = int.parse(parts[1]);
      final year = int.parse(parts[2]);
      return DateTime(year, month, day);
    }
    throw FormatException('Invalid date format: $dateString');
  }

  @override
  Widget build(BuildContext context) {
    final firestoreProvider = Provider.of<ProjectService>(context);
    SizeConfig.init(context); // Initialisation de SizeConfig
    return Scaffold(
      appBar: AppBar(
        title: const Text("Créer un projet"),
        backgroundColor: kPrimaryColor,
      ),
      backgroundColor: Colors.blueGrey[50],
      body: Padding(
        padding: EdgeInsets.all(SizeConfig.getProportinateScreenWidth(16)),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Titre du projet
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(9),
                  ),
                  child: CustomInput(
                    controller: _titleController,
                    labelText: "Titre du projet",
                    hintLabel: "Entrez le titre du projet",
                    isRequired: true,
                    prefixIcon: Icons.title,
                    validator: (value) {
                      if (value!.length < 3) {
                        return "Le titre doit contenir au moins 3 caractères";
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(height: SizeConfig.getProportinateScreenheight(5)),

                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(9),
                  ),
                  child: CustomInput(
                    controller: _descriptionController,
                    labelText: "Description",
                    hintLabel: "Entrez une description",
                    maxLines: 3,
                    isRequired: false,
                    prefixIcon: Icons.description,
                  ),
                ),

                SizedBox(height: SizeConfig.getProportinateScreenheight(10)),

                // Date du projet
                Text(
                  'Date du projet',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Row(
                  children: [
                    // Champ de date de début
                    Expanded(
                      child: CustomInput(
                        controller: _startDateController,
                        labelText: "Date de debut",
                        isDateField: true,
                        isRequired: true,
                        onDateSelected: (date) {
                          setState(() {
                            _startDate = date;
                          });
                        },
                        validator: (value) {
                          if (_startDate != null && _endDate != null) {
                            if (_endDate!.isBefore(_startDate!)) {
                              return "La date de debut doit être avant la date de fin";
                            }
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(width: 3),
                    Expanded(
                      child: CustomInput(
                        controller: _endDateController,
                        labelText: "Date de fin",
                        isDateField: true,
                        isRequired: true,
                        onDateSelected: (date) {
                          setState(() {
                            _endDate = date;
                          });
                        },
                        validator: (value) {
                          if (_startDate != null && _endDate != null) {
                            if (_endDate!.isBefore(_startDate!)) {
                              return "La date de fin doit être après la date de début";
                            }
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),

                SizedBox(height: SizeConfig.getProportinateScreenheight(5)),

                // Priorité
                Text(
                  'Priorité',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(9),
                  ),
                  child: Column(
                    children: [
                      SizedBox(height: 10),
                      // Liste des boutons radio
                      ..._options.map((option) {
                        return RadioListTile<String>(
                          title: Text(option),
                          value: option,
                          groupValue: _selectedOption,
                          onChanged: (value) {
                            setState(() {
                              _selectedOption = value!; // Mettre à jour la sélection
                            });
                          },
                        );
                      }).toList(),
                    ],
                  )
                ),
                SizedBox(height: SizeConfig.getProportinateScreenheight(16)),

                // Bouton de soumission
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        try {

                          DateTime startDate = parseCustomDate(_startDateController.text);
                          DateTime endDate = parseCustomDate(_endDateController.text);
                          // Logique pour enregistrer le projet (ex. Firebase)
                          await firestoreProvider.addProject({
                            'title': _titleController.text,
                            'description': _descriptionController.text,
                            'start_date': startDate,
                            'end_date': endDate,
                            'priority': _selectedOption,
                            'status': 'En attente',
                          });

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Projet créé avec succès !")),
                          );

                          // Réinitialiser le formulaire après soumission
                          _formKey.currentState!.reset();
                          _startDate = null;
                          _endDate = null;

                          // Naviguer après la sauvegarde
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProjectListScreen(),
                            ),
                          );
                        } catch (e) {
                          // Afficher une erreur si la sauvegarde échoue
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Erreur lors de la création du projet : $e")),
                          );
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kPrimaryColor,
                      padding: EdgeInsets.symmetric(
                        vertical: SizeConfig.getProportinateScreenheight(5),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(9),
                      ),
                    ),
                    child: const Text(
                      "Créer le projet",
                      style: TextStyle(fontSize: 18, color: Colors.white),
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
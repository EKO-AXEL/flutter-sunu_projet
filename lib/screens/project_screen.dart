import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sunu_projet/config/constants_colors.dart';
import 'package:sunu_projet/config/size_config.dart';

import 'add_project_screen.dart'; // Pour naviguer vers la création

class ProjectListScreen extends StatefulWidget {
  const ProjectListScreen({super.key});

  @override
  State<ProjectListScreen> createState() => _ProjectListScreenState();
}

class _ProjectListScreenState extends State<ProjectListScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
  // Contenu à afficher en fonction de l'onglet sélectionné
  final List<Widget> _pages = [
    Center(child: Text('Page Accueil')),
    Center(child: Text('Page Profil')),
    Center(child: Text('Page Paramètres')),
  ];

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);


    return Scaffold(
      appBar: AppBar(
        title: const Text("SunuProjet"),
        backgroundColor: kPrimaryColor,
      ),
      body: Column(
        children: [
          Container(
            color: Colors.blue, // Couleur de fond du menu
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildMenuButton('En attente', 0),
                  _buildMenuButton('En cours', 1),
                  _buildMenuButton('Terminés', 2),
                  _buildMenuButton('Annulés', 3),
                ],
              ),
            ),
          // Barre de recherche
          Padding(
            padding: EdgeInsets.all(SizeConfig.getProportinateScreenWidth(16)),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: "Rechercher un projet...",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(9),
                  borderSide: const BorderSide(color: kGrayColor),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: const BorderSide(color: kPrimaryColor),
                ),
              ),
            ),
          ),
          // Liste des projets
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('projects')
                  .orderBy('createdAt', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.folder_outlined,
                          size: 60,
                          color: kGrayColor,
                        ),
                        Text(
                          "Aucun projet trouvé",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 18,
                              color: kDarkColor,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                        Text(
                          "Créez un nouveau projet pour commencer",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 13, color: kGrayColor),
                        ),
                      ],
                    ),
                  );
                }


                final projects = snapshot.data!.docs.where((doc) {
                  final title = doc['title'].toString().toLowerCase();
                  final description =
                      doc['description']?.toString().toLowerCase() ?? '';
                  return title.contains(_searchQuery) ||
                      description.contains(_searchQuery);
                }).toList();

                return ListView.builder(
                  padding: EdgeInsets.symmetric(
                    horizontal: SizeConfig.getProportinateScreenWidth(16),
                  ),
                  itemCount: projects.length,
                  itemBuilder: (context, index) {
                    final project = projects[index];
                    final title = project['title'] as String;
                    final description = project['description'] as String? ?? '';
                    final priority = project['priority'] as String;
                    final status = project['status'] as String;
                    final startDate =
                    (project['startDate'] as Timestamp?)?.toDate();
                    final endDate = (project['endDate'] as Timestamp?)?.toDate();

                    return ProjectCard(
                      title: title,
                      description: description,
                      priority: priority,
                      status: status,
                      startDate: startDate,
                      endDate: endDate,
                    );
                  },
                );
              },
            ),
          ),
          Container(
            color: Colors.white,
              child: Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: FloatingActionButton(
                  backgroundColor: kPrimaryColor,
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const AddProjectScreenState()),
                        );
                      },
                    child: Icon(
                        Icons.add,
                      color: kWhiteColor,
                    ),
                  ),
                ),
              ),
          ),
        ],
      ),
    );
  }

  // Méthode pour créer un bouton du menu
  Widget _buildMenuButton(String text, int index) {
    return TextButton(
      onPressed: () => _onItemTapped(index),
      child: Text(
        text,
        style: TextStyle(
          color: _selectedIndex == index ? Colors.white : Colors.white70, // Couleur du texte
          fontSize: 16,
        ),
      ),
    );
  }

}

// Widget pour afficher chaque projet
class ProjectCard extends StatelessWidget {
  final String title;
  final String description;
  final String priority;
  final String status;
  final DateTime? startDate;
  final DateTime? endDate;

  const ProjectCard({
    super.key,
    required this.title,
    required this.description,
    required this.priority,
    required this.status,
    this.startDate,
    this.endDate,
  });

  Color _getPriorityColor() {
    switch (priority) {
      case "Urgente":
        return Colors.red;
      case "Haute":
        return Colors.orange;
      case "Moyenne":
        return Colors.yellow;
      case "Basse":
        return Colors.green;
      default:
        return kGrayColor;
    }
  }

  Color _getStatusColor() {
    switch (status) {
      case "En attente":
        return Colors.blue;
      case "En cours":
        return Colors.orange;
      case "Terminé":
        return Colors.green;
      case "Annulé":
        return Colors.red;
      default:
        return kGrayColor;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.symmetric(
        vertical: SizeConfig.getProportinateScreenheight(8),
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(SizeConfig.getProportinateScreenWidth(16)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getPriorityColor().withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    priority,
                    style: TextStyle(
                      color: _getPriorityColor(),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: SizeConfig.getProportinateScreenheight(8)),
            Text(
              description,
              style: const TextStyle(fontSize: 14, color: kGrayColor),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: SizeConfig.getProportinateScreenheight(8)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Échéance: ${endDate != null ? "${endDate!.day}/${endDate!.month}/${endDate!.year}" : "Non défini"}",
                  style: const TextStyle(fontSize: 12),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getStatusColor().withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    status,
                    style: TextStyle(
                      color: _getStatusColor(),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
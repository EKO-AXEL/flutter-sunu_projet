import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:sunu_projet/config/constants_colors.dart';
import 'package:sunu_projet/config/size_config.dart';
import 'package:sunu_projet/providers/project/project_service.dart';
import 'package:sunu_projet/screens/project_files_screen.dart';
import 'package:sunu_projet/screens/tasksTab_screen.dart';

import 'MembersTab_screen.dart';

class ProjectOverviewScreen extends StatefulWidget {
  final String projectId; // ID du projet passé en paramètre

  const ProjectOverviewScreen({super.key, required this.projectId});

  @override
  State<ProjectOverviewScreen> createState() => _ProjectOverviewScreenState();
}

class _ProjectOverviewScreenState extends State<ProjectOverviewScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final projectService = Provider.of<ProjectService>(context);

    SizeConfig.init(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Aperçu du projet"),
        backgroundColor: kPrimaryColor,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          tabs: const [
            Tab(text: "Aperçu"),
            Tab(text: "Tâches"),
            Tab(text: "Membres"),
            Tab(text: "Fichiers"),
            // Tab(text: "Fichiers"), // Désactivé pour simplifier, peut être ajouté
          ],
        ),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: projectService.getProjectById(widget.projectId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text("Projet non trouvé"));
          }

          final project = snapshot.data!.data() as Map<String, dynamic>;
          final title = project['title'] as String;
          final description = project['description'] as String? ?? '';
          final priority = project['priority'] as String;
          final status = project['status'] as String;
          final startDate = (project['startDate'] as Timestamp?)?.toDate();
          final endDate = (project['endDate'] as Timestamp?)?.toDate();
          final progress =
              project['progress'] as int? ?? 0; // Pourcentage d'avancement

          return TabBarView(
            controller: _tabController,
            children: [
              // Onglet Aperçu
              ProjectOverviewTab(
                title: title,
                description: description,
                priority: priority,
                status: status,
                startDate: startDate,
                endDate: endDate,
                progress: progress,
                projectId: widget.projectId,
              ),
              // Onglet Tâches
              const TasksTab(),
              // Onglet Membres
              MembersTab(projectId: widget.projectId,),
              FilesTab(projectId: widget.projectId),
              // Onglet Fichiers (à implémenter si besoin)
              // const FilesTab(),
            ],
          );
        },
      ),
    );
  }
}

class ProjectOverviewTab extends StatefulWidget {
  final String title;
  final String description;
  final String priority;
  final String status;
  final DateTime? startDate;
  final DateTime? endDate;
  final int progress;
  final String projectId;

  const ProjectOverviewTab({
    super.key,
    required this.title,
    required this.description,
    required this.priority,
    required this.status,
    this.startDate,
    this.endDate,
    required this.progress,
    required this.projectId,
  });

  @override
  _ProjectOverviewTabState createState() => _ProjectOverviewTabState();
}

// Onglet Aperçu
class _ProjectOverviewTabState extends State<ProjectOverviewTab> {
  String selectedStatus = "En attente";

  @override
  void initState() {
    super.initState();
    selectedStatus = widget.status;
  }

  Color _getPriorityColor() {
    switch (widget.priority) {
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

  Color _getStatusColor(String status) {
    switch (widget.status) {
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

  void _updateStatus(BuildContext context, String newStatus) {
    final projectService = Provider.of<ProjectService>(context);
    projectService
        .updateProject(
          widget.projectId,
          {'status': newStatus} as Map<String, dynamic>,
        )
        .then((_) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Statut mis à jour : $newStatus")),
          );
        })
        .catchError((error) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text("Erreur : $error")));
        });
  }

  @override
  Widget build(BuildContext context) {
    final List<String> statusList = [
      "En attente",
      "En cours",
      "Terminé",
      "Annulé",
    ];
    String selectedStatus = "En attente";

    return SingleChildScrollView(
      padding: EdgeInsets.all(SizeConfig.getProportinateScreenWidth(16)),
      child: Column(
        children: [
          Card(
            elevation: 4,
            margin: EdgeInsets.symmetric(
              vertical: SizeConfig.getProportinateScreenheight(8),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: EdgeInsets.all(SizeConfig.getProportinateScreenWidth(7)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: _getStatusColor(widget.priority).withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          widget.status,
                          style: TextStyle(
                            color: _getStatusColor(widget.priority),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: SizeConfig.getProportinateScreenheight(5)),
                  Text(
                    "Priorité : ${widget.priority}",
                    style: TextStyle(
                      fontSize: 10,
                      color: _getPriorityColor(),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: SizeConfig.getProportinateScreenheight(5)),
                  Text(
                    "Description",
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    widget.description.isNotEmpty
                        ? widget.description
                        : "Aucune description",
                    style: const TextStyle(fontSize: 14, color: kGrayColor),
                  ),
                  SizedBox(height: SizeConfig.getProportinateScreenheight(5)),
                  Text(
                    "Dates",
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Début : ${widget.startDate != null ? "${widget.startDate!.day}/${widget.startDate!.month}/${widget.startDate!.year}" : "Non défini"}",
                        style: const TextStyle(fontSize: 10),
                      ),
                      Text(
                        "Fin : ${widget.endDate != null ? "${widget.endDate!.day}/${widget.endDate!.month}/${widget.endDate!.year}" : "Non défini"}",
                        style: const TextStyle(fontSize: 10),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Card(
            elevation: 4,
            margin: EdgeInsets.symmetric(
              vertical: SizeConfig.getProportinateScreenheight(8),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: EdgeInsets.all(SizeConfig.getProportinateScreenWidth(7)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Avancement du projet",
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Center(
                    child: SizedBox(
                      width: SizeConfig.getProportinateScreenWidth(150), // Taille du conteneur
                      height: SizeConfig.getProportinateScreenWidth(150),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Transform.scale(
                            scale: 3.5, // Facteur d'agrandissement
                            child: CircularProgressIndicator(
                              value: widget.progress / 100,
                              color: kPrimaryColor,
                              backgroundColor: kGrayColor.withOpacity(0.3),
                              strokeWidth: 4, // Épaisseur
                            ),
                          ),
                          Text(
                            "${widget.progress}%",
                            style: TextStyle(
                              fontSize: SizeConfig.getProportinateScreenWidth(40),
                              fontWeight: FontWeight.bold,
                              color: kPrimaryColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: SizeConfig.getProportinateScreenheight(2)),

                  Text(
                    "Statut",
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        height: SizeConfig.getProportinateScreenheight(8),
                      ),
                      Wrap(
                        spacing: 8, // Espacement horizontal entre les boutons
                        children:
                            statusList.map((status) {
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selectedStatus = status;
                                  });
                                  _updateStatusInFirestore(
                                    widget.projectId as BuildContext,
                                    status as String,
                                  ); // Mettre à jour Firestore
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color:
                                        selectedStatus == status
                                            ? _getStatusColor(status)
                                            : _getStatusColor(status).withOpacity(
                                              0.2,
                                            ),
                                    // Fond transparent pour les autres
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: _getStatusColor(status),
                                      width: 1,
                                    ),
                                  ),
                                  child: Text(
                                    status,
                                    style: TextStyle(
                                      color:
                                          selectedStatus == status
                                              ? Colors.white
                                              : _getStatusColor(status),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _updateStatusInFirestore(BuildContext context, String newStatus) async {
    final projectService = Provider.of<ProjectService>(context, listen: false);
    try {
      await projectService.updateProject(widget.projectId, {
        'status': newStatus,
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Statut mis à jour : $newStatus")));
    } catch (error) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Erreur : $error")));
    }
  }
}

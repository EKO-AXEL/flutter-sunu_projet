import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sunu_projet/config/constants_colors.dart';
import 'package:sunu_projet/config/size_config.dart';


import '../providers/authentification_service.dart';
import '../providers/project/project_service.dart';

class MembersTab extends StatefulWidget {
  final String projectId;

  const MembersTab({super.key, required this.projectId});

  @override
  State<MembersTab> createState() => _MembersTabState();
}

class _MembersTabState extends State<MembersTab> {
  Future<void> _addMember(BuildContext context) async {
    final authService = Provider.of<AuthenticationService>(context, listen: false);
    final projectService = Provider.of<ProjectService>(context, listen: false);
    final users = await authService.getAllUsers();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Ajouter un membre"),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];
              final email = user['email'] ?? 'Email non disponible'; // Valeur par défaut
              final role = user['role'] ?? 'Rôle non disponible'; // Valeur par défaut
              final uid = user['uid'];
              return ListTile(
                title: Text(email!),
                subtitle: Text(role!),
                onTap: () async {
                  await projectService.addMemberToProject(widget.projectId, uid);
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("$email ajouté au projet")),
                  );
                },
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Annuler"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final projectService = Provider.of<ProjectService>(context);

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(SizeConfig.getProportinateScreenWidth(5)),
          child: ElevatedButton(
            onPressed: () => _addMember(context),
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
              "Ajouter un membre",
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
          ),
        ),
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
            stream: projectService.getProjectMembers(widget.projectId),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Center(child: Text("Aucun membre dans ce projet"));
              }

              final members = snapshot.data!.docs;

              return ListView.builder(
                padding: EdgeInsets.symmetric(
                  horizontal: SizeConfig.getProportinateScreenWidth(16),
                ),
                itemCount: members.length,
                itemBuilder: (context, index) {
                  final member = members[index];
                  final userId = member['userId'] as String;

                  return FutureBuilder<DocumentSnapshot>(
                    future: FirebaseFirestore.instance.collection('users').doc(userId).get(),
                    builder: (context, userSnapshot) {
                      if (!userSnapshot.hasData) {
                        return const ListTile(
                          title: Text("Chargement..."),
                        );
                      }
                      final userData = userSnapshot.data!.data() as Map<String, dynamic>;
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor: kPrimaryColor,
                          child: Text(
                            userData['email'][0].toUpperCase(),
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                        title: Text(userData['email']),
                        subtitle: Text("Rôle : ${userData['role']}"),
                      );
                    },
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
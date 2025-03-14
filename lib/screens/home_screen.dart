import 'package:flutter/material.dart';
import 'package:sunu_projet/config/size_config.dart';
import '../config/constants_colors.dart';
import 'package:provider/provider.dart';
import '../models/my_user.dart';
import '../providers/authentification_service.dart';
import '../providers/user_service.dart';
import 'auth/login_screen.dart';


class Home extends StatefulWidget {
  final MyUserModel currentUser;
  Home({required this.currentUser, super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home>{
  int _currentIndex = 0;
  final AuthenticationService authService = AuthenticationService();

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return Consumer<AuthenticationService>(builder: (context, model, child){
      return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Accueil',
            style: TextStyle(
                fontSize: 20
            ),
          ),
          actions: [
            Icon(Icons.notifications_outlined),
          ],
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            colors: [
                              kPrimaryColor,
                              kPrimaryColor.withOpacity(0.8)
                            ]
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              spreadRadius: 7,
                              blurRadius: 8,
                              offset: Offset(0, 2)
                          )
                        ]
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Bienvenue ${widget.currentUser.nom ?? ''}',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: kWhiteColor.withValues(alpha: 0.9)
                          ),
                        ),
                        const SizedBox(height: 8,),
                        Text(
                          "Que souhaitez-vous faire aujourd'hui ?",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: kWhiteColor,
                          ),
                        ),
                        const SizedBox(height: 24,),
                        Visibility(
                          visible: model.user != null,
                          child: SizedBox(
                            width: double.infinity,
                            height: 55.0,
                            child: ElevatedButton(
                                onPressed: authService.signOut,
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: kWhiteColor,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12)
                                    )
                                ),
                                child: Text(
                                  'Se déconnecter',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                    color: kPrimaryColor,
                                  ),
                                )
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 24,),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          backgroundColor: Colors.blue,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.black,

          onTap: (index) {
            setState(() => _currentIndex = index);
            switch(index) {
              case 0:
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LoginScreen(),
                  ),
                );
              case 1:
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LoginScreen(),
                  ),
                );
            }
          },
          items: [
            BottomNavigationBarItem(label: 'Accueil', icon: Icon(Icons.home)),
            BottomNavigationBarItem(label: 'Profil', icon: Icon(Icons.person)),
            BottomNavigationBarItem(label: 'Parametres', icon: Icon(Icons.home)),
          ],
        ),
      );
    }) ;
  }

  String sayHello(int index) {
    return "Hello $index";
  }
}
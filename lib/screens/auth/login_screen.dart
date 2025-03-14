import 'package:flutter/material.dart';
import 'package:sunu_projet/config/inputs_fields.dart';
import 'package:sunu_projet/models/my_user.dart';
import 'package:sunu_projet/screens/auth/signup_screen.dart';
import 'package:sunu_projet/screens/home_screen.dart';
import '../../config/constants_colors.dart';
import '../../config/size_config.dart';
import '../../providers/authentification_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../providers/user_service.dart';
import '../project_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreen();
}

class _LoginScreen extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final AuthenticationService authService = AuthenticationService();
  final UserService userService = UserService();

  String? errorMessage = '';
  bool isLoading = false;

  _signIn() async {
    // if (FocusScope.of(context).hasFocus) FocusScope.of(context).hasFocus;
    if (_formKey.currentState!.validate()) {
      setState(() => isLoading = true);
      try {
        await authService.signInWithEmailAndPassword(
            email: _emailController.text, password: _passwordController.text);

        String? uid = authService.uid;

        // if (uid != null) {
        //   MyUserModel? userData = await userService.getUserById(uid);
        //
        //   print("Uid ID : ${userData}");
        //   if (userData != null) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => ProjectListScreen(),
              ),
            );
          // } else {
          //   setState(() {
          //     errorMessage = "Aucun utilisateur trouvé avec cet UID";
          //     isLoading = false;
          //   });
          // }
        // } else {
        //   setState(() {
        //     errorMessage = "UID de l'utilisateur non disponible";
        //     isLoading = false;
        //   });
        // }
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: const Text(
            "Vous etes connecté !",
            style: TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.bold,
            ),
          ),
          duration: Duration(seconds: 5),
          backgroundColor: kGreenColor,
        ));
      } on FirebaseAuthException catch (ex) {
        setState(() {
          isLoading = false;
          errorMessage = ex.message;
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            errorMessage!,
            style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
          ),
          duration: Duration(seconds: 5),
          backgroundColor: kErrorColor,
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Connexion'),
        actions: [
          Icon(Icons.access_time_filled),
          Icon(Icons.account_balance_wallet),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 50,
                ),
                Center(
                  child: Container(
                    height: 120,
                    width: 120,
                    decoration: BoxDecoration(
                      color: kPrimaryColor.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.lock_outline,
                      size: 50,
                      color: kPrimaryColor,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                Text(
                  'Bienvenue',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: kDarkColor,
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                Text(
                  'Connectez-vous pour continuer',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: kDarkColor,
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      SizedBox(
                        height: 20.0,
                      ),
                      CustomInput(
                        controller: _emailController,
                        labelText: "Email",
                        hintLabel: "Entrez votre email",
                        prefixIcon: Icons.email_outlined,
                        isRequired: true,
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),
                      CustomInput(
                        controller: _passwordController,
                        labelText: "Password",
                        hintLabel: "Entrez votre mot de passe",
                        prefixIcon: Icons.lock_open_outlined,
                        isRequired: true,
                        isPassword: true,
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 16.0,
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    'Mot de passe oublie ?',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: kPrimaryColor,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 24.0,
                ),
                SizedBox(
                  width: double.infinity,
                  height: 55.0,
                  child: ElevatedButton(
                      onPressed: isLoading ? null : _signIn,
                      style: ElevatedButton.styleFrom(
                          backgroundColor: kPrimaryColor,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12))),
                      child: isLoading
                          ? SizedBox(
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor:
                          AlwaysStoppedAnimation(kPrimaryColor),
                        ),
                      )
                          : Text(
                        'Se connecter',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: kWhiteColor,
                        ),
                      )),
                ),
                const SizedBox(
                  height: 24.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Vous n'avez pas de compte ?",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: kGrayColor,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => SignUpScreen(),
                          ),
                        );
                      },
                      child: Text(
                        "S'inscrire",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: kPrimaryColor,
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../config/constants_colors.dart';
import '../../config/inputs_fields.dart';
import '../../providers/authentification_service.dart';
import 'login_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final AuthenticationService authService = AuthenticationService();

  String? errorMessage = '';
  bool isLoading = false;

  _signUp() async {
    if(FocusScope.of(context).hasFocus) FocusScope.of(context).hasFocus;
    if(_formKey.currentState!.validate()){
      setState(() => isLoading = true);
      try{
        await authService.createUserWithEmailAndPassword(email: _emailController.text, password: _passwordController.text);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => LoginScreen(),
          ),
        );
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text(
                "Inscription reussi !",
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                ),
              ),
              duration: Duration(seconds: 5),
              backgroundColor: kGreenColor,
            )
        );
      }on FirebaseAuthException catch(ex) {
        setState(() {
          isLoading = false;
          errorMessage = ex.message;
        });
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                errorMessage!,
                style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.bold
                ),
              ),
              duration: Duration(seconds: 5),
              backgroundColor: kErrorColor,
            )
        );
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Inscription'),
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
                        const SizedBox(height: 40,),
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
                        const SizedBox(height: 40,),
                        Text(
                          'Créer un compte',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: kDarkColor,
                          ),
                        ),
                        const SizedBox(height: 40,),
                        Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              SizedBox(height: 20.0,),
                              CustomInput(
                                controller: _emailController,
                                labelText: "Email",
                                hintLabel: "Entrez votre email",
                                prefixIcon: Icons.email_outlined,
                                isRequired: true,
                              ),
                              const SizedBox(height: 20.0,),
                              CustomInput(
                                controller: _passwordController,
                                labelText: "Password",
                                hintLabel: "Entrez votre mot de passe",
                                prefixIcon: Icons.lock_open_outlined,
                                isRequired: true,
                                isPassword: true,
                              ),
                              const SizedBox(height: 20.0,),
                              CustomInput(
                                controller: _passwordController,
                                labelText: "Confirmer votre password",
                                hintLabel: "Confirmer le mot de passe",
                                prefixIcon: Icons.lock_open_outlined,
                                isRequired: true,
                                isPassword: true,
                              ),
                              const SizedBox(height: 24.0,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Vous avez deja un compte ?",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                      color: kGrayColor ,
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pushReplacement(
                                        MaterialPageRoute(
                                          builder: (context) => LoginScreen(),
                                        ),
                                      );
                                    },
                                    child: Text(
                                      "Connectez-vous",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14,
                                        color: kPrimaryColor,
                                      ),
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                        const SizedBox(height: 24.0,),
                        SizedBox(
                          width: double.infinity,
                          height: 55.0,
                          child: ElevatedButton(
                              onPressed: isLoading ? null : _signUp,
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: kPrimaryColor,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12)
                                  )
                              ),
                              child: isLoading
                                  ? SizedBox(
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation(
                                      kPrimaryColor
                                  ),
                                ),
                              ) : Text(
                                "S'inscrire",
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                  color: kWhiteColor,
                                ),
                              )
                          ),
                        ),
                      ],
                    )
                )
            )
        )
    );
  }
}

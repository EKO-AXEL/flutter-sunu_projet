import 'package:flutter/material.dart';
import 'package:sunu_projet/config/size_config.dart';
import 'package:sunu_projet/screens/home_screen.dart';
import 'package:sunu_projet/screens/project_screen.dart';
import '../config/costants_assets.dart';
import 'auth/login_screen.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreen();
}

class _SplashScreen extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 2),
        vsync: this
    );

    _rotationAnimation = CurvedAnimation(
        parent: _controller,
        curve: Curves.elasticInOut
    );

    _startAnimation();
  }

  void _startAnimation() {
    _controller.forward();

    _controller.addStatusListener((status) {
      if(status == AnimationStatus.completed){
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => ProjectListScreen(),
            )
        );
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: SizeConfig.orientation == Orientation.portrait
          ? SizeConfig.getProportinateScreenWidth(200)
          : SizeConfig.getProportinateScreenWidth(300),
          height: SizeConfig.orientation == Orientation.landscape
              ? SizeConfig.getProportinateScreenheight(200)
              : SizeConfig.getProportinateScreenheight(300),
          child: AnimatedBuilder(
            animation: _rotationAnimation,
            builder: (context, child) {
              return Transform.rotate(
                angle: _rotationAnimation.value * 2 * 3.14259,
                child: Image.asset(Kimagelogo),
              );
            },
          ), //
        ),
      ),
    );
  }
}
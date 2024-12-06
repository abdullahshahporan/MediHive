import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:medi_hive/UI/screens/sign_in_screen.dart';
import 'package:medi_hive/UI/utils/assets_path.dart';
import 'package:medi_hive/widgets/screen_background.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _movetonextscreen();
  }

  Future<void> _movetonextscreen() async {
    await Future.delayed(
      const Duration(
        seconds: 5,
      ),
    );
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>SignInScreen()));
    /*await AuthController.getAccessToken();

    if (AuthController.isLoggedIn()) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const MainBottomNavBarScreen(),
        ),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const SignInScreen(),
        ),
      );
    }*/
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScreenBackground(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                Assetspath.logoSVG,
                width: 120,
              ),
            ],
          ),
        ),
      ),
    );
  }
}


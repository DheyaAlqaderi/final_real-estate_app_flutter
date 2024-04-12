import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smart_real_estate/core/utils/images.dart';
import 'package:smart_real_estate/core/utils/styles.dart';
import 'package:smart_real_estate/features/auth/presentation/pages/login/login_screen.dart';
import 'package:smart_real_estate/features/auth/presentation/pages/signUp/sign_up_screen.dart';


class BothAuthScreen extends StatefulWidget {
  const BothAuthScreen({super.key});

  @override
  State<BothAuthScreen> createState() => _BothAuthScreenState();
}

class _BothAuthScreenState extends State<BothAuthScreen> {


  bool isDesign1 = true;

  void showDesign1() {
    setState(() {
      isDesign1 = true;
    });
  }

  void showDesign2() {
    setState(() {
      isDesign1 = false;
    });
  }

  @override
  Widget build(BuildContext context) {

    return  Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 270.0,
              width: double.infinity,
              child: Stack(
                children: [
                  SizedBox(
                    height: 200.0,
                    child: Stack(
                        fit: StackFit.expand,
                        children: [
                          ClipRect(
                            child: Image.asset(
                              Images.bothAuthImage,
                              fit: BoxFit.cover,
                              width: double.infinity,
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: const Color(0xFF252B5C).withOpacity(0.5),
                            ),
                          ),
                          Center(
                              child: SvgPicture.asset(
                                Images.logo,
                                width: 153.31,
                                height: 144.38,
                                color: Colors.white,
                              )
                          ),
                        ]
                    ),
                  ),
                  Positioned(
                      bottom:30,
                      left: 0,
                      right: 0,
                      child: Center(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 140.0, // Set your custom width
                                height: 54.0, // Set your custom height
                                child: ElevatedButton(
                                  onPressed: showDesign1,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: isDesign1
                                        ?const Color(0xFF1F4C6B)
                                        : Theme.of(context).cardColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0), // Corner radius
                                    ),

                                  ),
                                  child: Text(
                                    Locales.string(context, "login"),
                                    style: fontSmallBold.copyWith(color: isDesign1 ?Colors.white:const Color(0xFF1F4C6B))
                                  ),
                                ),
                              ),

                              SizedBox(
                                width: 140.0, // Set your custom width
                                height: 54.0, // Set your custom height
                                child: ElevatedButton(
                                  onPressed: showDesign2,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: isDesign1
                                        ? Theme.of(context).cardColor
                                        :const Color(0xFF1F4C6B), // Background color
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0), // Corner radius
                                    ),
                                  ),
                                  child: Text(
                                    Locales.string(context, "create_account"),
                                    textAlign: TextAlign.center,
                                    style: fontSmallBold.copyWith(color: isDesign1 ?const Color(0xFF1F4C6B): Colors.white,)
                                  ),
                                ),
                              ),
                            ],
                          )
                      )
                  )
                ],
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                isDesign1
                    ?  const LoginScreen()
                    :  const SignUpScreen(),
              ],
            )
          ],
        ),
      ),
    );
  }
}
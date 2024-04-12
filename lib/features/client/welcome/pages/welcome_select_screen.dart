import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:smart_real_estate/core/helper/local_data/shared_pref.dart';
import 'package:smart_real_estate/core/utils/images.dart';
import 'package:smart_real_estate/core/utils/styles.dart';
import 'package:smart_real_estate/features/auth/presentation/pages/both_auth_screen.dart';
import 'package:smart_real_estate/features/client/root/pages/root_screen.dart';

class WelcomeSelectScreen extends StatefulWidget {
  const WelcomeSelectScreen({super.key});

  @override
  State<WelcomeSelectScreen> createState() => _WelcomeSelectScreenState();
}

class _WelcomeSelectScreenState extends State<WelcomeSelectScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SvgPicture.asset(
              Images.welcomeSelectClient,
              fit: BoxFit.fitWidth,
              height: 175,
              width: double.infinity,
            ),
            const Padding(padding: EdgeInsets.all(10)),
             Text(
              Locales.string(context, "welcome"),
              textAlign: TextAlign.center,
              style: fontLargeBold,
            ),
            Text(
              Locales.string(context, "welcome"),
              textAlign: TextAlign.center,
              style: fontMedium
            ),
            const Padding(padding: EdgeInsets.all(10)),
            SizedBox(
              width: 223,
              height: 210,
              child: SvgPicture.asset(Images.logo, fit: BoxFit.cover, color: Theme.of(context).primaryColor,),
            ),

            const Padding(padding: EdgeInsets.all(9.5)),


            Container(
              margin: const EdgeInsets.all(5.0),
              width: double.infinity,
              height: 58,
              child: ElevatedButton(
                onPressed: () async{
                  final checkIfFirstTime = await SharedPrefManager.getData("FirstTime");
                  if(checkIfFirstTime == null) {
                    await SharedPrefManager.saveData("FirstTime", "yes");
                  }
                  Navigator.pushReplacement(
                      context, MaterialPageRoute(builder: (context) => const BothAuthScreen()));
                },
                child: Text(
                  Locales.string(context, "join_as_client"),
                  textAlign: TextAlign.center,
                  style: fontMedium
                ),
              ),
            ),



            Container(
              margin: const EdgeInsets.all(5.0),
              width: double.infinity,
              height: 58,
              child: OutlinedButton(
                onPressed: () async {
                  await SharedPrefManager.saveData("FirstTime", "yes");
                  Navigator.pushReplacement(
                      context, MaterialPageRoute(builder: (context) => const RootScreen()));
                },
                child: Text(
                  Locales.string(context, "join_as_owner"),
                  textAlign: TextAlign.center,
                  style: fontMedium
                ),
              ),
            ),

            const Padding(padding: EdgeInsets.all(9.5)),

          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:flutter_svg/svg.dart';
import 'package:smart_real_estate/core/constant/app_constants.dart';
import 'package:smart_real_estate/core/helper/SRValidator.dart';
import 'package:smart_real_estate/core/utils/images.dart';
import 'package:smart_real_estate/core/utils/styles.dart';
import 'package:smart_real_estate/features/auth/presentation/widget/custom_field_widget.dart';
import 'package:smart_real_estate/owner/owner_root_screen/presentation/pages/owner_root_screen.dart';

import '../../../../../core/helper/local_data/shared_pref.dart';
import '../../../../client/root/pages/root_screen.dart';
import '../../cubit/login/login_cubit.dart';
import '../../cubit/login/login_state.dart';



final formKey = GlobalKey<FormState>();

class LoginScreen extends StatefulWidget {
  const LoginScreen({
    super.key, required this.isOwner,
  });
  final bool isOwner;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final rememberMe = false;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  // _handleGoogleBtnClick(){
  //   signInWithGoogle().then((user) {
  //
  //     Navigator.pushReplacement(
  //         context, MaterialPageRoute(builder: (context) => const RootPage()));
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    final loginCubit = context.read<LoginCubit>();
    return Container(
      width: double.infinity,
      color: Theme.of(context).colorScheme.background,
      child: Column(
        children: [
          Form(
            key: formKey,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  CustomTextFieldWidget(
                    isPassword: false,
                    isPhone: false,
                    name: Locales.string(context, "email"),
                    controller: emailController,
                    hintText: Locales.string(context, "write_email"),
                    textInputType: TextInputType.emailAddress,
                    validator: SRValidator.validateEmail,
                  ),
                  const SizedBox(height: 20),
                  CustomTextFieldWidget(
                    isPassword: true,
                    isPhone: false,
                    name: Locales.string(context, "password"),
                    controller: passwordController,
                    hintText: Locales.string(context, "password"),
                    validator: (password) => (password!.isEmpty)? 'please fill the password': null,
                  ),
                  const SizedBox(height: 10.0),
                  BlocListener<LoginCubit, LoginState>(
                    listener: (context, state) {
                      if (state is LoginSuccess) {
                        // Navigate to the next screen or perform any other action on login success
                        final response = state.response;
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Logged in successfully! User ID: ${response.userId}'),
                            backgroundColor: Colors.green,
                          ),
                        );
                        SharedPrefManager.saveData(AppConstants.token, response.token.toString());
                        SharedPrefManager.saveData(AppConstants.userId, response.userId.toString());
                        SharedPrefManager.saveData(AppConstants.userType, widget.isOwner?AppConstants.promoter:AppConstants.customer);

                        if(!widget.isOwner){
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const RootScreen()));
                        } else{
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const OwnerRootScreen()));
                        }

                      } else if (state is LoginFailure) {
                        // Show error message on login failure
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Login failed: ${state.error}'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    },
                    child: BlocBuilder<LoginCubit, LoginState>(
                      builder: (context, state) {
                        if (state is LoginLoading) {
                          return Container(
                            margin: const EdgeInsets.all(5.0),
                            width: double.infinity,
                            height: 58,
                            child: const Center(
                              child: CircularProgressIndicator(),
                            ),
                          );
                        } else {
                          return Container(
                            margin: const EdgeInsets.all(5.0),
                            width: double.infinity,
                            height: 58,
                            child: ElevatedButton(
                              onPressed: () async{
                                // Sign in button
                                if(formKey.currentState!.validate()){
                                  final email = emailController.text;
                                  final password = passwordController.text;
                                  await loginCubit.login(email, password);

                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF1F4C6B),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                ),
                              ),
                              child:  Text(
                                  Locales.string(context, "login"),
                                  style: fontMediumBold
                              ),
                            ),
                          );
                        }
                      },
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  InkWell(
                    onTap: (){

                    },
                    child: Text(
                      Locales.string(context, "did_forgot_password"),
                      style: fontSmallBold,

                    ),
                  ),
                  const SizedBox(height: 20.0),
                  InkWell(
                    onTap: (){
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const RootScreen()));
                    },
                    child: const Text(
                      "الدخول كازائر   ",
                      style: fontMediumBold,

                    ),
                  ),
                  const SizedBox(height: 30.0),
                  Text(
                    Locales.string(context, "or"),
                    style: fontSmallBold
                  ),
                  const SizedBox(height: 10.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      InkWell(
                        onTap: (){
                          // _handleGoogleBtnClick();
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            width: 158.50,
                            height: 70,
                            padding: const EdgeInsets.only(top: 22, bottom: 23),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              color: Theme.of(context).cardColor,
                              boxShadow: [
                                BoxShadow(
                                  color: Theme.of(context).shadowColor.withOpacity(0.2), // Use shadowColor from the theme with opacity
                                  spreadRadius: 2, // Spread radius of the shadow
                                  blurRadius: 4, // Blur radius of the shadow
                                  offset: const Offset(0, 2), // Offset of the shadow
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                        width: 25,
                                        height: 25,
                                        child:
                                        SvgPicture.asset(
                                            Images.googleIcon)
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      InkWell(
                        onTap: (){

                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            width: 158.50,
                            height: 70,
                            padding: const EdgeInsets.only(top: 22, bottom: 23),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              color: Theme.of(context).cardColor,
                              boxShadow: [
                                BoxShadow(
                                  color: Theme.of(context).shadowColor.withOpacity(0.2), // Use shadowColor from the theme with opacity
                                  spreadRadius: 2, // Spread radius of the shadow
                                  blurRadius: 4, // Blur radius of the shadow
                                  offset: const Offset(0, 2), // Offset of the shadow
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                        width: 25,
                                        height: 25,
                                        child:
                                        SvgPicture.asset(
                                          Images.facebookIcon,
                                          height: 25,
                                          width: 25,
                                        )
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          )

        ],
      ),
    );
  }
}



// Future<UserCredential> signInWithGoogle() async {
//   // Trigger the authentication flow
//   final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
//
//   // Obtain the auth details from the request
//   final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;
//
//   // Create a new credential
//   final credential = GoogleAuthProvider.credential(
//     accessToken: googleAuth?.accessToken,
//     idToken: googleAuth?.idToken,
//   );
//
//   // Once signed in, return the UserCredential
//   return await FirebaseAuth.instance.signInWithCredential(credential);
// }
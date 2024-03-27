import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:flutter_svg/svg.dart';
import 'package:smart_real_estate/core/helper/SRValidator.dart';
import 'package:smart_real_estate/core/utils/images.dart';
import 'package:smart_real_estate/core/utils/styles.dart';

import '../../widget/custom_field_widget.dart';


final _formKey = GlobalKey<FormState>();


class SignUpScreen extends StatefulWidget {
  const SignUpScreen({
    super.key,
  });

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {

  final TextEditingController nameController = TextEditingController();

  final TextEditingController phoneController = TextEditingController();

  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();


  bool isConditionAccepted = false;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        children: [
          Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  CustomTextFieldWidget(
                    isPassword: false,
                    isPhone: false,
                    name: Locales.string(context, "name"),
                    controller: nameController,
                    hintText: Locales.string(context, "write_name"),
                    validator: (name) => (name!.isEmpty)?'please enter your name':null,
                  ),


                  const SizedBox(height: 20),
                  CustomTextFieldWidget(
                    isPassword: false,
                    isPhone: true,
                    name: Locales.string(context, "phone"),
                    controller: phoneController,
                    hintText: Locales.string(context, "write_phone"),
                    validator: SRValidator.validateYemeniPhoneNumber,
                  ),
                  const SizedBox(height: 20),
                  CustomTextFieldWidget(
                    isPassword: false,
                    isPhone: false,
                    name: Locales.string(context, "email"),
                    controller: phoneController,
                    hintText: Locales.string(context, "write_email"),
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
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: Locales.isDirectionRTL(context)? MainAxisAlignment.start: MainAxisAlignment.end,
                    children: !Locales.isDirectionRTL(context)?[
                      Text(
                          Locales.string(context, "accept_policy"),
                        style: fontMediumBold
                      ),
                      Checkbox(
                        value: isConditionAccepted,
                        onChanged: (value) {
                          setState(() {
                            isConditionAccepted = value!;
                          });
                        },
                      ),

                    ]: [
                      Checkbox(
                        value: isConditionAccepted,
                        onChanged: (value) {
                          setState(() {
                            isConditionAccepted = value!;
                          });
                        },
                      ),
                      Text(
                          Locales.string(context, "accept_policy"),
                          style: fontMediumBold
                      ),
                    ],
                  ),
                  Container(
                    margin: const EdgeInsets.all(5.0),
                    width: double.infinity,
                    height: 58,
                    child: ElevatedButton(
                      onPressed: (){
                        if(_formKey.currentState!.validate()){

                        }


                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1F4C6B),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0), // Corner radius
                        ),
                      ),
                      child:
                      // _authUseCase.isLoading
                      //     ? CircularProgressIndicator(
                      //   valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      // )
                      //     :
                      Text(
                          Locales.string(context, "create_account"),
                          style: fontMediumBold
                      ),
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
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:smart_real_estate/core/constant/app_constants.dart';
import 'package:smart_real_estate/owner/owner_root_screen/presentation/pages/owner_root_screen.dart';

import '../../../../../core/helper/local_data/shared_pref.dart';

class ModificationScreen extends StatefulWidget {
  const ModificationScreen({super.key});

  @override
  State<ModificationScreen> createState() => _ModificationScreenState();
}

class _ModificationScreenState extends State<ModificationScreen> {
  String? token;
  String? _selectedChoice;
  final List<String> _choices = [AppConstants.agent, AppConstants.promoter, AppConstants.owner,];


  bool loading = false;






  @override
  void initState() {
    super.initState();
    fetchToken();
  }

  Future<void> fetchToken() async {
    await SharedPrefManager.init();
    String? mToken = await SharedPrefManager.getData(AppConstants.token);
    setState(() {
      token = mToken ?? " ";
    });
  }






  Future<void> _submitChoice() async {
    if (_selectedChoice != null) {

            try{
              setState(() {
                loading = true;
              });

              var headers = {
                'Authorization': 'token $token',
                'Content-Type': 'application/json'
              };
              var request = http.Request('PATCH', Uri.parse('${AppConstants.baseUrl}api/user/profile/update/'));
              request.body = json.encode({
                "user_type": "$_selectedChoice"
              });
              request.headers.addAll(headers);

              http.StreamedResponse response = await request.send();

              if (response.statusCode == 200) {
                setState(() {
                  loading = false;
                });
                print(await response.stream.bytesToString());

                SharedPrefManager.saveData(AppConstants.userType, _selectedChoice!);

                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const OwnerRootScreen()));
              }
              else {
                print(response.reasonPhrase);
              }
              setState(() {
                loading = false;
              });
            }catch(e){
              setState(() {
                loading = false;
              });
              Get.snackbar("error", "$e");
            }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('You selected $_selectedChoice')),
      );
      // Perform any action based on the selected choice here.
      // print('Selected choice: $_selectedChoice');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select a choice')),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(Locales.string(context, "type_of_user")),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {navigator?.pop();},
          icon:  const Icon(Icons.arrow_back_ios_new_outlined,size: 15,),

        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(60.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ..._choices.map((choice) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 5.0),
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _selectedChoice = choice;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white, backgroundColor: _selectedChoice == choice ? Colors.blue : Colors.grey,
                     minimumSize: Size(600, 50),
                  ),
                  child: Text(choice),
                ),
              );
            }).toList(),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: _submitChoice,
                child: loading?CircularProgressIndicator():Text('Submit'),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white, backgroundColor: Colors.green,
                  minimumSize: Size(270, 50),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

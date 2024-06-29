import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
class First extends StatefulWidget {
  const First({super.key});

  @override
  State<First> createState() => _FirstState();
}

class _FirstState extends State<First> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            top: 0,
            child: Column(
              children: [
                /// appbar
                /// image profile
                Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: Colors.red.withOpacity(0.55555)
                    ),
                  ),
                )
                /// emailDetails
                ///
                ///
                ///
                ///
                ///

              ],
            ),
          ),

          Positioned(
            bottom: 10,
            right: 0,
            left: 0,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 30.0),
              child: InkWell(
                onTap: (){

                },
                child: Container(
                  height: 70,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30.0),
                    color: Colors.blue,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

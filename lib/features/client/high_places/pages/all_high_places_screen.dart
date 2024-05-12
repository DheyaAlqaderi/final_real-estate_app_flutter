import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:smart_real_estate/core/utils/images.dart';
import 'package:smart_real_estate/core/utils/styles.dart';
import 'package:smart_real_estate/features/client/high_places/pages/high_state_screen.dart';
import 'package:smart_real_estate/features/client/high_places/widgets/stand_place_widget.dart';

import '../../home/data/models/state/state_model.dart';

class AllHighPlacesScreen extends StatefulWidget {
  const AllHighPlacesScreen({super.key, required this.stateModel});
  final List<StateModel> stateModel;
  @override
  State<AllHighPlacesScreen> createState() => _AllHighPlacesScreenState();
}

class _AllHighPlacesScreenState extends State<AllHighPlacesScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:SafeArea(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10.0,),
              Row(
                children: [
                  const Padding(padding: EdgeInsets.all(8.0)),
                  InkWell(
                    onTap: (){
                      Navigator.pop(context);
                    },
                    borderRadius: BorderRadius.circular(50),
                    child: Center(
                      child: Container(
                        width: 56,
                        height: 56,
                        decoration: ShapeDecoration(
                          color: Theme.of(context).cardColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                          shadows: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: const Offset(0, 3),
                            )
                          ],
                        ),
                        child: const Align(
                          alignment: Alignment.center,
                            child: Icon(Icons.arrow_back)),
                      ),
                    ),
                  ),
                  const Spacer(flex: 2,),
                ],
              ),
              const SizedBox(height: 20.0,),
              Padding(
                padding: const EdgeInsetsDirectional.only(start: 10.0),
                child: Text(
                    Locales.string(context, "high_places"),
                  style: fontLargeBold,
                ),
              ),
              const SizedBox(height: 5.0,),
              Padding(
                padding: const EdgeInsetsDirectional.only(start: 10.0),
                child: Text(
                  Locales.string(context, "find_all_places"),
                  style: fontMedium,
                ),
              ),
              const SizedBox(height: 5.0,),
              Wrap(
                crossAxisAlignment: WrapCrossAlignment.start,
                spacing: 30.0,
                runSpacing: 10.0,
                children: List.generate(
                  widget.stateModel.length,
                      (index) =>  StandPlaceWidget(
                        image: Images.onBoardingOne,
                        name: widget.stateModel[index].name.toString(),
                        id: index,
                        onTap: (id){
                          Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) =>  HighStateScreen(
                                name: widget.stateModel[id].name.toString(),
                                stateId: widget.stateModel[id].id!,
                              ))
                          );
                        }
                      ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

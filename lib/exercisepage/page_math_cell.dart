import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_exercise/datamodel/exercise/construction_2d_entity.dart';
import 'package:flutter_exercise/entity_factory.dart';
import 'package:flutter_exercise/exerciseframework/common/common_exercise_appbar.dart';
import 'package:flutter_exercise/exerciseframework/core/formwork.dart';
import 'package:flutter_exercise/test_json_string.dart';
import 'package:flutter_exercise/utils/print_helper.dart';

class MathCellPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    Map entityMap = json.decode(construction2DData);
    Construction2DEntity entity = EntityFactory.generateOBJ(entityMap);

    return Scaffold(
        appBar: CommonExerciseAppBar(
          name: '${entity.questionName}',
        ),
        body: Container(
          width: size.width,
          height: size.height,
          child: ExerciseFormWork(
              formWorkFactory: ExerciseFormWorkFactory(
                  exerciseEntity: entity,
                  onExerciseLoading: (details) {
                    printHelper(details.data.toString());
                  },

                  onExerciseReady: (details) {
                    printHelper(details.data.toString());
                    printHelper(entity.toJson());
                  }
              )
          ),
        ),
    );
  }
}
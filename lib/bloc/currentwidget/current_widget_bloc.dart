import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:passengerapp/widgets/whereto.dart';

class CurrentWidgetCubit extends Cubit<Widget> {
  CurrentWidgetCubit()
      : super(WhereTo(
          key: Key("whereto"),
        ));
  void changeWidget(Widget widget) => emit(widget);
}

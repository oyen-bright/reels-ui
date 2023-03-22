import 'package:bloc/bloc.dart';

class OpacityCubit extends Cubit<double> {
  OpacityCubit() : super(1.0);

  void changeOpacit(double newValue) {
    emit(newValue);
  }
}

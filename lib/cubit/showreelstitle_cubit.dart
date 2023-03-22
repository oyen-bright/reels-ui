import 'package:bloc/bloc.dart';

class ShowreelstitleCubit extends Cubit<bool> {
  ShowreelstitleCubit() : super(true);

  void showreelTitle(bool show) {
    emit(show);
  }
}

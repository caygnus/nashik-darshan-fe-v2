import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'iternary_state.dart';

class IternaryCubit extends Cubit<IternaryState> {
  IternaryCubit() : super(IternaryInitial());
}

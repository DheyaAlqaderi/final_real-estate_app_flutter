import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/repository/category_repo.dart';

// States
abstract class OptionsState extends Equatable {
  const OptionsState();
}

class OptionsInitial extends OptionsState {
  @override
  List<Object> get props => [];
}

class OptionsLoading extends OptionsState {
  @override
  List<Object> get props => [];
}

class OptionsLoaded extends OptionsState {
  final List<String> options2;
  final List<String> options3;

  const OptionsLoaded({this.options2 = const [], this.options3 = const []});

  @override
  List<Object> get props => [options2, options3];
}

class OptionsError extends OptionsState {
  final String message;

  const OptionsError(this.message);

  @override
  List<Object> get props => [message];
}

// Cubit
class OptionsCubit extends Cubit<OptionsState> {
  OptionsCubit() : super(OptionsInitial());

  Future<void> fetchOptions2(int parent) async {
    emit(OptionsLoading());
    try {
      List<String> options2 = await CategoriesRepository.fetchCategories(parent: parent);
      emit(OptionsLoaded(options2: options2));
    } catch (e) {
      emit(OptionsError('Failed to fetch options2: $e'));
    }
  }

  Future<void> fetchOptions3(int parent) async {
    emit(OptionsLoading());
    try {
      List<String> options3 = await CategoriesRepository.fetchCategories(parent: parent);
      final currentState = state as OptionsLoaded;
      emit(OptionsLoaded(options2: currentState.options2, options3: options3));
    } catch (e) {
      emit(OptionsError('Failed to fetch options3: $e'));
    }
  }
}

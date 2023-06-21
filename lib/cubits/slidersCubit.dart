import 'package:eschool/data/models/sliderDetails.dart';
import 'package:eschool/data/repositories/systemInfoRepository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class SlidersState {}

class SlidersInitial extends SlidersState {}

class SlidersFetchInProgress extends SlidersState {}

class SlidersFetchSuccess extends SlidersState {
  final List<SliderDetails> sliders;

  SlidersFetchSuccess({required this.sliders});
}

class SlidersFetchFailure extends SlidersState {
  final String errorMessage;

  SlidersFetchFailure(this.errorMessage);
}

class SlidersCubit extends Cubit<SlidersState> {
  final SystemRepository _systemRepository;

  SlidersCubit(this._systemRepository) : super(SlidersInitial());

  void fetchSliders() async {
    emit(SlidersFetchInProgress());
    try {
      final sliders = await _systemRepository.fetchSliders();
      emit(SlidersFetchSuccess(sliders: sliders));
    } catch (e) {
      emit(SlidersFetchFailure(e.toString()));
    }
  }
}

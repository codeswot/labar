import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:injectable/injectable.dart';
import 'package:labar_app/features/home/domain/repositories/application_repository.dart';
import 'package:labar_app/features/home/presentation/cubit/home_state.dart';

@injectable
class HomeCubit extends Cubit<HomeState> {
  final ApplicationRepository _applicationRepository;
  StreamSubscription? _applicationSubscription;
  final ImagePicker _imagePicker = ImagePicker();

  HomeCubit(this._applicationRepository) : super(const HomeState()) {
    _init();
  }

  void _init() {
    _applicationSubscription?.cancel();
    _applicationSubscription =
        _applicationRepository.getApplicationStream().listen(
      (application) {
        if (application != null) {
          emit(state.copyWith(
            application: application,
            view: HomeView.submitted,
            isLoading: false,
            errorMessage: null,
          ));
        } else {
          emit(state.copyWith(
            application: null,
            view: HomeView.form,
            isLoading: false,
            errorMessage: null,
          ));
        }
      },
      onError: (error) {
        emit(state.copyWith(
          isLoading: false,
          errorMessage: error.toString(),
        ));
      },
    );
  }

  Future<void> uploadProofOfPayment() async {
    final application = state.application;
    if (application == null) return;

    final XFile? image = await _imagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 70,
    );

    if (image == null) return;

    emit(state.copyWith(isLoading: true));

    try {
      final String fileName = 'proof_of_payment_${application.id}.jpg';
      final String path =
          await _applicationRepository.uploadFile(image.path, fileName);

      final updatedApplication = application.copyWith(
        proofOfPaymentPath: path,
      );

      await _applicationRepository.saveApplication(updatedApplication);
    } catch (e) {
      emit(state.copyWith(isLoading: false));
    }
  }

  Future<void> refreshApplication() async {
    final application = await _applicationRepository.getApplication();
    if (application != null) {
      emit(state.copyWith(
        application: application,
        view: HomeView.submitted,
        isLoading: false,
      ));
    }
  }

  void setView(HomeView view) {
    emit(state.copyWith(view: view));
  }

  void reset() {
    _applicationSubscription?.cancel();
    emit(const HomeState(isLoading: true));
    _init();
  }

  @override
  Future<void> close() {
    _applicationSubscription?.cancel();
    return super.close();
  }
}

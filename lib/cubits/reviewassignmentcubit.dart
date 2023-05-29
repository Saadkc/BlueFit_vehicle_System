import 'package:bloc/bloc.dart';
import 'package:eschool_teacher/data/repositories/reviewAssignmentRepository.dart';
import 'package:meta/meta.dart';

import 'package:eschool_teacher/data/models/reviewAssignmentssubmition.dart';

@immutable
abstract class ReviewAssignmentState {}

class ReviewAssignmentInitial extends ReviewAssignmentState {}

class ReviewAssignmentInProcess extends ReviewAssignmentState {}

class ReviewAssignmentSuccess extends ReviewAssignmentState {
  final List<ReviewAssignmentssubmition> reviewAssignment;

  ReviewAssignmentSuccess({
    required this.reviewAssignment,
  });
}

class ReviewAssignmentFailure extends ReviewAssignmentState {
  final String errorMessage;
  ReviewAssignmentFailure({
    required this.errorMessage,
  });
}

class ReviewAssignmentCubit extends Cubit<ReviewAssignmentState> {
  final ReviewAssignmentRepository _reviewAssignmentRepository;
  ReviewAssignmentCubit(this._reviewAssignmentRepository)
      : super(ReviewAssignmentInitial());

  void fetchReviewAssignment({
    required int assignmentId,
  }) async {
    try {
      emit(ReviewAssignmentInProcess());
      await _reviewAssignmentRepository
          .fetchReviewAssignment(assignmetId: assignmentId)
          .then((value) {
        emit(
          ReviewAssignmentSuccess(
            reviewAssignment: value,
          ),
        );
      });
    } catch (e) {
      print(" reviewassignment${e.toString()}");
      emit(ReviewAssignmentFailure(errorMessage: e.toString()));
    }
  }

  void updateReviewAssignmet(
      {required ReviewAssignmentssubmition
          updatedReviewAssignmentSubmition}) async {
    try {
      List<ReviewAssignmentssubmition> currentassignment =
          (state as ReviewAssignmentSuccess).reviewAssignment;
      List<ReviewAssignmentssubmition> updateassignment =
          List.from(currentassignment);
      int reviewAssignmentIndex = currentassignment.indexWhere(
          (element) => element.id == updatedReviewAssignmentSubmition.id);
      updateassignment[reviewAssignmentIndex] =
          updatedReviewAssignmentSubmition;
      emit(ReviewAssignmentSuccess(reviewAssignment: updateassignment));
    } catch (e) {
      print(e.toString());
      emit(ReviewAssignmentFailure(errorMessage: e.toString()));
    }
  }

  List<ReviewAssignmentssubmition> reviewAssignment() {
    return (state as ReviewAssignmentSuccess).reviewAssignment;
  }
}

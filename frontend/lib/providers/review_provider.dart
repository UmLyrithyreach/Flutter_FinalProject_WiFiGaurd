import 'package:flutter/material.dart';
import '../models/review.dart';
import '../services/review_service.dart';

class ReviewProvider extends ChangeNotifier {
  final ReviewService reviewService = ReviewService();

  List<ReviewModel> reviews = [];
  bool isLoading = false;

  Future<void> loadReviews(String networkSsid) async {
    isLoading = true;
    notifyListeners();

    List<ReviewModel> result = await reviewService.getReviews(networkSsid);
    reviews = result;

    isLoading = false;
    notifyListeners();
  }

  Future<void> submitReview({
    required String networkSsid,
    required String userId,
    required String userName,
    required int rating,
    required String comment,
  }) async {
    ReviewModel newReview = ReviewModel(
      reviewId: DateTime.now().millisecondsSinceEpoch.toString(),
      networkSsid: networkSsid,
      userId: userId,
      userName: userName,
      rating: rating,
      comment: comment,
      timestamp: DateTime.now(),
    );

    await reviewService.submitReview(newReview);

    // refresh the list so the new review shows up right away
    await loadReviews(networkSsid);
  }
}

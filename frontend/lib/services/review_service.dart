import '../models/review.dart';

// this is just a temporary version so network detail screen works for now
// friend will change the inside of these functions to use real firestore

class ReviewService {
  // fake in-memory list, just so the app has something to show right now
  static List<ReviewModel> fakeReviews = [];

  Future<List<ReviewModel>> getReviews(String networkSsid) async {
    await Future.delayed(const Duration(milliseconds: 500));

    List<ReviewModel> result = [];

    for (int i = 0; i < fakeReviews.length; i++) {
      if (fakeReviews[i].networkSsid == networkSsid) {
        result.add(fakeReviews[i]);
      }
    }

    return result;
  }

  Future<void> submitReview(ReviewModel review) async {
    await Future.delayed(const Duration(milliseconds: 500));

    // friend: put firestore collection('reviews').add(review.toMap()) here later

    fakeReviews.add(review);
  }

  // counts how many reviews one user has submitted across all networks
  int countReviewsByUser(String userId) {
    int count = 0;

    for (int i = 0; i < fakeReviews.length; i++) {
      if (fakeReviews[i].userId == userId) {
        count = count + 1;
      }
    }

    return count;
  }
}

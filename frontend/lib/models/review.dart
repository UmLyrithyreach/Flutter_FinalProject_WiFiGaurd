// this class is just a shape for one review
// it does not do anything, it only holds data

class ReviewModel {
  final String reviewId;
  final String networkSsid;
  final String userId;
  final String userName;
  final int rating;
  final String comment;
  final DateTime timestamp;

  ReviewModel({
    required this.reviewId,
    required this.networkSsid,
    required this.userId,
    required this.userName,
    required this.rating,
    required this.comment,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'reviewId': reviewId,
      'networkSsid': networkSsid,
      'userId': userId,
      'userName': userName,
      'rating': rating,
      'comment': comment,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}
// this class is just a shape for one review
// it does not do anything, it only holds data


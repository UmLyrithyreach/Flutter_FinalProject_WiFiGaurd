import 'package:flutter/material.dart';
import '../models/review.dart';

class ReviewCard extends StatelessWidget {
  final ReviewModel review;

  const ReviewCard({Key? key, required this.review}) : super(key: key);

  // builds one row of 5 stars, filled up to the rating value
  Widget buildStars() {
    List<Widget> starList = [];

    for (int i = 1; i <= 5; i++) {
      if (i <= review.rating) {
        starList.add(const Icon(Icons.star, color: Colors.amber, size: 16));
      } else {
        starList.add(
          const Icon(Icons.star_border, color: Colors.grey, size: 16),
        );
      }
    }

    return Row(children: starList);
  }

  // returns the first letter of the username for the avatar circle
  String getInitial() {
    if (review.userName.isEmpty) {
      return "?";
    } else {
      return review.userName[0].toUpperCase();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1420),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor: const Color(0xFF7B2FF7),
                child: Text(
                  getInitial(),
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  review.userName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
              buildStars(),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            review.comment,
            style: const TextStyle(color: Colors.grey, fontSize: 13),
          ),
        ],
      ),
    );
  }
}

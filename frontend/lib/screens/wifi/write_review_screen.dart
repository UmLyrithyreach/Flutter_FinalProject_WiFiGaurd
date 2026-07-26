import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/wifi_network.dart';
import '../../providers/review_provider.dart';
import '../../providers/auth_provider.dart';

class WriteReviewScreen extends StatefulWidget {
  final WifiNetworkModel network;

  const WriteReviewScreen({Key? key, required this.network}) : super(key: key);

  @override
  State<WriteReviewScreen> createState() => _WriteReviewScreenState();
}

class _WriteReviewScreenState extends State<WriteReviewScreen> {
  final TextEditingController commentController = TextEditingController();
  int selectedRating = 0;
  bool isSubmitting = false;

  Widget buildStarSelector() {
    List<Widget> starList = [];

    for (int i = 1; i <= 5; i++) {
      IconData starIcon;
      if (i <= selectedRating) {
        starIcon = Icons.star;
      } else {
        starIcon = Icons.star_border;
      }

      starList.add(
        GestureDetector(
          onTap: () {
            setState(() {
              selectedRating = i;
            });
          },
          child: Padding(
            padding: const EdgeInsets.only(right: 6),
            child: Icon(starIcon, color: const Color(0xFFEC4899), size: 34),
          ),
        ),
      );
    }

    return Row(children: starList);
  }

  void handleSubmit() async {
    if (selectedRating == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select a star rating")),
      );
      return;
    }

    if (commentController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Please write a comment")));
      return;
    }

    setState(() {
      isSubmitting = true;
    });

    AuthProvider authProvider = Provider.of<AuthProvider>(
      context,
      listen: false,
    );
    ReviewProvider reviewProvider = Provider.of<ReviewProvider>(
      context,
      listen: false,
    );

    String userId;
    String userName;

    if (authProvider.authService.getCurrentUser() == null) {
      userId = "anonymous";
      userName = "Anonymous";
    } else {
      userId = authProvider.authService.getCurrentUser()!.uid;
      userName =
          authProvider.authService.getCurrentUser()!.email ?? "Anonymous";
    }

    await reviewProvider.submitReview(
      networkSsid: widget.network.ssid,
      userId: userId,
      userName: userName,
      rating: selectedRating,
      comment: commentController.text,
    );

    setState(() {
      isSubmitting = false;
    });

    if (!mounted) return;

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Review submitted!")));

    // go back to the detail screen so the user sees their new review
    Navigator.pop(context);
  }

  Widget buildSubmitButtonChild() {
    if (isSubmitting == true) {
      return const SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
      );
    } else {
      return const Text(
        "Submit Review",
        style: TextStyle(
          color: Colors.white,
          fontSize: 15,
          fontWeight: FontWeight.bold,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0710),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: const Row(
                  children: [
                    Icon(Icons.arrow_back, color: Colors.grey, size: 18),
                    SizedBox(width: 6),
                    Text(
                      "Back",
                      style: TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              const Text(
                "Write Review",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                widget.network.ssid,
                style: const TextStyle(color: Colors.grey, fontSize: 14),
              ),

              const SizedBox(height: 24),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: const Color(0xFF1A1420),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "RATING",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 11,
                        letterSpacing: 1,
                      ),
                    ),
                    const SizedBox(height: 10),
                    buildStarSelector(),

                    const SizedBox(height: 20),

                    const Text(
                      "REVIEW",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 11,
                        letterSpacing: 1,
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: commentController,
                      maxLines: 4,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: "Don't be scared bro, comment sth!",
                        hintStyle: const TextStyle(color: Colors.grey),
                        filled: true,
                        fillColor: const Color(0xFF2A2230),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.zero,
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onPressed: () {
                    if (isSubmitting == false) {
                      handleSubmit();
                    }
                  },
                  child: Ink(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      gradient: const LinearGradient(
                        colors: [Color(0xFF7B2FF7), Color(0xFF3D1A5C)],
                      ),
                    ),
                    child: Container(
                      alignment: Alignment.center,
                      child: buildSubmitButtonChild(),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

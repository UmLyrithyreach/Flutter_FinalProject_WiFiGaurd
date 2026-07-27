import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/wifi_network.dart';
import '../../providers/review_provider.dart';
import '../../providers/history_provider.dart';
import '../../widgets/review_card.dart';
import 'write_review_screen.dart';

class WifiDetailScreen extends StatefulWidget {
  final WifiNetworkModel network;

  const WifiDetailScreen({Key? key, required this.network}) : super(key: key);

  @override
  State<WifiDetailScreen> createState() => _WifiDetailScreenState();
}

class _WifiDetailScreenState extends State<WifiDetailScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<ReviewProvider>(
        context,
        listen: false,
      ).loadReviews(widget.network.ssid);
      Provider.of<HistoryProvider>(
        context,
        listen: false,
      ).addToHistory(widget.network);
    });
  }

  String getStatusLabel() {
    if (widget.network.encryptionType == "Open") {
      return "Risky";
    } else if (widget.network.encryptionType == "WPA") {
      return "Caution";
    } else {
      return "Secure";
    }
  }

  Color getStatusColor() {
    if (widget.network.encryptionType == "Open") {
      return Colors.redAccent;
    } else if (widget.network.encryptionType == "WPA") {
      return Colors.orangeAccent;
    } else {
      return Colors.greenAccent;
    }
  }

  // works out the average rating from all reviews for this network
  double getAverageRating(ReviewProvider reviewProvider) {
    if (reviewProvider.reviews.isEmpty) {
      return 0;
    }

    int total = 0;
    for (int i = 0; i < reviewProvider.reviews.length; i++) {
      total = total + reviewProvider.reviews[i].rating;
    }

    return total / reviewProvider.reviews.length;
  }

  Widget buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label.toUpperCase(),
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 11,
              letterSpacing: 1,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildStars(int rating) {
    List<Widget> starList = [];

    for (int i = 1; i <= 5; i++) {
      if (i <= rating) {
        starList.add(
          const Icon(Icons.star, color: Color(0xFFEC4899), size: 16),
        );
      } else {
        starList.add(
          const Icon(Icons.star_border, color: Colors.grey, size: 16),
        );
      }
    }

    return Row(children: starList);
  }

  @override
  Widget build(BuildContext context) {
    ReviewProvider reviewProvider = Provider.of<ReviewProvider>(context);
    double averageRating = getAverageRating(reviewProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF0D0710),
      body: SafeArea(
        child: SingleChildScrollView(
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.network.ssid,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (reviewProvider.reviews.isNotEmpty)
                          Text(
                            averageRating.toStringAsFixed(1),
                            style: const TextStyle(
                              color: Color(0xFFEC4899),
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    if (reviewProvider.reviews.isNotEmpty)
                      Row(
                        children: [
                          buildStars(averageRating.round()),
                          const SizedBox(width: 8),
                          const Text(
                            "Community Rating",
                            style: TextStyle(color: Colors.grey, fontSize: 12),
                          ),
                        ],
                      ),

                    const SizedBox(height: 18),
                    const Divider(color: Colors.white12),
                    const SizedBox(height: 10),

                    buildDetailRow("SSID", widget.network.ssid),
                    buildDetailRow("BSSID", widget.network.bssid),
                    buildDetailRow("Signal", "${widget.network.rssi} dBm"),
                    buildDetailRow("Frequency", widget.network.frequency),
                    buildDetailRow(
                      "Channel",
                      widget.network.channel.toString(),
                    ),
                    buildDetailRow("Encryption", widget.network.encryptionType),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              const Text(
                "COMMUNITY REVIEWS",
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 11,
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(height: 10),

              buildReviewList(reviewProvider),

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
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            WriteReviewScreen(network: widget.network),
                      ),
                    );
                  },
                  child: Ink(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      gradient: const LinearGradient(
                        colors: [Color(0xFFEC4899), Color(0xFF7B2FF7)],
                      ),
                    ),
                    child: Container(
                      alignment: Alignment.center,
                      child: const Text(
                        "Write Review",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
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

  Widget buildReviewList(ReviewProvider reviewProvider) {
    if (reviewProvider.isLoading == true) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.white),
      );
    }

    if (reviewProvider.reviews.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 10),
        child: Text(
          "No reviews yet for this network.",
          style: TextStyle(color: Colors.grey, fontSize: 13),
        ),
      );
    }

    return Column(
      children: reviewProvider.reviews
          .map((review) => ReviewCard(review: review))
          .toList(),
    );
  }
}

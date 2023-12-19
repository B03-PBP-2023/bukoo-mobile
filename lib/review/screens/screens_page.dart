import 'package:flutter/material.dart';
import 'package:bukoo/book_collection/models/book.dart';
import 'package:bukoo/core/config.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ReviewPage extends StatefulWidget {
  final int bookId;
  const ReviewPage({super.key, required this.bookId});

  static const routeName = '/review-page';

  @override
  State<ReviewPage> createState() => _ReviewPageState();
}

class Review {
  final String userName;
  final String content;

  Review({required this.userName, required this.content});

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      userName: json['user']['name'],
      content: json['review'],
    );
  }
}

class _ReviewPageState extends State<ReviewPage> {
  final String currentUserName = "CurrentUser"; // Replace with actual user name

  Future<Map<String, dynamic>> fetchReviews() async {
    final request = context.watch<CookieRequest>();
    final response =
        await request.get('$BASE_URL/review/${widget.bookId}/get_review_json');
    if (response is Map) {
      List<Review> reviewsList = (response['reviews'])
          .map((item) => Review.fromJson(item as Map<String, dynamic>))
          .toList();
      Review currentUserReview =
          Review.fromJson(response['current_user_review'] as Map<String, dynamic>);

      return {
        'reviews': reviewsList,
        'currentUserReview': currentUserReview,
      };
    } else {
      throw Exception('Failed to load reviews');
    }
  }

  Future<void> _showAddReviewDialog() async {
    final TextEditingController _reviewController = TextEditingController();
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // User must tap a button to close the dialog.
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add Review'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextField(
                  controller: _reviewController,
                  decoration:
                      InputDecoration(hintText: "Enter your review here"),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Submit'),
              onPressed: () async {
                await submitReview(_reviewController.text);
                Navigator.of(context).pop();
                setState(
                    () {}); // Refresh the page or update the state as needed
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> submitReview(String reviewContent) async {
    String submitReviewUrl = '$BASE_URL/review/${widget.bookId}/create_review/';
    final request = context.watch<CookieRequest>();
    try {
      final response = await request.postJson(
        submitReviewUrl,
        json.encode({
          'bookId': widget.bookId,
          'userName': currentUserName,
          'review': reviewContent,
        }),
      );

      if (response is Map) {
        print('Review submitted successfully');
      } else {
        print('Failed to submit review');
      }
    } catch (e) {
      print('Error submitting review: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Review Page!'),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: fetchReviews(),
        builder: (context, reviewSnapshot) {
          if (reviewSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (reviewSnapshot.hasError) {
            return Center(child: Text('Error: ${reviewSnapshot.error} \n\n ${reviewSnapshot.stackTrace}'));
          }
          if (!reviewSnapshot.hasData || reviewSnapshot.data!.isEmpty) {
            return const Center(child: Text('No reviews available'));
          }

          List<Review> reviews = reviewSnapshot.data!['reviews'];
          Review? currentUserReview = reviewSnapshot.data!['currentUserReview'];

          return ListView(
            children: [
              if (currentUserReview != null)
                ReviewCard(review: currentUserReview)
              else
                ElevatedButton(
                  onPressed: _showAddReviewDialog,
                  child: const Text('Add Review'),
                ),
              const Divider(),
              ...reviews
                  .where((review) => review.userName != currentUserName)
                  .map((review) => ReviewCard(review: review))
                  .toList(),
            ],
          );
        },
      ),
    );
  }
}

class ReviewCard extends StatelessWidget {
  final Review review;

  ReviewCard({Key? key, required this.review}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8.0),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              review.userName,
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              review.content,
              style: TextStyle(
                fontSize: 14.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

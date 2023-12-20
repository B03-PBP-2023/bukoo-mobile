// ignore_for_file: use_build_context_synchronously, avoid_print

import 'package:flutter/material.dart';
import 'package:bukoo/core/config.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'dart:convert';

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
  final int reviewiD;

  Review(
      {required this.userName, required this.content, required this.reviewiD});

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
        userName: json['user']['name'],
        content: json['review'],
        reviewiD: json['id']);
  }
}

class _ReviewPageState extends State<ReviewPage> {
  final String currentUserName = "CurrentUser";

  Future<Map<String, dynamic>> fetchReviews() async {
    final request = context.watch<CookieRequest>();
    final response =
        await request.get('$BASE_URL/review/${widget.bookId}/get_review_json');
    final data = response['data'];
    if (response['status'] == 'success') {
      List<Review> reviewsList = (data['reviews'] as List)
          .whereType<Map<String, dynamic>>()
          .map((item) => Review.fromJson(item))
          .toList();

      Review? currentUserReview = (data['current_user_review'] != null)
          ? Review.fromJson(data['current_user_review'] as Map<String, dynamic>)
          : null;

      return {
        'reviews': reviewsList,
        'currentUserReview': currentUserReview,
      };
    } else {
      throw Exception('Failed to load reviews');
    }
  }

  Future<void> _showAddReviewDialog() async {
    final TextEditingController reviewController = TextEditingController();
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // User must tap a button to close the dialog.
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add Review'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextField(
                  controller: reviewController,
                  decoration:
                      const InputDecoration(hintText: "Enter your review here"),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Submit'),
              onPressed: () async {
                await submitReview(reviewController.text);
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
    final request = context.read<CookieRequest>();
    try {
      final response = await request.post(submitReviewUrl, {
        'bookId': widget.bookId.toString(),
        'userName': currentUserName,
        'review': reviewContent,
      });

      // Check if response is in JSON format
      if (response.headers['content-type']?.contains('application/json') ??
          false) {
        if (response['status'] == 'success') {
          print('Review submitted successfully');
        } else {
          print('Failed to submit review. Error: ${response['message']}');
        }
      } else {
        // Handle non-JSON response
        print('Received non-JSON response: ${response.body}');
      }
    } catch (e) {
      print('Error submitting review: $e');
    }
  }

  Future<void> deleteReview(int reviewID) async {
    String deleteReviewUrl = '$BASE_URL/review/$reviewID/delete/';
    final request = context.read<CookieRequest>();
    try {
      final response = await request.post(deleteReviewUrl, {
        'bookId': widget.bookId.toString(),
        'userName': currentUserName,
      });

      if (response['status'] == 'success') {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Review deleted succesfully!')));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to delete review.')));
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error deleting review: $e')));
    }
  }

  Future<void> _showEditReviewDialog(Review currentReview) async {
    final TextEditingController reviewController =
        TextEditingController(text: currentReview.content);

    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Review'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextField(
                  controller: reviewController,
                  decoration:
                      const InputDecoration(hintText: "Edit your review here"),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Submit'),
              onPressed: () async {
                await _updateReview(
                    currentReview.reviewiD, reviewController.text);
                Navigator.of(context).pop();
                setState(() {});
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _updateReview(int reviewID, String reviewContent) async {
    String updateReviewUrl = '$BASE_URL/review/$reviewID/edit/';
    final request = context.read<CookieRequest>();
    try {
      final response = await request.post(updateReviewUrl, {
        'review': reviewContent,
      });

    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error updating review: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

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
            return Center(
                child: Text(
                    'Error: ${reviewSnapshot.error} \n\n ${reviewSnapshot.stackTrace}'));
          }
          if (!reviewSnapshot.hasData || reviewSnapshot.data!.isEmpty) {
            return const Center(child: Text('No reviews available'));
          }

          List<Review> reviews = reviewSnapshot.data!['reviews'];
          Review? currentUserReview = reviewSnapshot.data!['currentUserReview'];

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView(
              children: [
                if (currentUserReview != null) ...[
                  const Text(
                    'Your Review',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  ReviewCard(review: currentUserReview),
                  const SizedBox(height: 8.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          _showEditReviewDialog(currentUserReview);
                        },
                        child: const Text('Edit Review'),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          await deleteReview(currentUserReview.reviewiD);
                          setState(() {});
                        },
                        child: const Text('Delete Review'),
                      ),
                    ],
                  ),
                  const Divider(),
                ] else if (request.loggedIn) ...[
                  ElevatedButton(
                    onPressed: _showAddReviewDialog,
                    child: const Text('Add Review'),
                  ),
                  const Divider()
                ],
                ...reviews
                    .where((review) => review.userName != currentUserName)
                    .map((review) => ReviewCard(review: review)),
              ],
            ),
          );
        },
      ),
    );
  }
}

class ReviewCard extends StatelessWidget {
  final Review review;

  const ReviewCard({super.key, required this.review});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              review.userName,
              style: const TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              review.content,
              style: const TextStyle(
                fontSize: 14.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

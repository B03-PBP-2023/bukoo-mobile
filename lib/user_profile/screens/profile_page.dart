import 'package:bukoo/admin_dashboard/models/dashboard_statisics.dart';
import 'package:bukoo/admin_dashboard/widgets/statistic_card.dart';
import 'package:bukoo/core/config.dart';
import 'package:bukoo/core/etc/custom_icon_icons.dart';
import 'package:bukoo/core/widgets/primary_button.dart';
import 'package:bukoo/user_profile/screens/edit_profile_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:bukoo/core/widgets/left_drawer.dart';
import 'package:bukoo/user_profile/models/profile_data.dart';
import 'package:intl/intl.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  static const routeName = '/profile';

  @override
  State<ProfilePage> createState() => _ProfilePage();
}

class _ProfilePage extends State<ProfilePage> {
  Future<ProfileData?> fetchProfile() async {
    final request = context.read<CookieRequest>();
    final response = await request.get('$BASE_URL/profile/json/');
    if (response['status'] == 'success') {
      final data = ProfileData.fromJson(response['data']);
      return data;
    } else {
      return null;
    }
  }

  List<DashboardStatistics> _getDashboardStatistics(
      Map<String, dynamic> data, bool isAuthor) {
    List<DashboardStatistics> dashboardStatistics = [
      DashboardStatistics(
          title: 'Bookmarks',
          value: data['total_bookmarked'],
          color: const Color(0xFF3562D6),
          icon: Icons.bookmark),
      DashboardStatistics(
          title: 'Reviews',
          value: data['total_review'],
          color: const Color(0xFF823AF8),
          icon: CustomIcon.pencil_alt),
      DashboardStatistics(
          title: 'Discussion Posts',
          value: data['total_forum_discussion'],
          color: const Color(0xFF72D635),
          icon: CustomIcon.discussion),
      DashboardStatistics(
          title: 'Discussion Replies',
          value: data['total_replies'],
          color: const Color(0xFFD63F35),
          icon: CustomIcon.discussion),
    ];
    if (isAuthor) {
      dashboardStatistics.add(DashboardStatistics(
          title: 'Book Submissions',
          value: data['total_book_submitted']!,
          color: const Color(0xFFD63F35),
          icon: CustomIcon.book_collection));
    }

    return dashboardStatistics;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      appBar: AppBar(
        title: const Text('Profile',
            style: TextStyle(fontWeight: FontWeight.bold)),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
      ),
      drawer: const LeftDrawer(),
      body: FutureBuilder<ProfileData?>(
        future: fetchProfile(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final profileData = snapshot.data!;
            return SingleChildScrollView(
              child: Stack(
                children: [
                  Column(
                    children: [
                      const SizedBox(height: 100),
                      Container(
                        width: double.infinity,
                        height: MediaQuery.of(context).size.height - 100,
                        padding: const EdgeInsets.symmetric(
                            vertical: 16.0, horizontal: 48.0),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(64.0)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 100),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                  children: _getDashboardStatistics(
                                          profileData.statistics!, false)
                                      .map((data) => SizedBox(
                                          width: 140,
                                          height: 140,
                                          child: StatisticCard(data: data)))
                                      .toList()),
                            ),
                            const SizedBox(height: 16),
                            const Text('Name',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold)),
                            Text(profileData.name ?? '-',
                                style: const TextStyle(fontSize: 18)),
                            const SizedBox(height: 16),
                            const Text('Gender',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold)),
                            Text(profileData.gender ?? '-',
                                style: const TextStyle(fontSize: 18)),
                            const SizedBox(height: 16),
                            const Text('Date of Birth',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold)),
                            Text(
                                profileData.dateOfBirth == null
                                    ? '-'
                                    : DateFormat('yyyy-MM-dd')
                                        .format(profileData.dateOfBirth!),
                                style: const TextStyle(fontSize: 18)),
                            const SizedBox(height: 16),
                            const Text('Preferred Genre',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold)),
                            Text(profileData.preferredGenre ?? '-',
                                style: const TextStyle(fontSize: 18)),
                            const SizedBox(height: 16),
                            const Text('About',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold)),
                            Text(profileData.about ?? '-',
                                style: const TextStyle(fontSize: 18)),
                            const SizedBox(height: 24),
                            PrimaryButton(
                                onPressed: () {
                                  Navigator.push(context, MaterialPageRoute(
                                      builder: (BuildContext context) {
                                    return EditProfilePage(
                                        profileData: profileData);
                                  }));
                                },
                                child: const Text('Edit Profile'))
                          ],
                        ),
                      ),
                    ],
                  ),
                  Positioned(
                    top: 24,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: ClipOval(
                        child: CircleAvatar(
                          radius: 80,
                          child: Image.network(
                            profileData.profilePictureUrl ??
                                ProfilePictureDefault,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('${snapshot.error}'),
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}

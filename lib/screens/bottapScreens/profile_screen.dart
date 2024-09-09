import 'package:flutter/material.dart';
import 'package:hocflutter/Api/api_service.dart';
import 'package:hocflutter/Api/models/profileModel.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ApiService _apiService = ApiService();
  Profile? profile;

  @override
  void initState() {
    fetchUsers();
  }

  Future<void> fetchUsers() async {
    final apiService = Provider.of<ApiService>(context, listen: false);
    final accessToken = apiService.accessTokenId;

    try {
      if (accessToken.isNotEmpty) {
        final response = await _apiService.getProfile(
          accessToken,
        );
        if (response != null) {
          setState(() {
            profile = response;
          });
        } else {
          print('No user data found.');
        }
      } else {
        print('Access token is missing.');
      }
    } catch (e) {
      print('Error fetching users: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    print("profile$profile");
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: const Center(
        child: Text('This is the Profile screen'),
      ),
    );
  }
}

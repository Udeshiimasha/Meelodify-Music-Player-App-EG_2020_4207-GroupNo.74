import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:melodify/screens/authentication/global/toast.dart';
import 'package:melodify/screens/authentication/login.dart';
import 'package:melodify/screens/category.dart';
import 'package:melodify/screens/favourites.dart';
import 'package:melodify/screens/home.dart';
import 'package:melodify/screens/searchscreen.dart';
import 'package:provider/provider.dart';
import 'package:melodify/controllers/profileController.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  int _selectedIndex = 4;

  static const List<Widget> _widgetOptions = <Widget>[
    HomePage(),
    Favourites(),
    SearchScreen(),
    Category(),
    Profile(),
  ];

  void _onItemTapped(int index) {
    if (index != _selectedIndex) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => _widgetOptions[index]),
      );
    }
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<void> _pickImage(ProfileController controller) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      controller.setProfileImagePath(pickedFile.path);
    }
  }

  Future<void> _editName(ProfileController controller) async {
    TextEditingController nameController =
        TextEditingController(text: controller.profileName);

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Name'),
          content: TextField(
            controller: nameController,
            decoration: const InputDecoration(hintText: "Enter your name"),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                controller.setProfileName(nameController.text);
                Navigator.of(context).pop();
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _editPhone(ProfileController controller) async {
    TextEditingController phoneController =
        TextEditingController(text: controller.profilePhone);

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Phone'),
          content: TextField(
            controller: phoneController,
            decoration:
                const InputDecoration(hintText: "Enter your phone number"),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                controller.setProfilePhone(phoneController.text);
                Navigator.of(context).pop();
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _changePassword(ProfileController controller) async {
    TextEditingController currentPasswordController = TextEditingController();
    TextEditingController newPasswordController = TextEditingController();

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Change Password'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: currentPasswordController,
                obscureText: true,
                decoration: const InputDecoration(
                  hintText: 'Enter current password',
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: newPasswordController,
                obscureText: true,
                decoration: const InputDecoration(
                  hintText: 'Enter new password',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                try {
                  await controller.changePassword(
                    currentPasswordController.text,
                    newPasswordController.text,
                  );
                  showToast(message: 'Password changed successfully');
                  Navigator.of(context).pop();
                } catch (error) {
                  showToast(message: 'Failed to change password: $error');
                }
              },
              child: const Text('Change'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ProfileController(),
      child: Consumer<ProfileController>(
        builder: (context, controller, child) {
          return Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              title: const Text(
                'Profile',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                  color: Colors.black,
                ),
              ),
              flexibleSpace: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color.fromARGB(255, 248, 0, 194),
                      Color.fromARGB(255, 255, 131, 187),
                    ],
                  ),
                ),
              ),
              elevation: 25.0,
            ),
            body: Stack(
              children: [
                Image.asset(
                  "assets/images/body_pic.jpg",
                  fit: BoxFit.cover,
                  height: double.infinity,
                  width: double.infinity,
                ),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        const Color.fromARGB(255, 255, 131, 187)
                            .withOpacity(0.8),
                        const Color.fromARGB(255, 234, 187, 209)
                            .withOpacity(0.8),
                      ],
                    ),
                  ),
                  height: double.infinity,
                  width: double.infinity,
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () => _pickImage(controller),
                        child: CircleAvatar(
                          radius: 50,
                          backgroundImage: controller.profileImagePath != null
                              ? FileImage(File(controller.profileImagePath!))
                              : const AssetImage('assets/images/body_pic2.jpg')
                                  as ImageProvider,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        controller.profileName,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        controller.profileEmail,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Expanded(
                        child: ListView(
                          children: [
                            ListTile(
                              leading: const Icon(Icons.person),
                              title: const Text('Name'),
                              subtitle: Text(controller.profileName),
                              onTap: () => _editName(controller),
                            ),
                            ListTile(
                              leading: const Icon(Icons.email),
                              title: const Text('Email'),
                              subtitle: Text(controller.profileEmail),
                              onTap: () {
                                // Add navigation to edit email screen
                              },
                            ),
                            ListTile(
                              leading: const Icon(Icons.phone),
                              title: const Text('Phone'),
                              subtitle: Text(controller.profilePhone),
                              onTap: () => _editPhone(controller),
                            ),
                            ListTile(
                              leading: const Icon(Icons.settings),
                              title: const Text('Change Password'),
                              onTap: () {
                                _changePassword(controller);
                                // Add navigation to settings screen
                              },
                            ),
                            ListTile(
                              leading: const Icon(Icons.logout),
                              title: const Text('Logout'),
                              onTap: () {
                                showToast(
                                    message: "User is successfully Signed Out");
                                controller.logout();
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const SignIn()),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            bottomNavigationBar: Container(
              height: 60.0,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color.fromARGB(255, 234, 187, 209),
                    Color.fromARGB(255, 252, 250, 251),
                  ],
                ),
              ),
              child: BottomAppBar(
                color: Colors.transparent,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.home,
                        color: _selectedIndex == 0
                            ? const Color.fromARGB(255, 255, 0, 204)
                            : Colors.black,
                      ),
                      onPressed: () => _onItemTapped(0),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.favorite,
                        color: _selectedIndex == 1
                            ? const Color.fromARGB(255, 255, 0, 204)
                            : Colors.black,
                      ),
                      onPressed: () => _onItemTapped(1),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.search_rounded,
                        color: _selectedIndex == 2
                            ? const Color.fromARGB(255, 255, 0, 204)
                            : Colors.black,
                      ),
                      onPressed: () => _onItemTapped(2),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.category,
                        color: _selectedIndex == 3
                            ? const Color.fromARGB(255, 255, 0, 204)
                            : Colors.black,
                      ),
                      onPressed: () => _onItemTapped(3),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.person,
                        color: _selectedIndex == 4
                            ? const Color.fromARGB(255, 255, 0, 204)
                            : Colors.black,
                      ),
                      onPressed: () => _onItemTapped(4),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Profile();
  }
}

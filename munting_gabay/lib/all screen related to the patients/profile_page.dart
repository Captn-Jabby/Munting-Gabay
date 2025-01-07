import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:munting_gabay/variable.dart';
import 'package:provider/provider.dart';

import '../models/current_user.dart';
import '../providers/current_user_provider.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({super.key});

  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  DateTime selectedDate = DateTime.now();

  void _loadUserData() {
    // WidgetsBinding.instance.addPostFrameCallback(
    //   (timeStamp) {
    // initialize provider
    final currentUser =
        Provider.of<CurrentUserProvider>(context, listen: false).currentUser!;

    _nameController.text = currentUser.name;
    _usernameController.text = currentUser.username;
    selectedDate = currentUser.birthdate;
    _addressController.text = currentUser.address;
    _emailController.text = currentUser.email;
    setState(() {});
    //   },
    // );
  }

  @override
  void initState() {
    _loadUserData();
    super.initState();
  }

  @override
  void dispose() {
    _nameController.clear();
    _usernameController.clear();
    _addressController.clear();
    _emailController.clear();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    // remove text field focus
    if (FocusScope.of(context).focusedChild != null) {
      FocusScope.of(context).focusedChild!.unfocus();
    }

    DateTime currentDate = DateTime.now();
    DateTime firstDate = DateTime(1900);
    DateTime lastDate = DateTime(2101);

    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: firstDate,
      lastDate: lastDate,
      selectableDayPredicate: (DateTime day) {
        return day.isBefore(currentDate) || day.isAtSameMomentAs(currentDate);
      },
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Future<void> _showAvatarSelectionDialog(
      {required CurrentUserProvider provider}) async {
    final ImagePicker picker = ImagePicker();

    await picker.pickImage(source: ImageSource.gallery).then(
      (pickedFile) {
        if (pickedFile != null) {
          provider.updateProfilePicture(
            context: context,
            file: File(pickedFile.path),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100], // Background color
      appBar: AppBar(
        backgroundColor: secondaryColor, // AppBar color
        title: const Text('Profile'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Consumer<CurrentUserProvider>(
            builder: (context, provider, snapshot) {
              final currentUser = provider.currentUser!;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(
                    child: GestureDetector(
                      onTap: () =>
                          _showAvatarSelectionDialog(provider: provider),
                      child: CircleAvatar(
                        radius: 60,
                        backgroundColor:
                            Colors.grey[300], // Default background color
                        backgroundImage: currentUser.avatarPath.isNotEmpty
                            ? NetworkImage(currentUser.avatarPath)
                            : null,
                        child: currentUser.avatarPath.isEmpty
                            ? Icon(
                                Icons.camera_alt,
                                size: 50,
                                color: Colors.grey[700],
                              )
                            : null,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  _buildTextField(controller: _nameController, label: 'Name'),
                  _buildTextField(
                      controller: _usernameController, label: 'Username'),
                  const SizedBox(height: 16.0),
                  GestureDetector(
                    onTap: () => _selectDate(context),
                    child: AbsorbPointer(
                      child: _buildTextField(
                        controller: TextEditingController(
                            text: "${selectedDate.toLocal()}".split(' ')[0]),
                        label: 'Birthdate',
                        suffixIcon: const Icon(Icons.calendar_today),
                      ),
                    ),
                  ),
                  _buildTextField(
                      controller: _addressController, label: 'Address'),
                  _buildTextField(
                      controller: _emailController,
                      label: 'Email',
                      enabled: false),
                  const SizedBox(height: 20.0),
                  SizedBox(
                    width: BtnWidth,
                    height: BtnHeight,
                    child: ElevatedButton(
                      onPressed: () {
                        final updatedProfile = CurrentUser(
                          id: currentUser.id,
                          name: _nameController.text,
                          username: _usernameController.text,
                          role: currentUser.role,
                          birthdate: selectedDate,
                          address: _addressController.text,
                          email: _emailController.text,
                          pinStatus: currentUser.pinStatus,
                          pin: currentUser.pin,
                          avatarPath: currentUser.avatarPath,
                        );

                        provider.updateUserData(
                          context: context,
                          currentUser: updatedProfile,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: secondaryColor, // Button color
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      child: Text(
                        'Save',
                        style: buttonTextStyle1,
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      {required TextEditingController controller,
      required String label,
      bool enabled = true,
      Widget? suffixIcon}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        enabled: enabled,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          suffixIcon: suffixIcon,
        ),
      ),
    );
  }
}

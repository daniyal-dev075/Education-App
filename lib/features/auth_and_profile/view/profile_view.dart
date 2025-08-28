import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../res/app_colors.dart';
import '../view_model/image_view_model.dart';
import '../../splash/view_model/navigation_view_model.dart';
import '../view_model/user_view_model.dart';
import '../view_model/auth_view_model.dart';
import '../../../res/components/loader.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserViewModel>(context);

    final userData = userProvider.userData;
    final name = userData?['name'] ?? "User";
    final email = userData?['email'] ?? "Not Provided";
    final phoneNumber = userData?['phoneNumber'] ?? "Not Provided";
    final profileImageUrl = userData?['profilePic'];

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Text(
          "Profile",
          style: TextStyle(
            color: AppColors.secondaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppColors.primaryColor,
      ),
      body: userProvider.isLoading
          ? const Center(
        child: Loader(),
      )
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Stack(
              children: [
                CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.grey[300],
                  backgroundImage: profileImageUrl != null
                      ? NetworkImage(profileImageUrl)
                      : null,
                  child: profileImageUrl == null
                      ? const Icon(Icons.person, size: 60, color: Colors.grey)
                      : null,
                ),
                Positioned(
                  bottom: 3,
                  right: 8,
                  child: InkWell(
                    onTap: () async {
                      final imageVM = Provider.of<ImageViewModel>(context, listen: false);

                      // Let user pick a new image
                      await imageVM.pickImage();

                      // If user picked an image, update Firestore
                      if (imageVM.pickedImage != null) {
                        final uid = FirebaseAuth.instance.currentUser!.uid;

                        // Call your existing method to update user data
                        context.read<AuthViewModel>().updateUserData(
                          uid: uid,
                          profileImage: imageVM.pickedImage,
                          context: context,
                        );

                        imageVM.clearImage();
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.edit, color: AppColors.secondaryColor, size: 20),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              name,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryColor,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              email,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 20),
            Card(
              color: AppColors.primaryColor,
              elevation: 4,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.person,
                          color: AppColors.secondaryColor),
                      trailing: IconButton(
                        icon: Icon(Icons.edit, color: AppColors.secondaryColor),
                        onPressed: () async {
                          final newName = await showDialog<String>(
                            context: context,
                            builder: (context) {
                              String tempName = "";
                              return AlertDialog(
                                backgroundColor: AppColors.secondaryColor,
                                title: Text("Edit Name",style: TextStyle(color: AppColors.primaryColor),),
                                content: TextField(
                                  cursorColor: AppColors.primaryColor,
                                  onChanged: (value) => tempName = value,
                                  decoration: InputDecoration(
                                      hintText: "Enter new name",
                                      hintStyle: TextStyle(color: Colors.white),
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: AppColors.primaryColor),
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: AppColors.primaryColor, width: 2),
                                    ),
                                  ),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: Text("Cancel",style: TextStyle(color: AppColors.primaryColor),),
                                  ),
                                  TextButton(
                                    onPressed: () => Navigator.pop(context, tempName),
                                    child: Text("Save",style: TextStyle(color: AppColors.primaryColor)),
                                  ),
                                ],
                              );
                            },
                          );

                          if (newName != null && newName.isNotEmpty) {
                            final uid = FirebaseAuth.instance.currentUser!.uid;
                            context.read<AuthViewModel>().updateUserData(
                              uid: uid,
                              name: newName,
                              context: context,
                            );
                          }
                        },
                      ),
                      title: const Text("Name",style: TextStyle(color: Colors.white),),
                      subtitle: Text(name,style: TextStyle(color: AppColors.secondaryColor),),
                    ),
                    const Divider(),
                    ListTile(
                      leading: const Icon(Icons.email,
                          color: AppColors.secondaryColor),
                      trailing: IconButton(
                        icon: Icon(Icons.edit, color: AppColors.secondaryColor),
                        onPressed: () async {
                          final newEmail = await showDialog<String>(
                            context: context,
                            builder: (context) {
                              String tempEmail = "";
                              return AlertDialog(
                                backgroundColor: AppColors.secondaryColor,
                                title: Text(
                                  "Edit Email",
                                  style: TextStyle(color: AppColors.primaryColor),
                                ),
                                content: TextField(
                                  cursorColor: AppColors.primaryColor,
                                  onChanged: (value) => tempEmail = value,
                                  keyboardType: TextInputType.emailAddress,
                                  decoration: InputDecoration(
                                    hintText: "Enter new email",
                                    hintStyle: TextStyle(color: Colors.white),
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: AppColors.primaryColor),
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: AppColors.primaryColor, width: 2),
                                    ),
                                  ),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: Text(
                                      "Cancel",
                                      style: TextStyle(color: AppColors.primaryColor),
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () => Navigator.pop(context, tempEmail),
                                    child: Text(
                                      "Save",
                                      style: TextStyle(color: AppColors.primaryColor),
                                    ),
                                  ),
                                ],
                              );
                            },
                          );

                          if (newEmail != null && newEmail.isNotEmpty) {
                            final uid = FirebaseAuth.instance.currentUser!.uid;
                            context.read<AuthViewModel>().updateUserData(
                              uid: uid,
                              email: newEmail,
                              context: context,
                            );
                          }
                        },
                      ),
                      title: const Text("Email",style: TextStyle(color: Colors.white)),
                      subtitle: Text(email,style: TextStyle(color: AppColors.secondaryColor)),
                    ),
                    const Divider(),
                    ListTile(
                      leading: const Icon(Icons.phone,
                          color: AppColors.secondaryColor),
                      trailing: IconButton(
                        icon: Icon(Icons.edit, color: AppColors.secondaryColor),
                        onPressed: () async {
                          final newPhone = await showDialog<String>(
                            context: context,
                            builder: (context) {
                              String tempPhone = "";
                              return AlertDialog(
                                backgroundColor: AppColors.secondaryColor,
                                title: Text(
                                  "Edit Phone Number",
                                  style: TextStyle(color: AppColors.primaryColor),
                                ),
                                content: TextField(
                                  cursorColor: AppColors.primaryColor,
                                  onChanged: (value) => tempPhone = value,
                                  keyboardType: TextInputType.phone,
                                  decoration: InputDecoration(
                                    hintText: "Enter new phone number",
                                    hintStyle: TextStyle(color: Colors.white),
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: AppColors.primaryColor),
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: AppColors.primaryColor, width: 2),
                                    ),
                                  ),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: Text(
                                      "Cancel",
                                      style: TextStyle(color: AppColors.primaryColor),
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () => Navigator.pop(context, tempPhone),
                                    child: Text(
                                      "Save",
                                      style: TextStyle(color: AppColors.primaryColor),
                                    ),
                                  ),
                                ],
                              );
                            },
                          );

                          if (newPhone != null && newPhone.isNotEmpty) {
                            final uid = FirebaseAuth.instance.currentUser!.uid;
                            context.read<AuthViewModel>().updateUserData(
                              uid: uid,
                              phoneNumber: newPhone,
                              context: context,
                            );
                          }
                        },
                      ),

                      title: const Text("Phone Number",style: TextStyle(color: Colors.white)),
                      subtitle: Text(phoneNumber,style: TextStyle(color: AppColors.secondaryColor)),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed: () {
                context.read<AuthViewModel>().logout(context);
              },
              icon: const Icon(Icons.logout, color: AppColors.secondaryColor),
              label: const Text("Logout",style: TextStyle(color: Colors.white),),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColor,
                padding: const EdgeInsets.symmetric(
                    horizontal: 40, vertical: 12),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

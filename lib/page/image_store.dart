 import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:ad_ad/Helper/ad_helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../model/chatuser.dart';

class ImageStore extends StatefulWidget {
   const ImageStore({super.key});
 
   @override
   State<ImageStore> createState() => _ImageStoreState();
 }
 
 class _ImageStoreState extends State<ImageStore> {

   final ImagePicker picker = ImagePicker();
   String? image;
   File? imageCamera;
   Uint8List? imageGallery;
   String? _image;


   static FirebaseStorage storage = FirebaseStorage.instance;
   static User get user => auth.currentUser!;
   static FirebaseAuth auth = FirebaseAuth.instance;
   static late ChatUser me;
   static FirebaseFirestore firestore = FirebaseFirestore.instance;
  
   @override
   Widget build(BuildContext context) {
     return Scaffold(
       body: Center(
         child: Column(
           crossAxisAlignment: CrossAxisAlignment.center,
           mainAxisAlignment: MainAxisAlignment.center,
           children: [
             ElevatedButton(onPressed: (){}, child: Text("add user")),

             ElevatedButton(onPressed: (){}, child: Text("select")),
             Column(
               children: [
                 Container(
                   decoration: BoxDecoration(
                       shape: BoxShape.circle,
                       border: Border.all(
                           color: Colors.blueGrey,
                           width: 1)),
                   child: IconButton(
                     onPressed: () async {
                       final ImagePicker picker = ImagePicker();
                       final XFile? image =
                       await picker.pickImage(source: ImageSource.camera,imageQuality: 100);

                       if (image != null) {
                         log('Image Path: ${image.path} -- MimeType: ${image.mimeType}');

                         setState(() {
                           _image = image.path;
                         });
                         updateProfilePicture(File(_image!));
                         Navigator.pop(context);
                       }
                     },
                     color: Colors.pink,
                     style: ButtonStyle(),
                     icon: Icon(Icons.camera_alt_rounded),
                   ),
                 ),
                 SizedBox(
                   height: 5,
                 ),
                 Text(
                   "Camera",
                   style: TextStyle(color: Colors.deepPurple),
                 ),
               ],
             ),
           ],
         ),
       ),
     );
   }


   static Future<void> updateProfilePicture(File file) async {
     final ext = file.path.split('.').last;
     String image = "asset/image/chatappicon.png";
     print('Extension: $ext');
     final ref = storage.ref().child('profile_picture/$image');
     await ref
         .putFile(file, SettableMetadata(contentType: 'image/$ext'))
         .then((p0) {
       print("Data Transferres: ${p0.bytesTransferred / 1000} kb");
     });

     me.image = await ref.getDownloadURL();
     await firestore
         .collection('users')
         .doc(user.uid)
         .update({'image': me.image, 'email': me.email});
   }
 }
 
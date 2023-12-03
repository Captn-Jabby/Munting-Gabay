import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:photo_view/photo_view.dart';

import '../drawer_page.dart';
import '../variable.dart';

class DoctorDetailsScreen extends StatefulWidget {
  final String docId;
  final String initialName;
  final String initialAddress;
  final String initialBirthdate;
  final String initialStatus;
  final String clinic; // Add clinic argument
  final String addressHospital; // Add addressHospital argument
  final String imageUrl;
  final String imageUrl2;
  final String profilepic;

  DoctorDetailsScreen({
    required this.imageUrl,
    required this.imageUrl2,
    required this.clinic,
    required this.addressHospital,
    required this.docId,
    required this.initialName,
    required this.initialAddress,
    required this.initialBirthdate,
    required this.initialStatus,
    required this.profilepic,
  });

  @override
  _DoctorDetailsScreenState createState() => _DoctorDetailsScreenState();
}

class _DoctorDetailsScreenState extends State<DoctorDetailsScreen> {
  late String currentStatus;
  late String selectedStatus;

  @override
  void initState() {
    super.initState();
    currentStatus = widget.initialStatus;
    selectedStatus = widget.initialStatus;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: scaffoldBgColor,
      appBar: AppBar(
        backgroundColor: scaffoldBgColor,
        elevation: 0,
        toolbarHeight: 150,
        iconTheme: IconThemeData(color: BtnColor),
        actions: [
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/A.png', // Replace with the path to your first image
                  width: 130,
                  height: 150,
                ),
                SizedBox(width: 60), // Add spacing between images
                Image.asset(
                  'assets/LOGO.png',
                  height: 150,
                  width: 130,
                ),
                SizedBox(width: 40),
              ],
            ),
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'DOCTORS INFORMATION',
              style: buttonTextStyle,
            ),
            Divider(
              color: Colors.black,
              thickness: 2.0,
            ),
            SizedBox(
              height: BtnSpacing,
            ),
            Text('Doctor ID: ${widget.docId}',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 16),
            Text('Name: ${widget.initialName}', style: TextStyle(fontSize: 16)),
            SizedBox(height: 16),
            Text('Address: ${widget.initialAddress}',
                style: TextStyle(fontSize: 16)),
            SizedBox(height: 16),
            Text('Birthdate: ${widget.initialBirthdate}',
                style: TextStyle(fontSize: 16)),
            SizedBox(height: 16),
            Text('Clinic Adress: ${widget.addressHospital}',
                style: TextStyle(fontSize: 16)),
            SizedBox(height: 16),
            Text('Clinic Name: ${widget.clinic}',
                style: TextStyle(fontSize: 16)),
            SizedBox(height: 16),
            Text('Identification:', style: TextStyle(fontSize: 16)),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ZoomableImage(widget.imageUrl),
                  ),
                );
              },
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(8.0),
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(
                      widget.imageUrl,
                    ),
                  ),
                ),
                child: Hero(
                  tag: widget.imageUrl,
                  child: Image.network(
                    widget.imageUrl,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),

            Text('lICENSURE:', style: TextStyle(fontSize: 16)),
            // if (widget.imageUrl2 !=
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ZoomableImage(widget.imageUrl2),
                  ),
                );
              },
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(8.0),
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(
                      widget.imageUrl2,
                    ),
                  ),
                ),
                child: Hero(
                  tag: widget.imageUrl2,
                  child: Image.network(
                    widget.imageUrl2,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),

            Text('Profile pic:', style: TextStyle(fontSize: 16)),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ZoomableImage(widget.profilepic),
                  ),
                );
              },
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(8.0),
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(
                      widget.profilepic,
                    ),
                  ),
                ),
                child: Hero(
                  tag: widget.profilepic,
                  child: Image.network(
                    widget.profilepic,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),

            Text('Status:', style: TextStyle(fontSize: 16)),
            Row(
              children: [
                Radio(
                  value: 'Accepted',
                  groupValue: selectedStatus,
                  onChanged: (value) {
                    setState(() {
                      selectedStatus = value.toString();
                    });
                  },
                ),
                Text('Accepted'),
                Radio(
                  value: 'Waiting',
                  groupValue: selectedStatus,
                  onChanged: (value) {
                    setState(() {
                      selectedStatus = value.toString();
                    });
                  },
                ),
                Text('Denied'),
              ],
            ),
            ElevatedButton(
              onPressed: () {
                // Update the status in Firestore
                FirebaseFirestore.instance
                    .collection('usersdata')
                    .doc(widget.docId)
                    .update({
                  'status': selectedStatus,
                }).then((_) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Status updated!'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                }).catchError((error) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Failed to update status.'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                });
              },
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}

class ZoomableImage extends StatelessWidget {
  final String imageUrl;

  ZoomableImage(this.imageUrl);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: secondaryColor,
      ),
      body: Center(
        child: Hero(
          tag: imageUrl,
          child: PhotoView(
            imageProvider: NetworkImage(imageUrl),
          ),
        ),
      ),
    );
  }
}

class ZoomableImage1 extends StatelessWidget {
  final String imageUrl2;

  ZoomableImage1(this.imageUrl2);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: secondaryColor,
      ),
      body: Center(
        child: Hero(
          tag: imageUrl2,
          child: PhotoView(
            imageProvider: NetworkImage(imageUrl2),
          ),
        ),
      ),
    );
  }
}

class ZoomableImage2 extends StatelessWidget {
  final String profilepic;

  ZoomableImage2(this.profilepic);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: secondaryColor,
      ),
      body: Center(
        child: Hero(
          tag: profilepic,
          child: PhotoView(
            imageProvider: NetworkImage(profilepic),
          ),
        ),
      ),
    );
  }
}

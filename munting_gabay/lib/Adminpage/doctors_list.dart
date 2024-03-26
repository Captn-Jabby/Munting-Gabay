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

  const DoctorDetailsScreen({super.key, 
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
        iconTheme: IconThemeData(color: scaffoldBgColor),
      ),
      drawer: AppDrawer(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'DOCTORS INFORMATION',
              style: buttonTextStyle1,
            ),
            const Divider(
              color: Colors.black,
              thickness: 2.0,
            ),
            const SizedBox(
              height: BtnSpacing,
            ),
            Text('Doctor ID: ${widget.docId}',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Text('Name: ${widget.initialName}', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 16),
            Text('Address: ${widget.initialAddress}',
                style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 16),
            Text('Birthdate: ${widget.initialBirthdate}',
                style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 16),
            Text('Clinic Adress: ${widget.addressHospital}',
                style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 16),
            Text('Clinic Name: ${widget.clinic}',
                style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 16),
            const Text('Identification:', style: TextStyle(fontSize: 16)),
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

            const Text('lICENSURE:', style: TextStyle(fontSize: 16)),
            // if (widget.imageUrl2 !=
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ZoomableImage1(widget.imageUrl2),
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

            const Text('Profile pic:', style: TextStyle(fontSize: 16)),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ZoomableImage2(widget.profilepic),
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

            const Text('Status:', style: TextStyle(fontSize: 16)),
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
                const Text('Accepted'),
                Radio(
                  value: 'Waiting',
                  groupValue: selectedStatus,
                  onChanged: (value) {
                    setState(() {
                      selectedStatus = value.toString();
                    });
                  },
                ),
                const Text('Denied'),
              ],
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: scaffoldBgColor, // Change this color to the desired background color
              ),
              onPressed: () {
                // Update the status in Firestore
                FirebaseFirestore.instance
                    .collection('users')
                    .doc(widget.docId)
                    .update({
                  'status': selectedStatus,
                }).then((_) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Status updated!'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                }).catchError((error) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Failed to update status.'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                });
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}

class ZoomableImage extends StatelessWidget {
  final String imageUrl;

  const ZoomableImage(this.imageUrl, {super.key});

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

  const ZoomableImage1(this.imageUrl2, {super.key});

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

  const ZoomableImage2(this.profilepic, {super.key});

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

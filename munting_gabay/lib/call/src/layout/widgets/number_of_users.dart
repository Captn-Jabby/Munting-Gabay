import 'package:flutter/material.dart';

/// Displays the number of users present inside the channel.
class NumberOfUsers extends StatefulWidget {
  final int userCount;

  const NumberOfUsers({
    Key? key,
    this.userCount = 0,
  }) : super(key: key);

  @override
  State<NumberOfUsers> createState() => _NumberOfUsersState();
}

class _NumberOfUsersState extends State<NumberOfUsers> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        color: Colors.black54,
        padding: const EdgeInsets.all(3),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.remove_red_eye_outlined,
              color: Colors.white,
            ),
            Text(
              ' ${widget.userCount + 1}',
              style: const TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}

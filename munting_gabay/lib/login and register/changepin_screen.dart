import 'package:flutter/material.dart';
import 'package:munting_gabay/variable.dart';
import 'package:provider/provider.dart';

import '../providers/current_user_provider.dart';

class ChangePin extends StatefulWidget {
  const ChangePin({super.key, Key});

  @override
  _ChangePinState createState() => _ChangePinState();
}

class _ChangePinState extends State<ChangePin> {
  final TextEditingController _currentPinCtrl = TextEditingController();
  final TextEditingController _newPinCtrl = TextEditingController();
  bool _hideCurrentPin = true;
  bool _hideNewPin = true;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _currentPinCtrl.clear();
    _newPinCtrl.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: scaffoldBgColor,
      appBar: AppBar(
        backgroundColor: secondaryColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
        title: const Text('Change PIN'),
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: CustomScrollView(
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Consumer<CurrentUserProvider>(
                  builder: (context, provider, child) {
                    return Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          TextFormField(
                            controller: _currentPinCtrl,
                            obscureText: _hideCurrentPin,
                            keyboardType: TextInputType.number,
                            textInputAction: TextInputAction.next,
                            maxLength: 4,
                            decoration: InputDecoration(
                              labelText: 'Current PIN',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              suffixIcon: IconButton(
                                focusNode: FocusNode(skipTraversal: true),
                                onPressed: () {
                                  _hideCurrentPin = !_hideCurrentPin;
                                  setState(() {});
                                },
                                icon: Icon(
                                  _hideCurrentPin
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                ),
                              ),
                            ),
                            validator: (value) {
                              if (value == "") {
                                return "Current PIN is required.";
                              }
                              if (value?.length != 4) {
                                return "Current PIN should be 4 characters long";
                              }
                              if (value != provider.currentUser!.pin) {
                                return "Invalid PIN.";
                              }

                              return null;
                            },
                          ),
                          const SizedBox(height: 10.0),
                          TextFormField(
                            controller: _newPinCtrl,
                            obscureText: _hideNewPin,
                            keyboardType: TextInputType.number,
                            textInputAction: TextInputAction.done,
                            maxLength: 4,
                            decoration: InputDecoration(
                              labelText: 'New PIN',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              suffixIcon: IconButton(
                                focusNode: FocusNode(skipTraversal: true),
                                onPressed: () {
                                  _hideNewPin = !_hideNewPin;
                                  setState(() {});
                                },
                                icon: Icon(
                                  _hideNewPin
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                ),
                              ),
                            ),
                            validator: (value) {
                              if (value == "") {
                                return "New PIN is required.";
                              }
                              if (value?.length != 4) {
                                return "New PIN should be 4 characters long";
                              }
                              if (value == _currentPinCtrl.text) {
                                return "Should not be equal to current PIN.";
                              }

                              return null;
                            },
                          ),
                          const SizedBox(height: 20.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GestureDetector(
                                onTap: () {},
                                child: Text(
                                  provider.currentUser!.pinStatus
                                      ? 'PIN Enabled'
                                      : 'PIN Disabled',
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  provider.updatePinStatus(
                                    context: context,
                                    pinStatus: !provider.currentUser!.pinStatus,
                                  );
                                },
                                child: Container(
                                  width: 50, // Adjust width as needed
                                  height: 30, // Adjust height as needed
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(
                                        15), // Adjust border radius as needed
                                    color: provider.currentUser!.pinStatus
                                        ? Colors.green
                                        : Colors
                                            .grey, // Adjust colors as needed
                                  ),
                                  child: Center(
                                    child: Text(
                                      provider.currentUser!.pinStatus
                                          ? 'ON'
                                          : 'OFF',
                                      style: const TextStyle(
                                        color: Colors
                                            .white, // Adjust text color as needed
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          SizedBox(
                            width: BtnWidth,
                            height: BtnHeight,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    secondaryColor, // Change this color to the desired background color
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  provider
                                      .updatePin(
                                    context: context,
                                    pin: _newPinCtrl.text,
                                  )
                                      .then(
                                    (value) {
                                      if (value) {
                                        _currentPinCtrl.clear();
                                        _newPinCtrl.clear();
                                      }
                                    },
                                  );
                                }
                              },
                              child: Text(
                                'Change PIN',
                                style: buttonTextStyle1,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

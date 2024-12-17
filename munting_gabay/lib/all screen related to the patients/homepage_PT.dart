import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:munting_gabay/all%20screen%20related%20to%20the%20patients/screens/kids%20page/Kids_page.dart';
import 'package:munting_gabay/all%20screen%20related%20to%20the%20patients/screens/parents%20page/Parent_page.dart';
import 'package:munting_gabay/drawer_page.dart';
import 'package:munting_gabay/login%20and%20register/login.dart';
import 'package:munting_gabay/login%20and%20register/pincode.dart';
import 'package:munting_gabay/variable.dart';
import 'package:provider/provider.dart';

import '../providers/current_user_provider.dart';

class HomepagePT extends StatefulWidget {
  const HomepagePT({super.key, Key});

  @override
  State<HomepagePT> createState() => _HomepagePTState();
}

class _HomepagePTState extends State<HomepagePT> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: scaffoldBgColor,
        appBar: AppBar(
          backgroundColor: scaffoldBgColor,
          elevation: 0,
          iconTheme: const IconThemeData(color: text),
        ),
        drawer: AppDrawer(),
        body: CustomScrollView(
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Container(
                padding:
                    const EdgeInsets.fromLTRB(20, kToolbarHeight + 20, 20, 20),
                child: Column(
                  children: [
                    Column(
                      children: [
                        const Center(
                          child: SpinningContainer(),
                        ),
                        Text(
                          'Munting Gabay',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                              letterSpacing: 2,
                              textStyle: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 40,
                                color: secondaryColor,
                              )),
                        ),
                        Text(
                          'An Autism Aid and Awareness App',
                          style: smallTextStyle1,
                        ),
                      ],
                    ),
                    Expanded(
                      child: Container(
                        constraints: const BoxConstraints(
                          minHeight: 32,
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/hands.png',
                          width: LOGOSIZE,
                          height: LOGOSIZE,
                        ),
                        const SizedBox(
                          width: lOGOSpacing,
                        ),
                        SizedBox(
                          width: BtnWidth - minus,
                          height: BtnHeight,
                          child: ElevatedButton(
                            onPressed: () {
                              final currentUser =
                                  Provider.of<CurrentUserProvider>(context,
                                          listen: false)
                                      .currentUser!;

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => currentUser.pinStatus
                                      ? const PinScreen()
                                      : const ParentPage(),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: secondaryColor,
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(BtnCircularRadius),
                              ),
                            ),
                            child: Text(
                              'Parents',
                              style: buttonTextStyle1,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: BtnSpacing),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/playtime.png',
                          width: LOGOSIZE,
                          height: LOGOSIZE,
                        ),
                        const SizedBox(
                          width: lOGOSpacing,
                        ),
                        Container(
                          width: BtnWidth - minus,
                          height: BtnHeight,
                          decoration: BoxDecoration(
                            color: secondaryColor,
                            borderRadius:
                                BorderRadius.circular(BtnCircularRadius),
                          ),
                          child: TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const KidsPage(),
                                ),
                              );
                            },
                            child: Text(
                              'Child',
                              style: buttonTextStyle1,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ));
  }
}

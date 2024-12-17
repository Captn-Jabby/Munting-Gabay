import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:munting_gabay/GettingStarted/getting_started.dart';
import 'package:munting_gabay/login%20and%20register/login.dart';
import 'package:munting_gabay/login%20and%20register/register_patients.dart';
import 'package:munting_gabay/all%20screen%20related%20to%20the%20patients/homepage_PT.dart';
import 'package:munting_gabay/variable.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

import 'providers/current_user_provider.dart';
import 'providers/doctor_provider.dart';
import 'providers/schedule_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Hive.registerAdapter<Color>(ColorAdapter()); // Register the ColorAdapter
  await Hive.initFlutter();
  await Hive.openBox<Color>('colors'); // Open a box to store colors
  runApp(const MyApp());
}

void configLoading() {
  EasyLoading.instance
    ..indicatorType = EasyLoadingIndicatorType.circle
    ..userInteractions = false
    ..loadingStyle = EasyLoadingStyle.dark
    ..maskType = EasyLoadingMaskType.black
    ..dismissOnTap = false;
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<CurrentUserProvider>(
          create: (context) => CurrentUserProvider(),
        ),
        ChangeNotifierProxyProvider<CurrentUserProvider, DoctorProvider>(
          create: (context) => DoctorProvider(
            provider: Provider.of<CurrentUserProvider>(context, listen: false),
          ),
          update: (context, auth, doctor) =>
              doctor ?? DoctorProvider(provider: auth),
        ),
        ChangeNotifierProxyProvider2<CurrentUserProvider, DoctorProvider,
            ScheduleProvider>(
          create: (context) => ScheduleProvider(
            currentUserProvider:
                Provider.of<CurrentUserProvider>(context, listen: false),
            doctorProvider: Provider.of<DoctorProvider>(context, listen: false),
          ),
          update: (context, auth, doctor, schedule) =>
              schedule ??
              ScheduleProvider(
                currentUserProvider: auth,
                doctorProvider: doctor,
              ),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "Munting Gabay",
        home: Consumer<CurrentUserProvider>(
          builder: (context, provider, child) {
            final auth = provider.getAuth;

            if (auth == null) {
              return const LoginScreen();
            }

            if (provider.isCurrentUserLoading) {
              return const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(LoadingColor),
                  strokeWidth: 4,
                  backgroundColor: bgloadingColor,
                ),
              );
            }

            return const HomepagePT();
          },
        ),
        builder: EasyLoading.init(),
      ),
    );
  }
}

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: mainBackgroundTheme,
        padding: const EdgeInsets.fromLTRB(20, kToolbarHeight + 20, 20, 20),
        child: CustomScrollView(
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Center(
                    child: SpinningContainer(),
                  ),
                  Text(
                    'Munting Gabay',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      letterSpacing: 2,
                      textStyle: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 40,
                        color: Color(0xFF95C440),
                      ),
                    ),
                  ),
                  Text(
                    'An Autism Aid and Awareness App',
                    style: smallTextStyle1,
                  ),

                  // add spacing with default value for smaller screens
                  Expanded(
                    child: Container(
                      constraints: const BoxConstraints(
                        minHeight: 32,
                      ),
                    ),
                  ),

                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: BtnHeight,
                        width: BtnWidth,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const GettingStarted(),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF95C440),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
                          ),
                          child: Text(
                            'Get Started',
                            style: buttonTextStyle1,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 21,
                      ),
                      SizedBox(
                        width: BtnWidth,
                        height: BtnHeight,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const LoginPage(),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFFDFDFE),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
                          ),
                          child: Text(
                            "Login",
                            style: buttonTextStyle2,
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'New around here?',
                            style: smallTextStyle2,
                          ),
                          TextButton(
                            onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const RegistrationPatients(),
                              ),
                            ),
                            child: Text(
                              'Sign up',
                              style: smallTextStyle3,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SpinningContainer extends StatefulWidget {
  const SpinningContainer({super.key});

  @override
  _SpinningContainerState createState() => _SpinningContainerState();
}

class _SpinningContainerState extends State<SpinningContainer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(
          minutes: 1), // Set the duration for one complete rotation
    )..repeat(); // Repeat the animation infinitely
  }

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: _controller,
      child: Container(
        height: MediaQuery.of(context).size.height / 4,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              "assets/images/world.png",
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

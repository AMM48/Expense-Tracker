import 'dart:io';
import 'package:client/badgesPage.dart';
import 'package:client/classes/badges.dart';
import 'package:client/classes/client_transaction.dart';
import 'package:client/classes/goal.dart';
import 'package:client/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:client/login.dart';
import 'package:client/register.dart';
import 'package:client/overview.dart';
import 'package:client/Home.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:client/classes/auth.dart';
import 'package:flutter/services.dart';
import 'package:workmanager/workmanager.dart';
import 'firebase_options.dart';
import 'package:provider/provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:telephony/telephony.dart';
import 'notifications.dart';
import 'wordExtract.dart';
import 'model.dart';
import 'package:http/http.dart' as http;

// @pragma('vm:entry-point')
backgroundMessageHandler(SmsMessage message) async {
  WidgetsFlutterBinding.ensureInitialized();
  bool needsWeb = Platform.isLinux | Platform.isWindows;
  try {
    await Firebase.initializeApp(
      options: needsWeb
          ? DefaultFirebaseOptions.web
          : DefaultFirebaseOptions.currentPlatform,
    );
  } on FirebaseException catch (_, e) {}
  final a = TransactionDB();

  await a.initT();
  List<String> token = [await Notifications.getToken()];
  if (message.address == "SNB-AlAhli" && Auth().currentUser != null) {
    if (message.body!.toLowerCase().startsWith("شراء") ||
        message.body!.toLowerCase().startsWith("purchase") ||
        message.body!.toLowerCase().startsWith("pos purchase")) {
      try {
        var result = extractAlahli(message.body!.toLowerCase());
        var client = http.Client();
        var category = await fetchCategory(message.body!, client);
        var categoryClean = category["category"].replaceAll('"', '');
        if (categoryClean == "Transportation") {
          categoryClean = "Transit";
        }
        var merchantName = result[0];
        var price = result[1];
        a.addTransaction(merchantName, categoryClean, price,
            "${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}");
        if (category["probability"] < 50.0) {
          String title = 'Transaction Added - Category Alert';
          String body =
              'Your latest Transaction from ${merchantName.toUpperCase()} has been Added Successfully, but the category may need your attention. Please check it manually.\n\nCategory: $categoryClean';
          Notifications.sendNotification(title, body, token);
        } else {
          Notifications.sendNotification(
              'Transaction Added',
              'Your latest Transaction from ${merchantName.toUpperCase()} has been Added Successfully\n\nCategory: $categoryClean',
              token);
        }
      } catch (e) {
        Notifications.sendNotification('Failed to Add Latest Transaction',
            'Please add it manually', token);
      }
    } else if (message.body!.toLowerCase().startsWith("دفع") ||
        message.body!.toLowerCase().startsWith("سداد")) {
      try {
        var result = extractAlahli(message.body!.toLowerCase());
        var merchantName = result[0];
        var price = result[1];
        a.addTransaction(merchantName, "Bills", price,
            "${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}");
        Notifications.sendNotification(
            'Bill Added',
            'Your latest Bill from ${merchantName.toUpperCase()} has been Added Successfully',
            token);
      } catch (e) {
        Notifications.sendNotification(
            'Failed to Add Latest Bill', 'Please add it manually', token);
      }
    }
  }
}

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    bool needsWeb = Platform.isLinux | Platform.isWindows;
    try {
      await Firebase.initializeApp(
        options: needsWeb
            ? DefaultFirebaseOptions.web
            : DefaultFirebaseOptions.currentPlatform,
      );
    } on FirebaseException catch (_, e) {}

    final a = TransactionDB();
    await a.initT();
    final g = GoalDB();
    final b = BadgesDB();
    try {
      var goals = g.getGoal();
      var successGoals = g.getSuccessGoals();
      if (goals.isNotEmpty) {
        if (goals[goals.length - 1].status == "null") {
          g.editGoal(goals[goals.length - 1]);
          if (successGoals.length.isOdd) {
            var badge = b.getBadge(successGoals.length);
            if (!badge.isUnlocked) {
              b.unlockBadge(badge);
              List<String> token = [await Notifications.getToken()];
              await Notifications.sendNotification(
                  'Badge Unlocked',
                  'Congratulations you just unlocked the ${badge.title} Badge.',
                  token);
            }
          }
        }
      }
      return Future.value(true);
    } catch (e) {
      return Future.value(false);
    }
  });
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  bool needsWeb = Platform.isLinux | Platform.isWindows;
  try {
    await Firebase.initializeApp(
      options: needsWeb
          ? DefaultFirebaseOptions.web
          : DefaultFirebaseOptions.currentPlatform,
    );
    await Notifications().initNotifications();
    if (Platform.isAndroid) {
      Workmanager().initialize(callbackDispatcher, isInDebugMode: false);

      Workmanager().registerPeriodicTask(
        "Unlock Badge",
        "Unlock Badge",
        frequency: const Duration(minutes: 15),
        initialDelay: const Duration(minutes: 2),
      );
    }
  } on FirebaseException catch (_, e) {
    // showErrorSnackbar(cont!, e.toString());
  }

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final iconMap = <String, IconData>{
    'Coffee': Icons.coffee_outlined,
    'Transit': Icons.local_gas_station_outlined,
    'Health': Icons.health_and_safety_outlined,
    'Food': Icons.fastfood_outlined,
    'Grocery': Icons.shopping_basket_outlined,
    'Shopping': Icons.shopping_bag_outlined,
    'Bills': Icons.receipt_outlined
  };
  final colorMap = <String, Color>{
    'Coffee': Colors.brown,
    'Transit': Colors.indigo,
    'Health': Colors.green,
    'Food': Colors.orange,
    'Grocery': Colors.lightBlueAccent,
    'Shopping': Colors.deepOrange,
    'Bills': Colors.purple,
  };
  int _selectedIndex = 1;
  final a = TransactionDB();
  final b = BadgesDB();
  // ignore: unused_field
  bool _isLoggedIn = false;
  bool _isInitialized = false;
  Future<void> initializeRealm() async {
    try {
      if (!_isInitialized) {
        await a.initT();
        _isInitialized = true;
      }
      b.listenToGoalChanges();
    } catch (e) {
      // showErrorSnackbar(context, e.toString());
    }
    return;
  }

  List<Widget> get _widgetOptions => [
        OverviewPage(iconMap: iconMap, colorMap: colorMap),
        HomePage(iconMap: iconMap, colorMap: colorMap),
        const BadgesPage(),
      ];
  String pageTitle = 'Home';
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;

      if (index == 0) {
        pageTitle = 'Overview';
      } else if (index == 1) {
        pageTitle = 'Home';
      } else if (index == 2) {
        pageTitle = 'Badges';
      }
    });
  }

  void _login() {
    try {
      setState(() {
        _isLoggedIn = true;
        _selectedIndex = 1;
        _isInitialized = false;
        pageTitle = 'Home';
      });
    } catch (e) {
      // showErrorSnackbar(context, e.toString());
    }
  }

  void initState() {
    super.initState();
    if (Platform.isAndroid) {
      _requestSmsPermission();
    }
  }

  Future<void> _requestSmsPermission() async {
    var b = await Permission.sms.request();

    if (b.isGranted) {
      final Telephony telephony = Telephony.instance;
      telephony.listenIncomingSms(
        onNewMessage: (SmsMessage message) async {
          if (message.address == "SNB-AlAhli" && Auth().currentUser != null) {
            if (message.body!.toLowerCase().startsWith("شراء") ||
                message.body!.toLowerCase().startsWith("purchase") ||
                message.body!.toLowerCase().startsWith("pos purchase")) {
              try {
                var result = extractAlahli(message.body!.toLowerCase());
                var client = http.Client();
                var category = await fetchCategory(message.body!, client);
                var categoryClean = category["category"].replaceAll('"', '');
                if (categoryClean == "Transportation") {
                  categoryClean = "Transit";
                }
                var merchantName = result[0];
                var price = result[1];
                a.addTransaction(merchantName, categoryClean, price,
                    "${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}");
                // showSuccessSnackbar(
                // context, "Successfully Added Latest Transaction");
              } catch (e) {
                // showErrorSnackbar(context, "Failed to Add Latest Transaction");
              }
            } else if (message.body!.toLowerCase().startsWith("دفع") ||
                message.body!.toLowerCase().startsWith("سداد")) {
              try {
                var result = extractAlahli(message.body!.toLowerCase());
                var merchantName = result[0];
                var price = result[1];
                a.addTransaction(merchantName, "Bills", price,
                    "${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}");
                // showSuccessSnackbar(context, "Successfully Added Latest Bill");
              } catch (e) {
                // showErrorSnackbar(context, "Failed to Add Latest Bill");
              }
            }
          }
        },
        onBackgroundMessage: backgroundMessageHandler,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (Platform.isAndroid) {
      _requestSmsPermission();
    }
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MultiProvider(
      providers: [
        Provider<Auth>(
          create: (_) => Auth(),
        ),
        StreamProvider(
          create: (context) => context.read<Auth>().authStateChanges,
          initialData: null,
        )
      ],
      child: MaterialApp(
        title: 'Expense Tracker',
        theme: ThemeData(
          primarySwatch: Colors.green,
        ),
        home: FutureBuilder<void>(
          future: initializeRealm(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Scaffold(
                body: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Lottie.asset('assets/Animation - 1699328436970.json'),
                      const SizedBox(height: 16.0),
                      const Text("Loading your data",
                          style: TextStyle(
                            fontSize: 24.0,
                            color: Colors.grey,
                          )),
                    ],
                  ),
                ),
              );
            } else if (snapshot.hasError || Auth().currentUser == null) {
              return LoginPage(onUserLoggedIn: _login);
            }
            return Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                leading: _selectedIndex == 0
                    ? IconButton(
                        icon: const Icon(Icons.file_download),
                        onPressed: () {
                          try {
                            var v = a.exportTransactions();
                            if (v == "null") {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content:
                                      Text('No transactions to be exported'),
                                  duration: Duration(seconds: 2),
                                ),
                              );
                              return;
                            } else {
                              showSuccessSnackbar(context,
                                  "Transactions Exported Successfully");
                            }
                          } catch (e) {
                            showErrorSnackbar(
                                context, "Failed to export transactions");
                          }
                        },
                      )
                    : null,
                title: Center(
                  child: Padding(
                    padding: _selectedIndex == 0
                        ? EdgeInsets.zero
                        : const EdgeInsets.only(left: 48.0),
                    child: Text(
                      pageTitle,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 21.0,
                      ),
                    ),
                  ),
                ),
                iconTheme: const IconThemeData(),
                bottom: const PreferredSize(
                  preferredSize: Size.fromHeight(1.0),
                  child: Divider(
                    color: Colors.grey,
                    thickness: 1,
                  ),
                ),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.logout),
                    color: Colors.red,
                    onPressed: () {
                      try {
                        setState(() {
                          Auth().signOut();
                        });
                      } catch (e) {
                        showErrorSnackbar(context, e.toString());
                      }
                    },
                  ),
                ],
              ),
              body: _widgetOptions[_selectedIndex],
              bottomNavigationBar: Visibility(
                visible: Auth().currentUser != null,
                child: BottomNavigationBar(
                  items: <BottomNavigationBarItem>[
                    BottomNavigationBarItem(
                      icon: Icon(_selectedIndex == 0
                          ? Icons.bar_chart_sharp
                          : Icons.bar_chart_outlined),
                      label: 'Overview',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(_selectedIndex == 1
                          ? Icons.home_sharp
                          : Icons.home_outlined),
                      label: 'Home',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(_selectedIndex == 2
                          ? Icons.emoji_events_sharp
                          : Icons.emoji_events_outlined),
                      label: 'Badges',
                    ),
                  ],
                  currentIndex: _selectedIndex,
                  onTap: _onItemTapped,
                ),
              ),
            );
          },
        ),
        routes: {
          LoginPage.routeName: (context) => LoginPage(
                onUserLoggedIn: () {
                  try {
                    _login();
                  } catch (e) {
                    showErrorSnackbar(context, e.toString());
                  }
                },
              ),
          RegisterPage.routeName: (context) => const RegisterPage(),
        },
      ),
    );
  }
}

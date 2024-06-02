import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'pages/add_record_page.dart';
import 'pages/pond_page.dart';
import 'pages/home_page.dart';
import 'services/gsheets_services.dart';
import 'usecase/nav_usecase.dart';
import 'usecase/pond_usecase.dart';
import 'usecase/record_usecase.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    List<IconData> iconList = [Icons.document_scanner, Icons.abc];
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => NavUseCase(),
        ),
        ChangeNotifierProvider(
          create: (context) => PondUseCase(Sheets.gsheets, Sheets.spreadsheet),
        ),
        ChangeNotifierProvider(
          create: (context) =>
              RecordUseCase(Sheets.gsheets, Sheets.spreadsheet),
        ),
        ChangeNotifierProvider(
          create: (context) => Sheets(),
        )
      ],
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          home: Consumer<NavUseCase>(
            builder: (context, navUseCase, child) {
              return Scaffold(
                backgroundColor: Colors.white,
                body: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                          color: Color(0xff0f7497),
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(30),
                              bottomRight: Radius.circular(30)),
                        ),
                        width: double.infinity,
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 20,
                            ),
                            Image.asset(
                              "assets/logo.png",
                              height: 200,
                            ),
                          ],
                        ),
                      ),
                      returnPage(navUseCase.bottomNavIdx),
                    ],
                  ),
                ),
                floatingActionButton: FloatingActionButton(
                  backgroundColor: const Color(0xff0f7497),
                  foregroundColor: Colors.white,
                  shape: const CircleBorder(),
                  child: const Icon(Icons.add),
                  onPressed: () async {
                    final pondUseCase =
                        Provider.of<PondUseCase>(context, listen: false);
                    if (pondUseCase.allPonds.isEmpty) {
                      await Sheets.fetchPondsFromSheets().then((value) {
                        pondUseCase.setP(value);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const AddRecordPage()),
                        );
                      });

                      // ScaffoldMessenger.of(context).showSnackBar(
                      //   const SnackBar(
                      //     content:
                      //         Text('Fetching ponds, please try again later.'),
                      //   ),
                      // );
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const AddRecordPage()),
                      );
                    }
                  },
                ),
                floatingActionButtonLocation:
                    FloatingActionButtonLocation.centerDocked,
                bottomNavigationBar: AnimatedBottomNavigationBar(
                  borderColor: const Color(0xff0f7497),
                  borderWidth: 1,
                  inactiveColor: Colors.grey,
                  activeColor: const Color(0xff0f7497),
                  icons: iconList,
                  activeIndex: navUseCase.bottomNavIdx,
                  gapLocation: GapLocation.center,
                  notchSmoothness: NotchSmoothness.softEdge,
                  onTap: (index) {
                    navUseCase.changeIdx(index);
                  },
                ),
              );
            },
          )),
    );
  }

  Widget returnPage(int index) {
    switch (index) {
      case 0:
        return const HomePage();
      case 1:
        return const PondPage();
      default:
        return const HomePage();
    }
  }
}

import 'package:bookie_fluttie/notepad.dart';
import 'package:bookie_fluttie/video_bookmarks.dart';
import 'package:flutter/cupertino.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with AutomaticKeepAliveClientMixin {
  int _currentIndex = 0;
  final PageController _pageController = PageController();
  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Directionality(
      textDirection: TextDirection.ltr,
      child: CupertinoApp(
          theme: const CupertinoThemeData(brightness: Brightness.light),
          title: 'Bookie',
          home: CupertinoPageScaffold(
            child: Column(
              children: [
                Expanded(
                  child: PageView(
                    controller: _pageController,
                    onPageChanged: (index) {
                      setState(() {
                        _currentIndex = index;
                      });
                    },
                    children: <Widget>[
                      CupertinoTabView(
                          builder: (BuildContext context) =>
                              const VideoBookmarks()),
                      CupertinoTabView(
                          builder: (BuildContext context) => const Notepad())
                    ],
                  ),
                ),
                CupertinoTabBar(
                  activeColor: CupertinoColors.activeOrange,
                  inactiveColor: CupertinoColors.inactiveGray,
                  currentIndex: _currentIndex,
                  onTap: (index) {
                    setState(() {
                      _currentIndex = index;
                    });
                    _pageController.animateToPage(
                      index,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  },
                  items: const [
                    BottomNavigationBarItem(
                      icon: Icon(CupertinoIcons.video_camera),
                      label: 'Videos Bookmarks',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(CupertinoIcons.pencil_outline),
                      label: 'Notes',
                    ),
                  ],
                ),
              ],
            ),
          )),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

void doNothing(BuildContext context) {}

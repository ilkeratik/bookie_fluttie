import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uuid/uuid.dart';
import 'package:zikzak_share_handler/zikzak_share_handler.dart';

import 'functions.dart';
import 'secret.dart';
import 'youtube.dart';

class VideoBookmarks extends StatefulWidget {
  const VideoBookmarks({super.key});

  @override
  VideoBookmarksState createState() => VideoBookmarksState();
}

class VideoBookmarksState extends State<VideoBookmarks>
    with AutomaticKeepAliveClientMixin {
  var uuid = const Uuid();
  List<Map<String, dynamic>> items = [];
  final ValueNotifier<SharedMedia?> mediaNotifier =
      ValueNotifier<SharedMedia?>(null);
  StreamSubscription<SharedMedia>? _streamSubscription;
  SharedMedia? media;
  YouTubeThumbnailFetcher ytApi = YouTubeThumbnailFetcher(YT_API_KEY);

  @override
  void initState() {
    super.initState();
    debugPrint('--->init state');
    loadItemsFromStorage('iky-video-bookmarks').then((data) => {
          if (data != null)
            {
              setState(() {
                items = data;
              })
            }
        });
    initPlatformState();
    mediaNotifier.addListener(() {
      if (mediaNotifier.value != null) {
        handleNewMedia(mediaNotifier.value!);
      }
    });
  }

  void handleNewMedia(SharedMedia? media) {
    if (media != null && media.content is String) {
      final id = extractYouTubeId(media.content as String);
      debugPrint('Extracted YouTube ID: $id');
      if (id != null) {
        ytApi.fetchVideoDetails(id).then((Map<String, dynamic>? resp) {
          if (resp != null) {
            setState(() {
              items.add({
                'id': uuid.v1(),
                'link': media.content as String,
                'thumbnail': resp['thumbnails']['medium']['url'],
                'title': resp['title'].toString().length > 50
                    ? '${resp['title'].substring(0, 47)}...'
                    : resp['title'],
                'subtitle': resp['description'].toString().length > 50
                    ? '${resp['description'].substring(0, 47)}...'
                    : resp['description'],
                'duration': '1'
              });
            });
            saveItemsToStorage('iky-video-bookmarks', items);
          }
        });
      } else {
        debugPrint('No valid YouTube ID found.');
      }
    }
  }

  void removeItem(String? id) {
    setState(() {
      var item = items.singleWhere((el) => el['id'] == id, orElse: () => {});
      if (item.isNotEmpty) {
        items.remove(item);
      }
    });
    saveItemsToStorage('iky-video-bookmarks', items);
  }

  Future<void> _launchURL(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<void> _launchURLWithBrowserView(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      if (Platform.isIOS) {
        await launchUrl(Uri.parse(url), mode: LaunchMode.inAppBrowserView);
      } else if (Platform.isAndroid) {
        await launchUrl(Uri.parse(url), mode: LaunchMode.inAppWebView);
      } else {
        await launchUrl(Uri.parse(url), mode: LaunchMode.inAppWebView);
      }
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<void> initPlatformState() async {
    final handler = ShareHandlerPlatform.instance;
    SharedMedia? initialMedia = await handler.getInitialSharedMedia();
    if (initialMedia != null) {
      mediaNotifier.value = initialMedia;
    }
    handler.sharedMediaStream.listen((SharedMedia newMedia) {
      if (!mounted) return;
      mediaNotifier.value = newMedia;
    });
  }

  @override
  void dispose() {
    _streamSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        backgroundColor: CupertinoColors.secondarySystemBackground,
        middle: Text('Video'),
      ),
      child: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];
                  return Slidable(
                    key: ValueKey(index),
                    endActionPane: ActionPane(
                      motion: const ScrollMotion(),
                      children: [
                        SlidableAction(
                          onPressed: (context) => {removeItem(item['id'])},
                          backgroundColor:
                              const Color.fromARGB(255, 190, 53, 53),
                          foregroundColor: CupertinoColors.white,
                          icon: CupertinoIcons.delete,
                          label: 'Delete',
                        ),
                        SlidableAction(
                          onPressed: (context) =>
                              {Share.share('${item['link']}')},
                          backgroundColor:
                              const Color.fromARGB(255, 22, 130, 145),
                          foregroundColor: CupertinoColors.white,
                          icon: CupertinoIcons.share,
                          label: 'Share',
                        ),
                      ],
                    ),
                    child: GestureDetector(
                      onLongPress: () =>
                          _launchURLWithBrowserView(item['link']!),
                      onTap: () => _launchURL(item['link']!),
                      child: Column(
                        children: [
                          CupertinoListTile(
                            backgroundColor:
                                const Color.fromARGB(255, 251, 251, 251),
                            leadingSize: 90,
                            leadingToTitle: 10,
                            leading: Image.network(item['thumbnail']!,
                                fit: BoxFit.cover),
                            title: Text(item['title']!,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                )),
                            subtitle: Text(item['subtitle']!),
                          ),
                          const Divider(
                            height: 0,
                            thickness: 0.3,
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

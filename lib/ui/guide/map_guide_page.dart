import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:photo_view/photo_view.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:math';

class MapGuidePage extends HookWidget {
  // late PhotoViewController photoViewController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Controller Photo View'),
        ),
        // Stack puts widgets "on top" of each other
        body: MapWidget(onChangeScale: (value) {
          print('%%% onChangeScale');
          print(value);
        }));
  }
}

class MapWidget extends HookWidget {
  MapWidget({Key? key, required this.onChangeScale}) : super(key: key);

  final Function onChangeScale;
  final List<Map<String, dynamic>> pinList = [
    {'contId': '000001', 'position': Offset(200, -110), 'name': 'ガーデンテラス'},
    {
      'contId': '000002',
      'position': Offset(-135, -90),
      'name': 'ジェクサーフットサルクラブ'
    },
    {'contId': '000003', 'position': Offset(-628, -120), 'name': 'レストスペース'},
    {'contId': '000004', 'position': Offset(230, 160), 'name': 'ハーブガーデン'},
    {'contId': '000005', 'position': Offset(580, -130), 'name': '菜園テラス'},
    {'contId': '000006', 'position': Offset(-420, -50), 'name': '庭園'},
    {'contId': '000007', 'position': Offset(410, 0), 'name': 'ソラドファーム'}
  ];

  Offset convertPosition(BuildContext context, Offset originalPosition,
      Offset? mapPosition, double? currentScale) {
    var size = MediaQuery.of(context).size;
    var displayPosition = Offset(size.width / 2, size.height / 2);

    if (mapPosition == null || currentScale == null) {
      return Offset(0, 0);
    }
    // TODO: 拡大縮小時のスケール計算
    // var dx = displayPosition.dx +
    //     (originalPosition.dx + mapPosition.dx) * sqrt(currentScale);
    // var dy = displayPosition.dy +
    //     (originalPosition.dy + mapPosition.dy) * sqrt(currentScale);

    var dx = displayPosition.dx + (originalPosition.dx + mapPosition.dx);
    var dy = displayPosition.dy + (originalPosition.dy + mapPosition.dy);
    print('convertPosition (currentScale:$currentScale)');
    print('convertPosition (dx:$dx, dy:$dy)');
    return Offset(dx, dy);
  }

  @override
  Widget build(BuildContext context) {
    // late PhotoViewController photoViewController;
    final PhotoViewController photoViewController = PhotoViewController();

    var preScale = 0.00;

    useEffect(() {
      print('### useEffect init');
      // TODO: initalize
      // photoViewController = PhotoViewController();
      return () {
        // photoViewController.dispose();
      };
    }, const []);

    return Stack(children: <Widget>[
      PhotoView(
        controller: photoViewController,
        imageProvider: AssetImage('assets/map/demo_map_2.png'),
        minScale: PhotoViewComputedScale.contained * 0.8,
        maxScale: PhotoViewComputedScale.covered * 2,
        backgroundDecoration: BoxDecoration(
          color: Theme.of(context).canvasColor,
        ),
        initialScale: 2.1, // TODO: 地図の初期スケールを動的表示
      ),
      HookBuilder(
          // Listening on the PhotoView's controller stream
          builder: (context) {
        final stream = useStream(photoViewController.outputStateStream);
        final currentScale = stream.data?.scale;
        final position = stream.data?.position;
        if (currentScale != null && position != null) {
          if ((preScale - currentScale).abs() > 0.01) {
            preScale = double.parse(currentScale.toStringAsFixed(2));
            onChangeScale(preScale);
          }
        }

        return Stack(
            children: pinList
                .map((Map<String, dynamic> pinMap) => Positioned(
                    left: convertPosition(
                            context, pinMap['position'], position, currentScale)
                        .dx,
                    top: convertPosition(
                            context, pinMap['position'], position, currentScale)
                        .dy,
                    child: PinButton(
                      contId: pinMap['contId'],
                      contName: pinMap['name'],
                    )))
                .toList());
      })
    ]);
  }
}

class PinButton extends HookWidget {
  PinButton({Key? key, required this.contId, required this.contName})
      : super(key: key);

  final String contId;
  final String contName;

  @override
  Widget build(BuildContext context) {
    return IconButton(
        // SvgPictureを指定できる
        icon: SvgPicture.asset(
          'assets/icon/pin-fill.svg',
          // color: Colors.blue,
          semanticsLabel: 'pin',
          width: 50,
          height: 50,
        ),
        onPressed: () {
          print('## $contId pin press');
          // TODO: show thumbnail
          showDialog(
            context: context,
            builder: (_) {
              return AlertDialog(
                title: Text('$contName'),
                content: Text('cont id: $contId'),
                actions: <Widget>[
                  // ボタン領域
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('OK'),
                  ),
                ],
              );
            },
          );
        });
  }
}

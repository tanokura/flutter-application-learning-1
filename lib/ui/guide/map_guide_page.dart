import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:photo_view/photo_view.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:math';

class MapGuidePage extends HookWidget {
  late PhotoViewController photoViewController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Controller Photo View'),
        ),
        // Stack puts widgets "on top" of each other
        body: Map(onChangeScale: (value) {
          print('%%% onChangeScale');
          print(value);
        }));
  }
}

class Map extends HookWidget {
  Map({Key? key, required this.onChangeScale}) : super(key: key);

  final Function onChangeScale;

  @override
  Widget build(BuildContext context) {
    // late PhotoViewController photoViewController;
    final PhotoViewController photoViewController = PhotoViewController();
    final Size size = MediaQuery.of(context).size;
    final sizeTop = size.height / 2;
    final sizeLeft = size.width / 2;

    var pinTop;
    var pinLeft;
    var pinTop2;
    var pinLeft2;

    final relativeTop = -260;
    final relativeleft = 35;
    final relativeTop2 = 210;
    final relativeleft2 = -131;

    var preScale = 0.00;

    useEffect(() {
      print('### useEffect init');
      // TODO: initalize
      // photoViewController = PhotoViewController();
      return () {
        // photoViewController.dispose();
      };
    }, const []);
    print('size(height:${size.height}, width:${size.width})');

    return Stack(children: <Widget>[
      PhotoView(
        controller: photoViewController,
        imageProvider: AssetImage('assets/map/demo_map.png'),
        minScale: PhotoViewComputedScale.contained * 0.8,
        maxScale: PhotoViewComputedScale.covered * 2,
        backgroundDecoration: BoxDecoration(
          color: Theme.of(context).canvasColor,
        ),
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

          pinTop = sizeTop + (relativeTop + position.dy) * sqrt(currentScale);
          pinLeft =
              sizeLeft + (relativeleft + position.dx) * sqrt(currentScale);
          print(position);
          print('pin(sizeTop:$sizeTop, sizeLeft:$sizeLeft)');
          print('pin(top:$pinTop, left:$pinLeft)');

          // TODO: スケール計算
          pinTop2 = sizeTop + (relativeTop2 + position.dy) * sqrt(currentScale);
          pinLeft2 =
              sizeLeft + (relativeleft2 + position.dx) * sqrt(currentScale);
        }
        return Stack(children: <Widget>[
          Positioned(
              left: pinLeft,
              top: pinTop,
              child: IconButton(
                  // SvgPictureを指定できる
                  icon: SvgPicture.asset(
                    'assets/icon/pin-fill.svg',
                    // color: Colors.blue,
                    semanticsLabel: 'pin',
                    width: 50,
                    height: 50,
                  ),
                  onPressed: () {
                    print('## pin press1!!');
                  })),
          Positioned(
              left: pinLeft2,
              top: pinTop2,
              child: IconButton(
                  // SvgPictureを指定できる
                  icon: SvgPicture.asset(
                    'assets/icon/pin-fill.svg',
                    // color: Colors.blue,
                    semanticsLabel: 'pin',
                    width: 50,
                    height: 50,
                  ),
                  onPressed: () {
                    print('## pin press2!!');
                  }))
        ]);
      })
    ]);
  }
}

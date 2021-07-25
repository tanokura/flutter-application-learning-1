import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:photo_view/photo_view.dart';

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
    late PhotoViewController photoViewController;
    var preScale = 0.0;

    useEffect(() {
      print('### useEffect init');
      // TODO: initalize
      photoViewController = PhotoViewController();
      return () {
        photoViewController.dispose();
      };
    }, const []);

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
      Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          HookBuilder(
            // Listening on the PhotoView's controller stream
            builder: (context) {
              final stream = useStream(photoViewController.outputStateStream);
              final currentScale = stream.data?.scale;
              if (currentScale != null) {
                if ((preScale - currentScale).abs() > 0.1) {
                  preScale = double.parse(currentScale.toStringAsFixed(1));
                  onChangeScale(preScale);
                }
              }
              // return Center(
              //   child: Text(
              //     'Scale compared to the original: \n${stream.data?.scale}',
              //     textAlign: TextAlign.center,
              //     style: TextStyle(fontSize: 20),
              //   ),
              // );
              return Text('');
            },
          ),
          // ElevatedButton(
          //   onPressed: () {
          //     // photoViewController.scale = photoViewController.initial.scale;
          //     final tmpSacle = photoViewController.initial.scale;
          //     if (tmpSacle!= null) {
          //       scale.value = tmpSacle;
          //     }

          //   },
          //   child: Text('Reset Scale'),
          // ),
        ],
      )
    ]);
  }
}

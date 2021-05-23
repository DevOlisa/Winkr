import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:camera/camera.dart';
import 'package:video_player/video_player.dart';
import '../Handlers.dart';

class CameraApp extends StatefulWidget {
  final List<CameraDescription> cameras;

  const CameraApp({Key key, this.cameras}) : super(key: key);
  @override
  _CameraAppState createState() => _CameraAppState();
}

IconData getCameraLensIcon(CameraLensDirection direction) {
  switch (direction) {
    case CameraLensDirection.back:
      return Icons.camera_rear_rounded;
      break;
    case CameraLensDirection.front:
      return Icons.camera_front_rounded;
      break;
    case CameraLensDirection.external:
      return Icons.camera;
      break;
    default:
      throw ArgumentError('Unknown lens direction');
  }
}

class _CameraAppState extends State<CameraApp>
    with WidgetsBindingObserver, TickerProviderStateMixin {
  CameraController _controller;
  XFile imageFile;
  XFile videoFile;
  VideoPlayerController _videoController;
  VoidCallback videoPlayerListener;
  bool enableAudio = true;
  double _minAvailableExposureOffset = 0.0;
  double _maxAvailableExposureOffset = 0.0;
  double _currentExposureOffset = 0.0;
  AnimationController _flashModeControlRowAnimationController;
  Animation<double> _flashModeControlRowAnimation;
  AnimationController _exposureModeControlRowAnimationController;
  Animation<double> _exposureModeControlRowAnimation;
  double _minAvailableZoom = 1.0;
  double _maxAvailableZoom = 1.0;
  double _currentScale = 1.0;
  double _baseScale = 1.0;
// Counting pointers (number of user fingers on screen)
  int _pointers = 0;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance?.addObserver(this);
    onNewCameraSelected(widget.cameras[0]);

    _flashModeControlRowAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _flashModeControlRowAnimation = CurvedAnimation(
      parent: _flashModeControlRowAnimationController,
      curve: Curves.easeInCubic,
    );
    _exposureModeControlRowAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _exposureModeControlRowAnimation = CurvedAnimation(
      parent: _exposureModeControlRowAnimationController,
      curve: Curves.easeInCubic,
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance?.removeObserver(this);
    _flashModeControlRowAnimationController.dispose();
    _exposureModeControlRowAnimationController.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final CameraController cameraController = _controller;

    // App state changed before we got the chance to initialize.
    if (cameraController == null || !cameraController.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      cameraController.dispose();
    } else if (state == AppLifecycleState.resumed) {
      onNewCameraSelected(cameraController.description);
    }
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String timestamp() => DateTime.now().millisecondsSinceEpoch.toString();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black12,
      key: _scaffoldKey,
      body: Column(
        children: <Widget>[
          Stack(children: [
            Container(
              height: 80.0,
            ),
            Positioned(bottom: -10.0, child: _videoTimeDisplay())
          ]),
          Expanded(
            child: Container(
              child: Padding(
                padding: const EdgeInsets.all(1.0),
                child: Center(
                  child: _cameraPreviewWidget(),
                ),
              ),
              decoration: BoxDecoration(
                color: Colors.black,
              ),
            ),
          ),
          Container(
            height: 160.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  padding: EdgeInsets.all(8.0),
                  child: IconButton(
                      icon: getFlashModeIcon(),
                      iconSize: 32.0,
                      color: Colors.white,
                      onPressed: _controller != null
                          ? () => onSetFlashModeButtonPressed(FlashMode.auto)
                          : null),
                ),
                Container(
                    width: 180.0,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: GestureDetector(
                      onTap: () => takePicture,
                      onLongPressStart: (details) => startVideoRecording(),
                      onLongPressUp: () => stopVideoRecording(),
                      child: Icon(
                        Icons.camera_rounded,
                        size: 64.0,
                      ),
                    )),
                Container(
                  padding: EdgeInsets.all(8.0),
                  child: _cameraToggleWidget(widget.cameras),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  ///This widget provides the preview of the camera feed
  Widget _cameraPreviewWidget() {
    final CameraController cameraController = _controller;

    if (cameraController == null || !cameraController.value.isInitialized) {
      return const Text(
        'Tap a camera',
        style: TextStyle(
          color: Colors.white,
          fontSize: 24.0,
          fontWeight: FontWeight.w900,
        ),
      );
    } else {
      return Listener(
        onPointerDown: (_) => _pointers++,
        onPointerUp: (_) => _pointers--,
        child: CameraPreview(
          _controller,
          child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
            return GestureDetector(
              behavior: HitTestBehavior.opaque,
              onScaleStart: _handleScaleStart,
              onScaleUpdate: _handleScaleUpdate,
              onTapDown: (details) => onViewFinderTap(details, constraints),
            );
          }),
        ),
      );
    }
  }

  Widget _cameraToggleWidget(List cameras) {
    Widget cameraButton;
    final onChanged = (CameraDescription description) {
      if (description == null) {
        return;
      }
      print(description);
      onNewCameraSelected(description);
    };

    if (cameras.isEmpty) {
      showInSnackBar('No camera found');
    } else {
      print(cameras);
      if (_controller == null) print(_controller);
      // initiateLastCameraSelected(cameras[0]);
      cameraButton = IconButton(
        icon: Icon(getCameraDescriptionIcon(cameras[0].lensDirection),
            color: Colors.white),
        iconSize: 32.0,
        onPressed: () =>
            _controller != null && _controller.value.isRecordingVideo
                ? null
                : onChanged,
      );
    }
    return cameraButton;
  }

  Widget _videoTimeDisplay() {
    final CameraController cameraController = _controller;

    if (cameraController != null && cameraController.value.isRecordingVideo) {
      return Container(
        height: 40.0,
        child: Align(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 18.0,
                decoration:
                    BoxDecoration(color: Colors.red, shape: BoxShape.circle),
              ),
              SizedBox(width: 9.0),
              Text(
                "00:00",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                    color: Colors.white,
                    shadows: [Shadow(color: Colors.black45, blurRadius: 5.0)]),
              )
            ],
          ),
        ),
      );
    } else {
      return SizedBox();
    }
  }

  // DESCRIPTION: Methods used by the camera app

  void _handleScaleStart(ScaleStartDetails details) {
    _baseScale = _currentScale;
  }

  Future<void> _handleScaleUpdate(ScaleUpdateDetails details) async {
    // When there are not exactly two fingers on screen don't scale
    if (_controller == null || _pointers != 2) {
      return;
    }

    _currentScale = (_baseScale * details.scale)
        .clamp(_minAvailableZoom, _maxAvailableZoom);

    await _controller.setZoomLevel(_currentScale);
  }

  ///Sets the Exposure and Focus point using the [CameraController] when
  ///the user taps at any point in the camera preview
  void onViewFinderTap(TapDownDetails details, BoxConstraints constraints) {
    if (_controller == null) {
      return;
    }

    final CameraController cameraController = _controller;

    final offset = Offset(
      details.localPosition.dx / constraints.maxWidth,
      details.localPosition.dy / constraints.maxHeight,
    );
    cameraController.setExposurePoint(offset);
    cameraController.setFocusPoint(offset);
  }

  ///Fnction used to switch between camera
  void onNewCameraSelected(CameraDescription cameraDescription) async {
    if (_controller != null) {
      await _controller.dispose();
    }
    final CameraController cameraController = CameraController(
      cameraDescription,
      ResolutionPreset.medium,
      enableAudio: enableAudio,
      imageFormatGroup: ImageFormatGroup.jpeg,
    );
    _controller = cameraController;

    // If the controller is updated then update the UI.
    cameraController.addListener(() {
      if (mounted) setState(() {});
      if (cameraController.value.hasError) {
        showInSnackBar(
            'Camera error ${cameraController.value.errorDescription}');
      }
    });

    try {
      await cameraController.initialize();
      await Future.wait([
        cameraController
            .getMinExposureOffset()
            .then((value) => _minAvailableExposureOffset = value),
        cameraController
            .getMaxExposureOffset()
            .then((value) => _maxAvailableExposureOffset = value),
        cameraController
            .getMaxZoomLevel()
            .then((value) => _maxAvailableZoom = value),
        cameraController
            .getMinZoomLevel()
            .then((value) => _minAvailableZoom = value),
      ]);
    } on CameraException catch (e) {
      _showCameraException(e);
    }

    if (mounted) {
      setState(() {});
    }
  }

  ///Sets the FlashMode [mode] argument on the CameraController
  Future<void> setFlashMode(FlashMode mode) async {
    if (_controller == null) {
      return;
    }

    try {
      await _controller.setFlashMode(mode);
    } on CameraException catch (e) {
      _showCameraException(e);
      rethrow;
    }
  }

  void onSetFlashModeButtonPressed(FlashMode mode) {
    setFlashMode(mode).then((_) {
      if (mounted) setState(() {});
      showInSnackBar('Flash mode set to ${mode.toString().split('.').last}');
    });
  }

  ///Calls the [takePicture()] method of the CameraController to take a picture
  ///from the CameraPreview
  Future<XFile> takePicture() async {
    final CameraController cameraController = _controller;
    if (cameraController == null || !cameraController.value.isInitialized) {
      showInSnackBar('Error: select a camera first.');
      return null;
    }

    if (cameraController.value.isTakingPicture) {
      // A capture is already pending, do nothing.
      return null;
    }

    try {
      XFile file = await cameraController.takePicture();
      return file;
    } on CameraException catch (e) {
      _showCameraException(e);
      return null;
    }
  }

  ///Calls the [startVideoRecording()] method of the CameraController to take a picture
  ///from the CameraPreview
  Future<void> startVideoRecording() async {
    final CameraController cameraController = _controller;

    if (cameraController == null || !cameraController.value.isInitialized) {
      showInSnackBar('Error: select a camera first.');
      return;
    }

    if (cameraController.value.isRecordingVideo) {
      // A recording is already started, do nothing.
      return;
    }

    try {
      await cameraController.startVideoRecording();
    } on CameraException catch (e) {
      _showCameraException(e);
      return;
    }
  }

  ///Calls the [stopVideoRecording()] method of the CameraController to stop
  /// recording from the CameraPreview and returns the File path [XFile]
  Future<XFile> stopVideoRecording() async {
    final CameraController cameraController = _controller;

    if (cameraController == null || !cameraController.value.isRecordingVideo) {
      return null;
    }

    try {
      return cameraController.stopVideoRecording();
    } on CameraException catch (e) {
      _showCameraException(e);
      return null;
    }
  }

  Icon getFlashModeIcon() {
    switch (_controller?.value?.flashMode) {
      case FlashMode.off:
        return Icon(Icons.flash_off_rounded);
        break;
      case FlashMode.always:
        return Icon(Icons.highlight_rounded);
        break;
      case FlashMode.torch:
        return Icon(Icons.flash_on_rounded);
        break;
      default:
        return Icon(Icons.flash_auto);
    }
  }

  IconData getCameraDescriptionIcon(CameraLensDirection direction) {
    switch (direction) {
      case CameraLensDirection.back:
        return Icons.camera_rear_rounded;
        break;
      case CameraLensDirection.front:
        return Icons.camera_front_rounded;
        break;
      case CameraLensDirection.external:
        return Icons.camera_rounded;
        break;
      default:
        throw ArgumentError('Unknown lens direction');
    }
  }

  void onFlashModeButtonPressed() {
    if (_flashModeControlRowAnimationController.value == 1) {
      _flashModeControlRowAnimationController.reverse();
    } else {
      _flashModeControlRowAnimationController.forward();
      _exposureModeControlRowAnimationController.reverse();
    }
  }

  ///Shows snackbar. This function takes a String [message] as an argument
  ///which is displayed in snackbar
  void showInSnackBar(String message) {
    // ignore: deprecated_member_use
    _scaffoldKey.currentState?.showSnackBar(SnackBar(content: Text(message)));
  }

  void _showCameraException(CameraException e) {
    logError(e.code, e.description);
    showInSnackBar('Error: ${e.code}\n${e.description}');
  }

  void initiateLastCameraSelected(camera) {}
}

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter_vision/flutter_vision.dart';

class RealtimeDetectionPage extends StatefulWidget {
  final CameraDescription camera;

  RealtimeDetectionPage({required this.camera});

  @override
  _RealtimeDetectionPageState createState() => _RealtimeDetectionPageState();
}

class _RealtimeDetectionPageState extends State<RealtimeDetectionPage> {
  CameraController? _controller;
  late FlutterVision _vision;
  List<Map<String, dynamic>> _yoloResults = [];
  CameraImage? _cameraImage;
  bool _isLoaded = false;
  bool _isDetecting = false;
  bool _isCameraInitialized = false;
  bool _isProcessingFrame = false;
  int _maleCount = 0;
  int _femaleCount = 0;
  DateTime? _lastProcessedTime;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    _controller = CameraController(widget.camera, ResolutionPreset.high);
    await _controller?.initialize();
    _vision = FlutterVision();
    await _vision.loadYoloModel(
      labels: 'assets/labels.txt',
      modelPath: 'assets/best_float32.tflite',
      modelVersion: "yolov8",
      numThreads: 1,
      useGpu: true,
    );
    setState(() {
      _isLoaded = true;
      _isCameraInitialized = true;
    });
  }

  @override
  void dispose() {
    _controller?.dispose();
    _vision.closeYoloModel();
    super.dispose();
  }

  Future<void> _yoloOnFrame(CameraImage cameraImage) async {
    if (_isProcessingFrame) return;

    if (_lastProcessedTime != null &&
        DateTime.now().difference(_lastProcessedTime!).inMilliseconds < 1000) {
      return;
    }

    _isProcessingFrame = true;
    _lastProcessedTime = DateTime.now();

    try {
      final result = await _vision.yoloOnFrame(
        bytesList: cameraImage.planes.map((plane) => plane.bytes).toList(),
        imageHeight: cameraImage.height,
        imageWidth: cameraImage.width,
        iouThreshold: 0.5,
        confThreshold: 0.5,
        classThreshold: 0.5,
      );

      int maleCount = 0;
      int femaleCount = 0;

      for (var item in result) {
        if (item['tag'] == 'male') {
          maleCount++;
        } else if (item['tag'] == 'female') {
          femaleCount++;
        }
      }

      setState(() {
        _yoloResults = result;
        _maleCount = maleCount;
        _femaleCount = femaleCount;
        _cameraImage = cameraImage;
      });
    } catch (e) {
      print("Error processing frame: $e");
    } finally {
      _isProcessingFrame = false;
    }
  }

  Future<void> _startDetection() async {
    setState(() {
      _isDetecting = true;
    });
    if (_controller?.value.isStreamingImages ?? false) return;
    await _controller?.startImageStream((image) async {
      if (_isDetecting && !_isProcessingFrame) {
        await _yoloOnFrame(image);
      }
    });
  }

  Future<void> _stopDetection() async {
    setState(() {
      _isDetecting = false;
      _yoloResults.clear();
    });
    await _controller?.stopImageStream();
  }

  List<Widget> _displayBoxesAroundRecognizedObjects(Size screen) {
    if (_yoloResults.isEmpty || _cameraImage == null) return [];
    double factorX = screen.width / _cameraImage!.height;
    double factorY = screen.height / _cameraImage!.width;

    return _yoloResults.map((result) {
      double objectX = result["box"][0] * factorX;
      double objectY = result["box"][1] * factorY;
      double objectWidth = (result["box"][2] - result["box"][0]) * factorX;
      double objectHeight = (result["box"][3] - result["box"][1]) * factorY;

      return Positioned(
        left: objectX,
        top: objectY,
        width: objectWidth,
        height: objectHeight,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            border: Border.all(color: Colors.pink, width: 2.0),
          ),
          child: Text(
            "${result['tag']} ${(result['box'][4] * 100).toStringAsFixed(2)}%",
            style: TextStyle(
              background: Paint()..color = Color.fromARGB(255, 50, 233, 30),
              color: Color.fromARGB(255, 115, 0, 255),
              fontSize: 18.0,
            ),
          ),
        ),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text('Detection Mode 1'),
        backgroundColor: Colors.cyan,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: _isCameraInitialized
            ? (!_isLoaded
                ? Center(child: CircularProgressIndicator())
                : Stack(
                    fit: StackFit.expand,
                    children: [
                      AspectRatio(
                        aspectRatio: _controller?.value.aspectRatio ?? 1.0,
                        child: CameraPreview(_controller!),
                      ),
                      ..._displayBoxesAroundRecognizedObjects(size),
                      Positioned(
                        top: 20,
                        left: 20,
                        child: Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.black54,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Male: $_maleCount',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16),
                              ),
                              Text(
                                'Female: $_femaleCount',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 75,
                        width: size.width,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              height: 80,
                              width: 80,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border:
                                    Border.all(width: 5, color: Colors.white),
                                color: _isDetecting ? Colors.red : Colors.green,
                              ),
                              child: IconButton(
                                onPressed: _isDetecting
                                    ? _stopDetection
                                    : _startDetection,
                                icon: Icon(
                                  _isDetecting ? Icons.stop : Icons.play_arrow,
                                  color: Colors.white,
                                ),
                                iconSize: 50,
                              ),
                            ),
                            const SizedBox(height: 20),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                foregroundColor: Colors.white,
                                padding: EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 10),
                                textStyle: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              onPressed: () async {
                                await _controller?.dispose();
                                setState(() {
                                  _isCameraInitialized = false;
                                });
                                Navigator.pop(context);
                              },
                              child: Text("Keluar"),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ))
            : CircularProgressIndicator(),
      ),
    );
  }
}

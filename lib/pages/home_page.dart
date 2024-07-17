import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:mall_visitor_counting/pages/detection_bestpt.dart';
import 'package:mall_visitor_counting/pages/detection_tflite.dart';
import 'package:mall_visitor_counting/pages/history_page.dart';
import 'package:mall_visitor_counting/pages/profile_page.dart';

List<CameraDescription>? cameras;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  late List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _initCameras();
    _pages = [
      SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: 46),
            Text(
              "Hitung Pengunjung Supermarket",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            Container(
              height: 350,
              child: Center(
                child: Image.asset(
                  'assets/images/image-detection.jpg',
                  fit: BoxFit.contain,
                ),
              ),
            ),
            SizedBox(height: 25),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.cyan,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              onPressed: _navigateToRealtimeDetection,
              icon: Icon(Icons.camera_alt),
              label: Text("Deteksi Mode 1"),
            ),
            SizedBox(height: 20),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.cyan,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              onPressed: _navigateToUnrealtimeDetection,
              icon: Icon(Icons.camera_alt),
              label: Text("Deteksi Mode 2"),
            ),
            SizedBox(height: 20),
            Text(
              "Arahkan kamera ke objek manusia!",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
      HistoryPage(),
      ProfilePage(),
    ];
  }

  Future<void> _initCameras() async {
    cameras = await availableCameras();
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _navigateToRealtimeDetection() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RealtimeDetectionPage(camera: cameras![0]),
      ),
    );
  }

  void _navigateToUnrealtimeDetection() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => UnrealtimeDetectionPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _currentIndex == 0
          ? AppBar(
              title: Text('Beranda'),
              backgroundColor: Colors.cyan,
              foregroundColor: Colors.white,
              automaticallyImplyLeading: false,
            )
          : null,
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        selectedItemColor: Colors.cyan,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Beranda',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'Riwayat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}

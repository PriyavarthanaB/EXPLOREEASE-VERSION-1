import 'package:flutter/material.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDEDD2),
      appBar: AppBar(
        backgroundColor: const  Color(0xFFFDEDD2),
        iconTheme: const IconThemeData(color:Color(0xFF770A1D)),
        title: const Text(
          'Help',
          style: TextStyle(
            color: Color(0xFF770A1D),
          ),
        ),
        centerTitle: false,
        elevation: 0,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'Emergency Contacts:',
                style: TextStyle(
                  fontSize: 20,
                  color: Color(0xFF770A1D),
                ),
              ),
              SizedBox(height: 20),
              Text(
                '🚑 Ambulance: 108',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 10),
              Text(
                '🚓 Police: 100',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

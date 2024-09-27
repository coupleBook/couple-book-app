import 'package:flutter/material.dart';
import 'dart:ui'; // 블러 효과를 위해 필요

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Opacity(
            opacity: 0.5,
            child: Container(
              color: Colors.black,
            ),
          ),

          // 블러 효과 적용
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
            child: Container(
              color: Colors.black.withOpacity(0),
            ),
          ),

          Center(
            child: Image.asset(
              'assets/contents/loading.gif',
              width: 100.0,
              height: 100.0,
            ),
          ),
        ],
      ),
    );
  }
}

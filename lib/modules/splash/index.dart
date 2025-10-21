import 'dart:async';

import 'package:flickture/modules/test_utils/virtual_file_system_viewer.dart';
import 'package:flutter/material.dart';

import '../../global.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  Timer? timer;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Future.wait([_startInit(), _justWait()]);
      _leaveSplash();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }

  Future<void> _justWait() async {
    await Future.delayed(const Duration(seconds: 2));
  }

  Future<void> _startInit() async {
    await vfm.init();
  }

  void _leaveSplash() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => VirtualFileSystemViewerScreen()),
    );
  }
}

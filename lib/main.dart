import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jspos/app/jpos.dart';

void main() {
  runApp(const ProviderScope(child: JPOSApp()));
}


import 'package:flutter/material.dart';

final ButtonStyle flatButtonStyle = TextButton.styleFrom(
  foregroundColor: Colors.black87,
  minimumSize: const Size(88, 36),
  padding: const EdgeInsets.symmetric(horizontal: 16),
  shape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(18)),
  ),
);

final ButtonStyle redButtonStyle = TextButton.styleFrom(
  backgroundColor: Colors.redAccent,
  foregroundColor: Colors.white,
  minimumSize: const Size(95, 36),
  padding: const EdgeInsets.symmetric(horizontal: 16),
  shape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(18)),
  ),
);
final ButtonStyle blueButtonStyle = TextButton.styleFrom(
  backgroundColor: Colors.lightBlueAccent,
  foregroundColor: Colors.white,
  minimumSize: const Size(95, 36),
  padding: const EdgeInsets.symmetric(horizontal: 16),
  shape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(18)),
  ),
);

final ButtonStyle purpleButtonStyle = ElevatedButton.styleFrom(
  foregroundColor: Colors.white,
  backgroundColor: Colors.deepPurpleAccent, // Text color
  minimumSize: const Size(95, 36),
  padding: const EdgeInsets.symmetric(horizontal: 16),
  shape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(18)),
  ),
);

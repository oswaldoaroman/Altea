import 'package:flutter/material.dart';

class InfoItem {
  final IconData icon;
  final String text;
  final String? subtitle;

  const InfoItem({required this.icon, required this.text, this.subtitle});
}

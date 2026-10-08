import 'package:flutter/material.dart';

class ProductCategory {
  final String id;
  final String name;
  final IconData icon;
  final Color color;
  final Color bgColor;
  final String? bannerImage;

  const ProductCategory({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
    required this.bgColor,
    this.bannerImage,
  });
}

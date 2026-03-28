import 'dart:math' as math;
import 'package:flutter/material.dart';

class TestimonialModel {
  final String id;
  final String name;
  final String role;
  final String company;
  final String text;
  final String? avatarBase64;
  final bool approved;
  final int rating;

  TestimonialModel({
    required this.id,
    required this.name,
    required this.role,
    required this.company,
    required this.text,
    this.avatarBase64,
    this.approved = false,
    this.rating = 5,
  });

  String get initials {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    return name.substring(0, math.min(2, name.length)).toUpperCase();
  }

  Color get avatarColor {
    final colors = [
      const Color(0xFF1E40AF),
      const Color(0xFF7C3AED),
      const Color(0xFF065F46),
      const Color(0xFF9D174D),
      const Color(0xFF92400E),
      const Color(0xFF1E3A5F),
    ];
    return colors[name.length % colors.length];
  }

  Map<String, dynamic> toMap() => {
    'id': id,
    'name': name,
    'role': role,
    'company': company,
    'text': text,
    'avatarBase64': avatarBase64,
    'approved': approved,
    'rating': rating,
  };

  factory TestimonialModel.fromMap(Map<String, dynamic> map) =>
      TestimonialModel(
        id: map['id'] ?? '',
        name: map['name'] ?? '',
        role: map['role'] ?? '',
        company: map['company'] ?? '',
        text: map['text'] ?? '',
        avatarBase64: map['avatarBase64'],
        approved: map['approved'] ?? false,
        rating: map['rating'] ?? 5,
      );
}
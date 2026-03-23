import 'package:flutter/material.dart';

import 'boltpe_home_screen.dart';

void main() {
  runApp(const BoltPeApp());
}

/// Screen displaying the three rating badges from the Figma design.
class RatingBadgesScreen extends StatelessWidget {
  const RatingBadgesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEEEEEE),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              RatingBadge(
                rating: 4.2,
                backgroundColor: Color(0xFF4CAF50),
              ),
              SizedBox(height: 12),
              RatingBadge(
                rating: 1.9,
                backgroundColor: Color(0xFFF44336),
              ),
              SizedBox(height: 12),
              RatingBadge(
                rating: 3.5,
                backgroundColor: Color(0xFFFFC107),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Pill-shaped badge with star icon and rating value (matches Figma design).
class RatingBadge extends StatelessWidget {
  const RatingBadge({
    super.key,
    required this.rating,
    required this.backgroundColor,
  });

  final double rating;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(100),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.star_rounded,
            color: Colors.white,
            size: 20,
          ),
          const SizedBox(width: 6),
          Text(
            rating.toStringAsFixed(1),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
              letterSpacing: -0.2,
            ),
          ),
        ],
      ),
    );
  }
}

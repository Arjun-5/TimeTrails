import 'package:flutter/material.dart';
import 'package:time_trails/models/landmark.dart';
import 'package:time_trails/services/badge_service.dart';
import 'package:time_trails/views/ar_view_screen.dart';

class LandmarkUnlockPanel extends StatefulWidget {
  final Landmark landmark;
  final bool isNearby;

  const LandmarkUnlockPanel({
    super.key,
    required this.landmark,
    required this.isNearby,
  });

  @override
  State<LandmarkUnlockPanel> createState() => _LandmarkUnlockPanelState();
}

class _LandmarkUnlockPanelState extends State<LandmarkUnlockPanel> {
  final BadgeService _badgeService = BadgeService();
  bool _loading = false;
  String? _badgeModelUrl;

  Future<void> _launchAR() async {
    setState(() {
      _loading = true;
    });

    final badgeInfo = await _badgeService.getBadgeForLandmark(
      widget.landmark.placeId,
    );

    setState(() {
      _loading = false;
      _badgeModelUrl = badgeInfo?.badgeModelUrl;
    });
    if (!mounted) {
      return;
    }
    if (_badgeModelUrl == null || _badgeModelUrl!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No badge model found for this landmark.'),
        ),
      );
      return;
    }

    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ArViewScreen(
          landmark: widget.landmark,
          modelUrl: _badgeModelUrl!,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 180,
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Text(
            widget.landmark.name,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Text(
            widget.isNearby
                ? "You're here! Tap below to view the badge in AR."
                : "Go near the landmark to unlock the badge.",
          ),
          const Spacer(),
          if (_loading)
            const CircularProgressIndicator()
          else if (widget.isNearby)
            ElevatedButton(
              onPressed: _launchAR,
              child: const Text("Launch AR"),
            ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart' hide Badge;
import 'package:time_trails/models/badge.dart';

class BadgeCollectionScreen extends StatelessWidget {
  const BadgeCollectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Badge>>(
      future: BadgeStorage.getBadges(),
      builder: (context, snapshot) {
        final badges = snapshot.data ?? [];
        return Scaffold(
          appBar: AppBar(title: Text("My Badges")),
          body: badges.isEmpty
              ? Center(child: Text("No badges collected yet."))
              : ListView.builder(
                  itemCount: badges.length,
                  itemBuilder: (_, i) {
                    final badge = badges[i];
                    return ListTile(
                      leading: Image.network(badge.imageUrl),
                      title: Text(badge.name),
                      subtitle: Text(
                        "Collected on ${badge.collectedAt.toLocal()}",
                      ),
                    );
                  },
                ),
        );
      },
    );
  }
}

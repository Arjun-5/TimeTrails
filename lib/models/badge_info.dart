class BadgeInfo {
  final String badgeModelUrl;
  final String badgeName;
  final String badgeDescription;

  BadgeInfo({
    required this.badgeModelUrl,
    required this.badgeName,
    required this.badgeDescription,
  });

  factory BadgeInfo.fromMap(Map<String, dynamic> data) {
    return BadgeInfo(
      badgeModelUrl: data['badgeModelUrl'] ?? '',
      badgeName: data['badgeName'] ?? '',
      badgeDescription: data['badgeDescription'] ?? '',
    );
  }
}

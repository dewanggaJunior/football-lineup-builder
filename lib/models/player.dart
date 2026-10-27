enum DisplayMode { none, club, value, age }

class Player {
  final String id;
  final String name;
  final String shortName;
  final String position;

  final String? clubName;
  final String? clubId;

  final int? age;
  final double? marketValue;

  const Player({
    required this.id,
    required this.name,
    required this.shortName,
    required this.position,
    this.clubName,
    this.clubId,
    this.age,
    this.marketValue,
  });


  String get photoAsset => 'assets/players/$id.png';

  String get clubLogoAsset {
    if (clubId == null || clubId!.isEmpty) {
      return '';
    }

    return 'assets/clubs/$clubId.png';
  }

  String get formattedMarketValue {
    if (marketValue == null) {
      return '-';
    }

    if (marketValue! >= 1000000) {
      final value = marketValue! / 1000000;

      return '€${value.toStringAsFixed(
        value % 1 == 0 ? 0 : 1,
      )}M';
    }

    if (marketValue! >= 1000) {
      final value = marketValue! / 1000;

      return '€${value.toStringAsFixed(
        value % 1 == 0 ? 0 : 1,
      )}K';
    }

    return '€${marketValue!.toStringAsFixed(0)}';
  }

  String get formattedAge {
    return age?.toString() ?? '-';
  }
}
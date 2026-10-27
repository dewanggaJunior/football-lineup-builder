import 'package:UTS/models/lineup_slot.dart';
import 'package:flutter/material.dart';
import '../models/player.dart';

class PlayerSpot extends StatelessWidget {
  final LineupSlot slot;
  final DisplayMode mode;

  const PlayerSpot({
    super.key,
    required this.slot,
    required this.mode,
  });

  static const double _size = 46;

  @override
  Widget build(BuildContext context) {
    final p = slot.player;

    final valueMode =
        p != null &&
        mode == DisplayMode.value &&
        p.marketValue != null;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: _size,
          height: _size,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned.fill(
                child: _avatar(p),
              ),
              ..._badges(p),
            ],
          ),
        ),

        SizedBox(
          height: valueMode ? 11 : 5,
        ),

        Text(
          p?.shortName ?? slot.role,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: p == null ? Colors.white70 : Colors.white,
            fontSize: 12.5,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  Widget _avatar(Player? p) {
    if (p == null) {
      return Container(
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Color(0xFF0A7D4C),
        ),
        child: const Icon(
          Icons.add,
          color: Colors.white70,
          size: 24,
        ),
      );
    }

    return Container(
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Color(0xFFEDEDED),
      ),
      child: ClipOval(
        child: Image.asset(
          p.photoAsset,
          fit: BoxFit.cover,
          alignment: Alignment.topCenter,
          errorBuilder: (_, __, ___) {
            return const Icon(
              Icons.person,
              color: Color(0xFF9E9E9E),
              size: 30,
            );
          },
        ),
      ),
    );
  }

  List<Widget> _badges(Player? p) {
    if (p == null) {
      return [];
    }

    switch (mode) {
      case DisplayMode.age:
        if (p.age == null) {
          return [];
        }

        return [
          Positioned(
            top: -6,
            right: -10,
            child: _pill('${p.age}'),
          ),
        ];

      case DisplayMode.value:
        if (p.marketValue == null) {
          return [];
        }

        return [
          Positioned(
            bottom: -9,
            left: -14,
            right: -14,
            child: Center(
              child: _pill(p.formattedMarketValue),
            ),
          ),
        ];

      case DisplayMode.club:
        if (p.clubLogoAsset.isEmpty) {
          return [];
        }

        return [
          Positioned(
            bottom: -2,
            right: -4,
            child: _circleBadge(
              Image.asset(
                p.clubLogoAsset,
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) {
                  return const Icon(
                    Icons.shield,
                    size: 12,
                    color: Color(0xFF9E9E9E),
                  );
                },
              ),
            ),
          ),
        ];

      case DisplayMode.none:
        return [];
    }
  }

  Widget _pill(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 7,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Color(0xFF1A1A1A),
          fontSize: 11,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }

  Widget _circleBadge(Widget child) {
    return Container(
      width: 20,
      height: 20,
      padding: const EdgeInsets.all(2),
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
      ),
      child: ClipOval(
        child: child,
      ),
    );
  }
}
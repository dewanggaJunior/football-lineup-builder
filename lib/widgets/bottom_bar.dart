import 'package:UTS/models/player.dart';
import 'package:flutter/material.dart';
import '../models/formation.dart';

class BottomBar extends StatelessWidget {
  final String formation;
  final DisplayMode mode;
  final ValueChanged<String> onFormation;
  final ValueChanged<DisplayMode> onMode;

  const BottomBar({
    super.key,
    required this.formation,
    required this.mode,
    required this.onFormation,
    required this.onMode,
  });

  static const Color _green = Color(0xFF0A8F55);

  @override
Widget build(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
    child: Row(
      children: [
        _formationButton(),
        const SizedBox(width: 8),
        Expanded(
          child: Container(
            height: 44,
            padding: const EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(
              color: const Color(0xFF14A468),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Row(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        SizedBox(width: 45),
                        _chip('Club', DisplayMode.club),
                        SizedBox(width: 12),
                        _chip(
                          'Transfer value',
                          DisplayMode.value,
                        ),
                        SizedBox(width: 12),
                        _chip('Age', DisplayMode.age),
                       
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}

  Widget _formationButton() {
    return PopupMenuButton<String>(
      onSelected: onFormation,
      color: const Color(0xFF2A2A2A),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      itemBuilder: (_) => kFormations
          .map((f) => PopupMenuItem<String>(
                value: f,
                child: Text(
                  f,
                  style: TextStyle(
                    color: f == formation ? const Color(0xFF2ED573) : Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ))
          .toList(),
      child: Container(
        height: 44,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: const Color(0xFF0B7C4B),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              formation,
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.w500, fontSize: 13),
            ),
            const SizedBox(width: 4),
            const Icon(Icons.arrow_drop_down, color: Colors.white),
          ],
        ),
      ),
    );
  }

  Widget _chip(String label, DisplayMode value) {
    final selected = mode == value;
    return GestureDetector(
      onTap: () => onMode(selected ? DisplayMode.none : value),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 2),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFEAF6EF) : const Color(0xFF0B8D57),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? _green : Colors.white,
            fontWeight: FontWeight.w500,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}

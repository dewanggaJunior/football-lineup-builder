import 'package:flutter/material.dart';
import '../data/squad_data.dart';
import '../models/formation.dart';
import '../models/lineup_slot.dart';
import '../models/player.dart';
import '../widgets/bottom_bar.dart';
import '../widgets/pitch_painter.dart';
import '../widgets/player_picker.dart';
import '../widgets/player_spot.dart';

class LineupScreen extends StatefulWidget {
  const LineupScreen({super.key});

  @override
  State<LineupScreen> createState() => _LineupScreenState();
}

class _LineupScreenState extends State<LineupScreen> {
  final List<Player> _squad = getSquad();
  String _formation = '4-4-1-1';
  DisplayMode _mode = DisplayMode.none;
  late final List<LineupSlot> _slots;

  static const List<String> _initialIds = [
    'maarten_paes',
    'dean_james', 'justin_hubner', 'elkan_baggott', 'kevin_diks',
    'ragnar_oratmangoen', 'calvin_verdonk', 'joey_pelupessy', 'luke_vickery',
    'thom_haye',
    'ole_romeny',
  ];

  @override
  void initState() {
    super.initState();
    final layout = buildFormation(_formation);
    _slots = List.generate(
      11,
      (i) => LineupSlot(
        x: layout[i].x,
        y: layout[i].y,
        role: layout[i].role,
        player: _squad.firstWhere((p) => p.id == _initialIds[i]),
      ),
    );
  }

  
  void _changeFormation(String f) {
    setState(() {
      _formation = f;
      if (f == kFreeForm) return;
      final layout = buildFormation(f);
      for (int i = 0; i < 11; i++) {
        _slots[i]
          ..x = layout[i].x
          ..y = layout[i].y
          ..role = layout[i].role;
      }
    });
  }

  Future<void> _pickPlayer(int index) async {
    final onPitch = _slots.map((s) => s.player?.id).toSet();
    final available = _squad.where((p) => !onPitch.contains(p.id)).toList();

    final result = await showDialog<PickerResult>(
      context: context,
      builder: (_) => PlayerPickerDialog(
        players: available,
        canRemove: _slots[index].player != null,
      ),
    );
    if (result == null) return;
    setState(() => _slots[index].player = result.remove ? null : result.player);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFF0F9F63),
              borderRadius: BorderRadius.circular(26),
            ),
            child: Column(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(22),
                      child: _pitch(),
                    ),
                  ),
                ),
                BottomBar(
                  formation: _formation,
                  mode: _mode,
                  onFormation: _changeFormation,
                  onMode: (m) => setState(() => _mode = m),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _pitch() {
    return LayoutBuilder(
      builder: (context, c) {
        final w = c.maxWidth;
        final h = c.maxHeight;
        final free = _formation == kFreeForm;

        return Container(
          color: const Color(0xFF009358),
          child: Stack(
            children: [
              Positioned.fill(child: CustomPaint(painter: PitchPainter())),
              for (int i = 0; i < _slots.length; i++)
                Positioned(
                  left: _slots[i].x * w - 42,
                  top: _slots[i].y * h - 24,
                  width: 84,
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => _pickPlayer(i),
                    onPanUpdate: free
                        ? (d) => setState(() {
                              _slots[i].x = (_slots[i].x + d.delta.dx / w)
                                  .clamp(0.08, 0.92);
                              _slots[i].y = (_slots[i].y + d.delta.dy / h)
                                  .clamp(0.06, 0.92);
                            })
                        : null,
                    child: PlayerSpot(slot: _slots[i], mode: _mode),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
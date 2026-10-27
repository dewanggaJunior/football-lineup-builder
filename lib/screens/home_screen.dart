import 'dart:ui' as ui;
import 'package:UTS/data/squad_data.dart';
import 'package:UTS/models/formation.dart';
import 'package:UTS/models/lineup_slot.dart';
import 'package:UTS/models/player.dart';
import 'package:UTS/widgets/bottom_bar.dart';
import 'package:UTS/widgets/pitch_painter.dart';
import 'package:UTS/widgets/player_picker.dart';
import 'package:UTS/widgets/player_spot.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:js_interop';
import 'package:web/web.dart' as web;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Player> _players = getSquad();
  final GlobalKey _pitchKey = GlobalKey();

  String _formation = '5-4-1';
  DisplayMode _displayMode = DisplayMode.none;

  late List<LineupSlot> _slots;

  @override
  void initState() {
    super.initState();
    _slots = _createSlots(_formation);
    _setDefaultLineup();
  }

  List<LineupSlot> _createSlots(String formation) {
    final layouts = buildFormation(formation);

    return layouts
        .map(
          (layout) => LineupSlot(x: layout.x, y: layout.y, role: layout.role),
        )
        .toList();
  }

  void _setDefaultLineup() {
    const defaultPlayerIds = [
      'maarten_paes',

      // 5 Bek
      'dean_james',
      'justin_hubner',
      'elkan_baggott',
      'kevin_diks',
      'calvin_verdonk',

      // 4 Tengah
      'ole_romeny',
      'ragnar_oratmangoen',
      'joey_pelupessy',
      'luke_vickery',

      // 1 Depan
      'mitchell_baker',
    ];

    for (var i = 0; i < _slots.length; i++) {
      final playerId = defaultPlayerIds[i];

      final player = _players.cast<Player?>().firstWhere(
        (p) => p?.id == playerId,
        orElse: () => null,
      );

      _slots[i].player = player;
    }
  }

  void _changeFormation(String formation) {
    setState(() {
      _formation = formation;
      _slots = _createSlots(formation);
    });
  }

  void _changeDisplayMode(DisplayMode mode) {
    setState(() {
      _displayMode = mode;
    });
  }

  Future<void> _openPlayerPicker(int index) async {
    final currentPlayer = _slots[index].player;

    final usedPlayers = _slots
        .asMap()
        .entries
        .where((entry) => entry.key != index)
        .map((entry) => entry.value.player)
        .whereType<Player>()
        .toSet();

    final availablePlayers = _players
        .where((player) => !usedPlayers.contains(player))
        .toList();

    final result = await showDialog<PickerResult>(
      context: context,
      builder: (_) => PlayerPickerDialog(
        players: availablePlayers,
        canRemove: currentPlayer != null,
      ),
    );

    if (!mounted || result == null) return;

    setState(() {
      if (result.remove) {
        _slots[index].player = null;
      } else {
        _slots[index].player = result.player;
      }
    });
  }

  void _showMessage(String text) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(text)));
  }

  
Future<void> _saveLineupImage() async {
  ui.Image? image;

  try {
    final context = _pitchKey.currentContext;

    if (context == null) {
      _showMessage('Lapangan belum siap diambil gambarnya');
      return;
    }

    final renderObject = context.findRenderObject();

    if (renderObject is! RenderRepaintBoundary) {
      _showMessage('Gagal mengambil area lapangan');
      return;
    }

    if (renderObject.debugNeedsPaint) {
      await Future<void>.delayed(
        const Duration(milliseconds: 100),
      );
    }

    image = await renderObject.toImage(pixelRatio: 3.0);

    final byteData = await image.toByteData(
      format: ui.ImageByteFormat.png,
    );

    if (byteData == null) {
      _showMessage('Gagal membuat gambar PNG');
      return;
    }

    final bytes = byteData.buffer.asUint8List(
      byteData.offsetInBytes,
      byteData.lengthInBytes,
    );

    final blob = web.Blob(
      [bytes.toJS].toJS,
      web.BlobPropertyBag(type: 'image/png'),
    );

    final url = web.URL.createObjectURL(blob);

    try {
      final anchor = web.HTMLAnchorElement()
        ..href = url
        ..download = 'lineup_timnas.png';

      web.document.body!.append(anchor);
      anchor.click();
      anchor.remove();

      _showMessage('Lineup berhasil diunduh sebagai PNG');
    } finally {
      web.URL.revokeObjectURL(url);
    }
  } catch (e, stackTrace) {
    debugPrint('Gagal mengunduh lineup: $e');
    debugPrintStack(stackTrace: stackTrace);
    _showMessage('Gagal mengunduh PNG. Periksa Debug Console.');
  } finally {
    image?.dispose();
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF087A4B),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(8, 4, 8, 0),
                child: _buildPitch(),
              ),
            ),

            BottomBar(
              formation: _formation,
              mode: _displayMode,
              onFormation: _changeFormation,
              onMode: _changeDisplayMode,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 48,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: const Color(0xFF087247),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Row(
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                    child: ClipOval(
                      child: Column(
                        children: [
                          Expanded(child: Container(color: Colors.red)),
                          Expanded(child: Container(color: Colors.white)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Indonesia',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        'Football Lineup Builder',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(width: 10),

          Container(
            width: 48,
            height: 48,
            decoration: const BoxDecoration(
              color: Color(0xFF087247),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              onPressed: _saveLineupImage,
              icon: const Icon(Icons.download_rounded, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPitch() {
    return RepaintBoundary(
      key: _pitchKey,
      child: Container(
        color: const Color(0xFF087A4B),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Stack(
                clipBehavior: Clip.hardEdge,
                children: [
                  Positioned.fill(
                    child: Container(
                      color: const Color(0xFF07965D),
                      child: CustomPaint(painter: PitchPainter()),
                    ),
                  ),

                  ..._slots.asMap().entries.map((entry) {
                    final index = entry.key;
                    final slot = entry.value;

                    return Positioned(
                      left: constraints.maxWidth * slot.x - 23,
                      top: constraints.maxHeight * slot.y - 23,
                      child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () => _openPlayerPicker(index),
                        child: PlayerSpot(slot: slot, mode: _displayMode),
                      ),
                    );
                  }),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
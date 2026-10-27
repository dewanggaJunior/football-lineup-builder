import 'package:flutter/material.dart';
import '../models/player.dart';

class PickerResult {
  final Player? player;
  final bool remove;
  const PickerResult.pick(this.player) : remove = false;
  const PickerResult.remove()
      : player = null,
        remove = true;
}

class PlayerPickerDialog extends StatefulWidget {
  final List<Player> players; 
  final bool canRemove;

  const PlayerPickerDialog({
    super.key,
    required this.players,
    required this.canRemove,
  });

  @override
  State<PlayerPickerDialog> createState() => _PlayerPickerDialogState();
}

class _PlayerPickerDialogState extends State<PlayerPickerDialog> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final maxH = MediaQuery.of(context).size.height * 0.8;
    final q = _query.trim().toLowerCase();
    final list = widget.players
        .where((p) => q.isEmpty || p.name.toLowerCase().contains(q))
        .toList();

    return Dialog(
      backgroundColor: const Color(0xFF1F1F1F),
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: maxH),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _searchRow(context),
            const Divider(height: 1, color: Color(0xFF333333)),
            Flexible(
              child: ListView(
                shrinkWrap: true,
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                children: [
                  if (widget.canRemove && q.isEmpty) ...[
                    Align(
                      alignment: Alignment.centerLeft,
                      child: GestureDetector(
                        onTap: () =>
                            Navigator.pop(context, const PickerResult.remove()),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: const Color(0xFF3A3A3A),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Text(
                            'Remove player',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                  if (q.isEmpty)
                    const Padding(
                      padding: EdgeInsets.only(bottom: 8),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Suggested players',
                          style: TextStyle(
                            color: Colors.white54,
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  if (list.isEmpty)
                    const Padding(
                      padding: EdgeInsets.all(24),
                      child: Center(
                        child: Text('Pemain tidak ditemukan',
                            style: TextStyle(color: Colors.white54)),
                      ),
                    ),
                  ...list.map(_row),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _searchRow(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 12),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 44,
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: const Color(0xFF2E2E2E),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Row(
                children: [
                  const Icon(Icons.search, color: Colors.white, size: 20),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      autofocus: false,
                      style: const TextStyle(color: Colors.white),
                      cursorColor: const Color(0xFF2ED573),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        isDense: true,
                      ),
                      onChanged: (v) => setState(() => _query = v),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 6),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(
                  color: Color(0xFF2ED573),
                  fontSize: 15,
                  fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  Widget _row(Player p) {
    return InkWell(
      onTap: () => Navigator.pop(context, PickerResult.pick(p)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Container(
              width: 34,
              height: 34,
              decoration: const BoxDecoration(
                  shape: BoxShape.circle, color: Color(0xFF3A3A3A)),
              child: ClipOval(
                child: Image.asset(
                  p.photoAsset,
                  fit: BoxFit.cover,
                  alignment: Alignment.topCenter,
                  errorBuilder: (_, __, ___) => const Icon(Icons.person,
                      color: Colors.white38, size: 20),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(p.name,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w500)),
                  Text(p.position,
                      style: TextStyle(
                          color: Colors.white60, fontSize: 12.5)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'player.dart';

class LineupSlot {
  double x;
  double y;
  String role;
  Player? player;

  LineupSlot({required this.x, required this.y, required this.role, this.player});
}
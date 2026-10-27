const String kFreeForm = 'Free form';

const List<String> kFormations = [
  '4-3-3',
  '4-4-2',
  '4-2-3-1',
  '4-1-4-1',
  '4-3-2-1',
  '4-1-2-1-2',
  '4-4-1-1',
  '3-4-3',
  '3-5-2',
  '3-4-2-1',
  '5-3-2',
  '5-4-1',
];

class SlotLayout {
  final double x;
  final double y;
  final String role;
  const SlotLayout(this.x, this.y, this.role);
}


List<SlotLayout> buildFormation(String formation) {
  final lines = formation.split('-').map(int.parse).toList();
  final result = <SlotLayout>[const SlotLayout(0.5, 0.84, 'GK')];
  final n = lines.length;

  for (int i = 0; i < n; i++) {
    final y = n == 1 ? 0.37 : 0.64 - (0.54 / (n - 1)) * i;
    final role = i == 0 ? 'DF' : (i == n - 1 ? 'FW' : 'MF');
    final c = lines[i];
    for (int j = 0; j < c; j++) {
      double x;
      if (c == 1) {
        x = 0.5;
      } else if (c <= 3) {
        x = (j + 1) / (c + 1);
      } else {
        x = 0.12 + 0.76 * j / (c - 1);
      }
      result.add(SlotLayout(x, y, role));
    }
  }
  return result;
}

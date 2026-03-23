import 'package:equatable/equatable.dart';

enum ReikiLevel { levelI, levelII, levelIIIA, levelIIIB }

extension ReikiLevelExtension on ReikiLevel {
  String get label {
    switch (this) {
      case ReikiLevel.levelI:
        return 'Nível I — Shoden';
      case ReikiLevel.levelII:
        return 'Nível II — Okuden';
      case ReikiLevel.levelIIIA:
        return 'Nível III A — Shinpiden';
      case ReikiLevel.levelIIIB:
        return 'Nível III B — Gokukaiden';
    }
  }
}

class ReikiSymbol extends Equatable {
  final String id;
  final String name;
  final String subtitle;
  final String element;
  final String description;
  final String origin;
  final List<String> actions;
  final ReikiLevel minLevel;
  final String? imagePath;

  const ReikiSymbol({
    required this.id,
    required this.name,
    required this.subtitle,
    required this.element,
    required this.description,
    required this.origin,
    required this.actions,
    required this.minLevel,
    this.imagePath,
  });

  @override
  List<Object?> get props =>
      [id, name, subtitle, element, description, origin, actions, minLevel, imagePath];
}

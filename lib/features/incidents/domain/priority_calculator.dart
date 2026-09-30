import 'package:rescuelink/core/constants/enums.dart';

class PriorityCalculator {
  static IncidentPriority calculatePriority({
    required IncidentCategory category,
    required bool roadBlocked,
    required int peopleAffected,
    required bool isCriticalZone,
  }) {
    int score = 0;

    // Base score by category
    switch (category) {
      case IncidentCategory.fire:
      case IncidentCategory.accident:
        score += 40;
        break;
      case IncidentCategory.flood:
      case IncidentCategory.danger:
        score += 30;
        break;
      case IncidentCategory.roadBlocked:
      case IncidentCategory.water:
        score += 20;
        break;
      case IncidentCategory.lighting:
      case IncidentCategory.other:
        score += 10;
        break;
    }

    // Impact modifiers
    if (roadBlocked) score += 15;
    if (isCriticalZone) score += 15;

    // People affected modifier
    if (peopleAffected > 10) {
      score += 30;
    } else if (peopleAffected > 3) {
      score += 20;
    } else if (peopleAffected > 0) {
      score += 10;
    }

    // Map score to priority band
    if (score >= 80) return IncidentPriority.critical;
    if (score >= 60) return IncidentPriority.high;
    if (score >= 30) return IncidentPriority.medium;
    return IncidentPriority.low;
  }
}

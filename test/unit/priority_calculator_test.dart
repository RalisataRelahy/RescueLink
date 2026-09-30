import 'package:flutter_test/flutter_test.dart';
import 'package:rescuelink/core/constants/enums.dart';
import 'package:rescuelink/features/incidents/domain/priority_calculator.dart';

void main() {
  group('PriorityCalculator Unit Tests', () {
    test('given Fire category with road blocked and 12 people affected then return Critical', () {
      final priority = PriorityCalculator.calculatePriority(
        category: IncidentCategory.fire,
        roadBlocked: true,
        peopleAffected: 12,
        isCriticalZone: true,
      );

      expect(priority, IncidentPriority.critical);
    });

    test('given Lighting category with 0 people affected then return Low', () {
      final priority = PriorityCalculator.calculatePriority(
        category: IncidentCategory.lighting,
        roadBlocked: false,
        peopleAffected: 0,
        isCriticalZone: false,
      );

      expect(priority, IncidentPriority.low);
    });

    test('given Flood category with 4 people affected then return Medium', () {
      final priority = PriorityCalculator.calculatePriority(
        category: IncidentCategory.flood,
        roadBlocked: false,
        peopleAffected: 4,
        isCriticalZone: false,
      );

      // score = 30 (flood) + 20 (>3 people) = 50 -> Medium
      expect(priority, IncidentPriority.medium);
    });

    test('given Danger category with road blocked and 5 people affected then return High', () {
      final priority = PriorityCalculator.calculatePriority(
        category: IncidentCategory.danger,
        roadBlocked: true,
        peopleAffected: 5,
        isCriticalZone: false,
      );

      // score = 30 (danger) + 15 (road) + 20 (>3 people) = 65 -> High
      expect(priority, IncidentPriority.high);
    });

    test('given Accident category with 10 people affected in critical zone then return Critical', () {
      final priority = PriorityCalculator.calculatePriority(
        category: IncidentCategory.accident,
        roadBlocked: true,
        peopleAffected: 10,
        isCriticalZone: true,
      );

      expect(priority, IncidentPriority.critical);
    });

    test('given Water category without road blocked or people affected then return Low', () {
      final priority = PriorityCalculator.calculatePriority(
        category: IncidentCategory.water,
        roadBlocked: false,
        peopleAffected: 0,
        isCriticalZone: false,
      );

      expect(priority, IncidentPriority.low);
    });

    test('given Other category with road blocked only then return Low', () {
      final priority = PriorityCalculator.calculatePriority(
        category: IncidentCategory.other,
        roadBlocked: true,
        peopleAffected: 0,
        isCriticalZone: false,
      );

      // score = 10 (other) + 15 (road) = 25 -> Low
      expect(priority, IncidentPriority.low);
    });
  });
}

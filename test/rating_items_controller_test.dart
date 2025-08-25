import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

import 'package:group_ratings_app/core/models/__models.dart';
import 'package:group_ratings_app/pages/ratings/ratings_items/rating_items_controller.dart';

void main() {
  group('RatingItemController Tests', () {
    late RatingItemController controller;

    setUp(() {
      controller = RatingItemController();
    });

    tearDown(() {
      Get.reset();
    });

    group('User Rating Helper Methods', () {
      test('getCurrentUserRating should return null when no ratings exist', () {
        // Arrange
        controller.groupRatings.add(
          RatingItem(
            id: 'test-rating-id',
            name: 'Test Item',
            ratingScale: 5,
            ratings: [],
            groupId: 'test-group',
            createdBy: 'other-user',
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          ),
        );

        // Act
        final result = controller.getCurrentUserRating('test-rating-id');

        // Assert
        expect(result, isNull);
      });

      test('hasUserRated should return false when no ratings exist', () {
        // Arrange
        controller.groupRatings.add(
          RatingItem(
            id: 'test-rating-id',
            name: 'Test Item',
            ratingScale: 5,
            ratings: [],
            groupId: 'test-group',
            createdBy: 'other-user',
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          ),
        );

        // Act
        final result = controller.hasUserRated('test-rating-id');

        // Assert
        expect(result, isFalse);
      });

      test('getRatingById should return correct rating item', () {
        // Arrange
        final ratingItem = RatingItem(
          id: 'test-rating-id',
          name: 'Test Item',
          ratingScale: 5,
          ratings: [],
          groupId: 'test-group',
          createdBy: 'other-user',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
        controller.groupRatings.add(ratingItem);

        // Act
        final result = controller.getRatingById('test-rating-id');

        // Assert
        expect(result, isNotNull);
        expect(result!.id, equals('test-rating-id'));
        expect(result.name, equals('Test Item'));
      });

      test('getRatingById should return null for non-existent rating', () {
        // Arrange
        controller.groupRatings.add(
          RatingItem(
            id: 'test-rating-id',
            name: 'Test Item',
            ratingScale: 5,
            ratings: [],
            groupId: 'test-group',
            createdBy: 'other-user',
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          ),
        );

        // Act
        final result = controller.getRatingById('non-existent-id');

        // Assert
        expect(result, isNull);
      });
    });

    group('Rating Item Management', () {
      test(
        'canEditRating should return false when user is not authenticated',
        () {
          // Arrange
          final ratingItem = RatingItem(
            id: 'test-rating-id',
            name: 'Test Item',
            ratingScale: 5,
            ratings: [],
            groupId: 'test-group',
            createdBy: 'other-user',
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          );

          // Act
          final result = controller.canEditRating(ratingItem);

          // Assert
          expect(result, isFalse);
        },
      );

      test('canCreateRating should return false when no group context', () {
        // Act
        final result = controller.canCreateRating();

        // Assert
        expect(result, isFalse);
      });
    });
  });
}

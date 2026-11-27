// TEMPORARY INTEGRATION DEPENDENCY (Member 3 — Tinsae Aysheshim):
// Created so Member 2's customer screens can build and test independently.
// Reconcile or replace with Tinsae's canonical MenuItem Freezed model once
// merged.
import 'package:freezed_annotation/freezed_annotation.dart';

part 'menu_item.freezed.dart';

/// Immutable cafeteria menu item entity.
@freezed
abstract class MenuItem with _$MenuItem {
  const factory MenuItem({
    required String id,
    required String name,
    required String description,
    required double price,
    required String imageUrl,
    required String category,
    required bool isAvailable,
    @Default(10) int prepTimeMinutes,
  }) = _MenuItem;
}

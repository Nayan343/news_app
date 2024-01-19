import 'package:flutter/material.dart';

extension ValueNotifierExtention<T> on T {
  /// Returns a `ValueNotifier` instance with [this] `T` as initial value.
  ValueNotifier<T> get obs => ValueNotifier<T>(this);
}
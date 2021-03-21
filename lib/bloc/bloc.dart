// Copyright (c) 2020, Fermented Software.

/// Simple abstract class to remind consumer
/// to close their streams and cancel their
/// subscriptions.
abstract class Bloc {

  /// Called when object is cleared from
  /// memory. Remmber to close streams and
  /// cancel subscriptions.
  void dispose();
}
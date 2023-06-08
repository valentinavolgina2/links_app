import 'package:flutter/widgets.dart';

class ValueNotifierList<T> extends ValueNotifier<List<T>> {
  ValueNotifierList(List<T> value) : super(value);

  void add(T valueToAdd) {
    value = [...value, valueToAdd];
  }

  void addFirst(T valueToAdd) {
    value = [valueToAdd, ...value];
  }

  void remove(T valueToRemove) {
    value = value.where((value) => value != valueToRemove).toList();
  }

  void update() {
    value = [...value];
  }
}
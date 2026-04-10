import 'dart:math';

import 'package:ironkey/password_generator.dart';

class PinPasswordGenerator implements PasswordGenerator{
  @override
  String generate() {
    const numbers = "0123456789";
    final random = Random();

    return List.generate(
        12,
        (_) => numbers[random.nextInt(numbers.length)],
      ).join();
  }
  
}
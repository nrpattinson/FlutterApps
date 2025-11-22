// Modeled off xrandom package

import 'dart:math';

// Based on Wikipedia

class XorshiftRPlus implements Random {
  late int _state0;
  late int _state1;

  XorshiftRPlus([int? s0, int? s1]) {
    if (s0 != null || s1 != null) {
      _state0 = s0!;
      _state1 = s1!;
      if (s0 == 0 && s1 == 0) {
        throw RangeError('The combined seed must not be zero.');
      }
    } else {
      _state0 = 0;
      _state1 = DateTime.now().millisecondsSinceEpoch;
    }
  }

  int _nextRaw64() {
    int x = _state0;
    final int y = _state1;
    _state0 = y;
    x ^= x << 23;
    x ^= x >>> 17;
    x ^= y;
    _state1 = x + y;
    return x;
  }

  (int, int) get internalState {
    return (_state0, _state1);
  }

  @override
  bool nextBool() {
    return _nextRaw64() >= 0;
  }

  @override
  int nextInt(int max) {
    if (max <= 0 || max > 0x100000000) {
      throw RangeError.range(max, 1, 0x100000000, 'max', 'Must be positive and <= 2^32');
    }
    // Powers of 2
    if ((max & -max) == max) {
      return _nextRaw64() & (max - 1);
    }
    int rnd32;
    int result;
    do {
      rnd32 = _nextRaw64() & 0xFFFFFFFF;
      result = rnd32 % max;
    } while ((rnd32 - result + max) > 0x100000000);
    return result;
  }

  @override
  double nextDouble() {
    // Is this correct ? Unused.
    int rnd = _nextRaw64();
    int rnd0 = rnd & 0xFFFFFFFF;
    int rnd1 = rnd >>> 32;
    return rnd0 * 2.3283064365386963e-10 + (rnd1 >>> 12) * 2.220446049250313e-16;
  }
}

Random randomFromJson(Map<String, dynamic> json) {
  final engineName = json['engine'] as String;
  assert(engineName == 'XorshiftRPlus');
  int state0 = json['state0'] as int;
  int state1 = json['state1'] as int;
  return XorshiftRPlus(state0, state1);
}

Map<String, dynamic> randomToJson(Random random) {
  final xorshiftRPlus = random as XorshiftRPlus;
  final state = xorshiftRPlus.internalState;
  final map = <String, dynamic>{};
  map['engine'] = 'XorshiftRPlus';
  map['state0'] = state.$1;
  map['state1'] = state.$2;
  return map;
}


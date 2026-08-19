import 'dart:math';
import 'package:flutter/material.dart';
import '../../data/gameplay_defs.dart';

/// Desenho do clima (chuva, tempestade, vento, nevoeiro) e do overlay de
/// fase do dia — portado do `drawWeather()` da versão web.
class WeatherLayer {
  final Random _rng = Random();
  final List<_Drop> _drops = [];
  final List<Offset> _windStreaks = [];
  double _lightningTimer = 4000;
  double _lightningFlash = 0;

  WeatherType type = WeatherType.none;

  void reset(WeatherType t, Size size) {
    type = t;
    _drops.clear();
    _windStreaks.clear();
    if (t == WeatherType.rain || t == WeatherType.storm) {
      final count = t == WeatherType.storm ? 70 : 45;
      for (var i = 0; i < count; i++) {
        _drops.add(_Drop(
          x: _rng.nextDouble() * size.width,
          y: _rng.nextDouble() * size.height - size.height,
          len: 10 + _rng.nextDouble() * 10,
          speed: 0.4 + _rng.nextDouble() * 0.35,
        ));
      }
    }
    if (t == WeatherType.wind) {
      for (var i = 0; i < 18; i++) {
        _windStreaks.add(Offset(
          _rng.nextDouble() * size.width,
          _rng.nextDouble() * size.height,
        ));
      }
    }
  }

  void update(double dtMs, Size size) {
    if (type == WeatherType.rain || type == WeatherType.storm) {
      for (final d in _drops) {
        d.y += d.speed * dtMs;
        d.x -= 0.12 * dtMs;
        if (d.y > size.height) {
          d.y = -20;
          d.x = _rng.nextDouble() * size.width;
        }
      }
    }
    if (type == WeatherType.wind) {
      for (var i = 0; i < _windStreaks.length; i++) {
        var s = _windStreaks[i];
        var x = s.dx - 0.5 * dtMs;
        if (x < -30) x = size.width + 10;
        _windStreaks[i] = Offset(x, s.dy);
      }
    }
    if (type == WeatherType.storm) {
      _lightningTimer -= dtMs;
      if (_lightningTimer <= 0) {
        _lightningTimer = 3000 + _rng.nextDouble() * 5000;
        _lightningFlash = 120;
      }
      if (_lightningFlash > 0) _lightningFlash -= dtMs;
    }
  }

  void render(Canvas canvas, Size size, double groundY) {
    switch (type) {
      case WeatherType.rain:
      case WeatherType.storm:
        final paint = Paint()
          ..color = const Color(0x8CC8DCFF)
          ..strokeWidth = 1.5;
        for (final d in _drops) {
          canvas.drawLine(Offset(d.x, d.y), Offset(d.x - 4, d.y + d.len), paint);
        }
        if (type == WeatherType.storm && _lightningFlash > 0) {
          final a = (_lightningFlash / 120 * 0.5).clamp(0.0, 0.5);
          canvas.drawRect(
            Rect.fromLTWH(0, 0, size.width, size.height),
            Paint()..color = Colors.white.withOpacity(a),
          );
        }
      case WeatherType.wind:
        final paint = Paint()
          ..color = const Color(0x59FFFFFF)
          ..strokeWidth = 2;
        for (final s in _windStreaks) {
          canvas.drawLine(s, Offset(s.dx + 24, s.dy), paint);
        }
      case WeatherType.fog:
        final fg = Paint()
          ..shader = const LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [Color(0x00DCDCE1), Color(0x8CDCDCE1)],
          ).createShader(Rect.fromLTWH(size.width * 0.4, 0, size.width * 0.6, size.height));
        canvas.drawRect(Rect.fromLTWH(0, 0, size.width, groundY + 20), fg);
      case WeatherType.none:
        break;
    }
  }
}

class _Drop {
  double x;
  double y;
  final double len;
  final double speed;
  _Drop({required this.x, required this.y, required this.len, required this.speed});
}

/// Interpola o overlay das fases do dia (dia → tarde → noite → amanhecer).
Color dayPhaseOverlay(double elapsedMs, {bool forceNight = false}) {
  if (forceNight) return kDayPhases[2].overlay;
  final total = kDayPhases.fold<int>(0, (a, p) => a + p.durMs);
  final t = elapsedMs % total;
  var acc = 0.0;
  for (var i = 0; i < kDayPhases.length; i++) {
    final ph = kDayPhases[i];
    if (t < acc + ph.durMs) {
      final progress = (t - acc) / ph.durMs;
      final next = kDayPhases[(i + 1) % kDayPhases.length];
      return Color.lerp(ph.overlay, next.overlay, progress) ?? ph.overlay;
    }
    acc += ph.durMs;
  }
  return kDayPhases.first.overlay;
}

int dayPhaseIndex(double elapsedMs, {bool forceNight = false}) {
  if (forceNight) return 2;
  final total = kDayPhases.fold<int>(0, (a, p) => a + p.durMs);
  final t = elapsedMs % total;
  var acc = 0.0;
  for (var i = 0; i < kDayPhases.length; i++) {
    if (t < acc + kDayPhases[i].durMs) return i;
    acc += kDayPhases[i].durMs;
  }
  return 0;
}

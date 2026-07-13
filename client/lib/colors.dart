import 'package:flutter/material.dart';

// ─── Field Monitor palette ────────────────────────────────────────────────────

// Status indicator colors
const arenaRed = Color(0xFFE24B4A); // critical / E-stop / red alliance
const arenaAmber = Color(0xFFEF9F27); // warning / A-stop / pause
const arenaGreen = Color(0xFF1D9E75); // ok / connected / success
const arenaBlue = Color(0xFF378ADD); // info / blue alliance / auto
const arenaGrey = Color(0xFF888780); // unknown / bypass / disabled

// Match phase colors
const phasePreBlue = Color(0xFF2870C2); // PRE phase
const phasePauseAmber = Color(0xFFCF8F22); // PAUSE phase
const phaseTeleopTeal = Color(0xFF1A8C64); // TELEOP / READY phase
const phasePostGrey = Color(0xFF3A4048); // POST phase
const phaseDoneGrey = Color(0xFF555E68); // DONE station state

// Surface / background colors
const surfaceCard = Color(0xFF0E1012); // card / container background
const surfaceBar = Color(0xFF111315); // top/bottom bar background
const surfaceIdle = Color(0xFF181B1E); // idle / inactive background
const surfaceBorder = Color(0xFF2A2E33); // border / divider

// Text / label colors
const labelMuted = Color(0xFF4A5058); // section header labels
const labelDim = Color(0xFF6B7480); // secondary / muted text
const labelFaint = Color(0xFFCDD4DC); // very faint / inactive text
const labelIdle = Color(0xFF3E4348); // idle foreground
const labelDimmer = Color(0xFF5A6068); // not-ready hero foreground
const labelOff = Color(0xFF333840); // off-alliance station text

// Special state backgrounds
const bgEStop = Color(0xFFB03030); // E-stop footer / panel
const bgSafe = Color(0xFF1A7C58); // SAFE / fieldReset footer
const bgArmed = Color(0xFF100C00); // ARMED barber pole base
const bgArmedStripe = Color(0xFFCC7000); // ARMED barber pole stripe

// ConnPill text colors (darkened for readability on tinted pill background)
const pillTextOk = Color(0xFF0F6E56);
const pillTextWarn = Color(0xFF854F0B);
const pillTextError = Color(0xFFA32D2D);
const pillTextNone = Color(0xFF5F5E5A);

// ─────────────────────────────────────────────────────────────────────────────

const _supportErrorColor = Color(0xFFD92B2B);
const _supportWarningColor = Color(0xFFD9822B);
const _supportSuccessColor = Color(0xFF2BD92B);
const _supportInfoColor = Color(0xFF2B65D9);
const _neutralColor = Color(0xFF20222F);

// Surface color for dark theme backgrounds and containers
// Base is mid-tone so shades work well for container progression
const _surfaceColor = Color(0xFF282A31);

// Light surface color for light theme backgrounds and containers
const _lightSurfaceColor = Color(0xFFDAE1DE);

MaterialColor createMaterialColor(Color color) {
  final strengths = <double>[.05, .1, .2, .3, .4, .5, .6, .7, .8, .9];
  final swatch = <int, Color>{};
  final r = color.r, g = color.g, b = color.b;

  for (final strength in strengths) {
    final ds = 0.5 - strength;
    swatch[(strength * 1000).round()] = Color.from(
      alpha: 1.0,
      red: r + ((ds < 0 ? r : (1.0 - r)) * ds),
      green: g + ((ds < 0 ? g : (1.0 - g)) * ds),
      blue: b + ((ds < 0 ? b : (1.0 - b)) * ds),
    );
  }
  return MaterialColor(color.toARGB32(), swatch);
}

final supportErrorColor = createMaterialColor(_supportErrorColor);
final supportWarningColor = createMaterialColor(_supportWarningColor);
final supportSuccessColor = createMaterialColor(_supportSuccessColor);
final supportInfoColor = createMaterialColor(_supportInfoColor);
final neutralColor = createMaterialColor(_neutralColor);
final surfaceColor = createMaterialColor(_surfaceColor);
final lightSurfaceColor = createMaterialColor(_lightSurfaceColor);

// Vibrant colors palette - avoiding cyan/teal/blue to prevent clash with primary/secondary
const _vibrantColorPalette = [
  Color(0xFFE74C3C), // Red
  Color(0xFF9B59B6), // Purple
  Color(0xFFF39C12), // Orange
  Color(0xFF2ECC71), // Green
  Color(0xFFE91E63), // Pink/Magenta
  Color(0xFFD35400), // Dark Orange
  Color(0xFFF1C40F), // Yellow
  Color(0xFF16A085), // Dark Teal (warmer, less blue)
  Color(0xFFBDC3C7), // Silver
];

/// Get a vibrant color by index. Wraps around infinitely.
/// Avoids cyan/teal/blue hues that would clash with primary/secondary colors.
Color vibrantColors(int index) {
  return _vibrantColorPalette[index % _vibrantColorPalette.length];
}

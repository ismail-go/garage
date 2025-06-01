import 'dart:ui';

import 'package:flutter/material.dart';

class BlurredBottomNavigationBar extends StatelessWidget {
  final List<BottomNavigationBarItem> items;
  final ValueChanged<int>? onTap;
  final int currentIndex;
  final Color? fixedColor; // Corresponds to selectedItemColor
  final Color? unselectedItemColor;
  final IconThemeData? selectedIconTheme;
  final IconThemeData? unselectedIconTheme;
  final TextStyle? selectedLabelStyle;
  final TextStyle? unselectedLabelStyle;
  final BottomNavigationBarType? type;
  final double blurSigma;
  final Color? backgroundColor; // Optional: to override theme-based semi-transparent color
  final double elevation;

  const BlurredBottomNavigationBar({
    super.key,
    required this.items,
    this.onTap,
    this.currentIndex = 0,
    this.fixedColor,
    this.unselectedItemColor,
    this.selectedIconTheme,
    this.unselectedIconTheme,
    this.selectedLabelStyle,
    this.unselectedLabelStyle,
    this.type,
    this.blurSigma = 3.0,
    this.backgroundColor, // The semi-transparent color for the bar itself
    this.elevation = 0.0, // Default to 0 for blurred/flat look
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final BottomNavigationBarThemeData bnbTheme = theme.bottomNavigationBarTheme;

    // Determine the semi-transparent background color for the container under the blur
    final Color effectiveBackgroundColor = 
        backgroundColor ?? 
        bnbTheme.backgroundColor ?? // This should be semi-transparent from theme
        theme.colorScheme.surface.withOpacity(0.7); // Fallback

    return ClipRect( // Important to clip the blur effect
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
        child: Container(
          color: effectiveBackgroundColor, // Apply the semi-transparent color
          child: BottomNavigationBar(
            items: items,
            onTap: onTap,
            currentIndex: currentIndex,
            elevation: elevation, // Use provided or default to 0, actual BNB elevation
            type: type ?? bnbTheme.type ?? BottomNavigationBarType.fixed,
            fixedColor: fixedColor ?? bnbTheme.selectedItemColor ?? theme.colorScheme.primary,
            unselectedItemColor: unselectedItemColor ?? bnbTheme.unselectedItemColor ?? theme.colorScheme.onSurface.withOpacity(0.7),
            selectedIconTheme: selectedIconTheme ?? bnbTheme.selectedIconTheme,
            unselectedIconTheme: unselectedIconTheme ?? bnbTheme.unselectedIconTheme,
            selectedLabelStyle: selectedLabelStyle ?? bnbTheme.selectedLabelStyle,
            unselectedLabelStyle: unselectedLabelStyle ?? bnbTheme.unselectedLabelStyle,
            backgroundColor: Colors.transparent, // CRUCIAL: Make the actual BNB transparent
            // Other properties like iconSize can be inherited from theme or set explicitly
            iconSize: bnbTheme.selectedIconTheme?.size ?? 24.0,
          ),
        ),
      ),
    );
  }
} 
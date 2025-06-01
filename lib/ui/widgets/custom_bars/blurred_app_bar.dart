import 'dart:ui';

import 'package:flutter/material.dart';

class BlurredAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget? title;
  final List<Widget>? actions;
  final Widget? leading;
  final double blurSigma;
  final Color? backgroundColor; // Optional: if you want to override theme
  final double appBarHeight;

  const BlurredAppBar({
    super.key,
    this.title,
    this.actions,
    this.leading,
    this.blurSigma = 3.0, // Reverted to original default blur intensity
    this.backgroundColor,
    this.appBarHeight = kToolbarHeight,
  });

  @override
  Size get preferredSize => Size.fromHeight(appBarHeight);

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final AppBarTheme appBarTheme = theme.appBarTheme;

    // Determine background color: use provided, then theme, then default
    final Color effectiveBackgroundColor =
        backgroundColor ?? appBarTheme.backgroundColor ?? theme.primaryColor; // Fallback, though appBarTheme.backgroundColor should be set

    return ClipRect(
      // Important to clip the blur effect
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
        child: Container(
          color: effectiveBackgroundColor, // This should be semi-transparent from the theme
          child: SafeArea(
            // Ensures content is not under status bar, etc.
            bottom: false, // No safe area at the bottom for an app bar
            child: Material(
              color: Colors.transparent, // Material widget for ink effects, theming context
              child: Container(
                height: appBarHeight,
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: NavigationToolbar(
                  leading: leading,
                  middle: title != null
                      ? DefaultTextStyle(
                          style: appBarTheme.titleTextStyle ??
                              theme.textTheme.titleLarge!.copyWith(color: appBarTheme.foregroundColor ?? theme.colorScheme.onPrimary),
                          textAlign: TextAlign.center,
                          softWrap: false,
                          overflow: TextOverflow.ellipsis,
                          child: title!,
                        )
                      : null,
                  trailing: actions != null && actions!.isNotEmpty
                      ? Row(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: actions!,
                        )
                      : null,
                  centerMiddle: true,
                  middleSpacing: NavigationToolbar.kMiddleSpacing,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

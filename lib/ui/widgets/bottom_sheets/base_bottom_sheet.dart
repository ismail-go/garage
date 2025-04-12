import 'package:flutter/material.dart';

class BaseBottomSheet extends StatelessWidget {
  final Widget child;

  const BaseBottomSheet({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.all(16.0).add(EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom)),
        child: IntrinsicHeight(
          child: Column(
            children: [
              Container(
                height: 5,
                width: 60,
                margin: EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(color: Colors.grey, borderRadius: BorderRadius.circular(24)),
              ),
              child,
            ],
          ),
        ),
      ),
    );
  }
}

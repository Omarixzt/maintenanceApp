import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../theme/app_animations.dart';

class AnimatedDateButton extends StatefulWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final IconData? icon;

  const AnimatedDateButton({
    Key? key, 
    required this.label, 
    required this.isSelected, 
    required this.onTap, 
    this.icon
  }) : super(key: key);

  @override
  State<AnimatedDateButton> createState() => _AnimatedDateButtonState();
}

class _AnimatedDateButtonState extends State<AnimatedDateButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) {
          setState(() => _isPressed = false);
          widget.onTap();
        },
        onTapCancel: () => setState(() => _isPressed = false),
        child: AnimatedScale(
          scale: _isPressed ? 0.92 : 1.0,
          duration: AppAnimations.fast,
          curve: AppAnimations.smoothOut,
          child: AnimatedContainer(
            duration: AppAnimations.normal,
            curve: AppAnimations.smoothIn,
            decoration: BoxDecoration(
              color: widget.isSelected ? AppTheme.albaikRichRed.withOpacity(0.1) : AppTheme.albaikPureWhite,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: widget.isSelected ? AppTheme.albaikRichRed : Colors.grey.shade300, 
                width: widget.isSelected ? 2 : 1
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (widget.icon != null) ...[
                    Icon(widget.icon, size: 16, color: widget.isSelected ? AppTheme.albaikRichRed : AppTheme.albaikDeepNavy),
                    const SizedBox(width: 6),
                  ],
                  Text(
                    widget.label, 
                    style: TextStyle(
                      fontWeight: FontWeight.bold, 
                      color: widget.isSelected ? AppTheme.albaikRichRed : AppTheme.albaikDeepNavy
                    )
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
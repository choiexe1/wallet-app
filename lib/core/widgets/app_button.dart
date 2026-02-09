import 'package:flutter/material.dart';
import 'package:wallet_app/core/constants/app_color.dart';

class AppButton extends StatefulWidget {
  const AppButton({
    required this.onPressed,
    required this.label,
    this.isLoading = false,
    this.enabled = true,
    super.key,
  });

  final VoidCallback? onPressed;
  final String label;
  final bool isLoading;
  final bool enabled;

  @override
  State<AppButton> createState() => _AppButtonState();
}

class _AppButtonState extends State<AppButton> {
  bool _isPressed = false;

  bool get _canInteract => widget.enabled && !widget.isLoading;

  void _handleTapDown(TapDownDetails details) {
    if (!_canInteract) return;
    setState(() => _isPressed = true);
  }

  void _handleTapUp(TapUpDetails details) {
    if (!_canInteract) return;
    setState(() => _isPressed = false);
    widget.onPressed?.call();
  }

  void _handleTapCancel() {
    if (!_canInteract) return;
    setState(() => _isPressed = false);
  }

  @override
  Widget build(BuildContext context) {
    final backgroundColor = widget.enabled
        ? AppColor.primary
        : AppColor.gray100;
    final textColor = widget.enabled
        ? AppColor.textOnPrimary
        : AppColor.textDisabled;

    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      child: AnimatedScale(
        scale: _isPressed ? 0.96 : 1.0,
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeInOut,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: double.infinity,
          height: 56,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(16),
          ),
          alignment: Alignment.center,
          child: widget.isLoading
              ? SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      widget.enabled
                          ? AppColor.textOnPrimary
                          : AppColor.textDisabled,
                    ),
                  ),
                )
              : Text(
                  widget.label,
                  style: TextStyle(
                    color: textColor,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    height: 1.0,
                  ),
                ),
        ),
      ),
    );
  }
}

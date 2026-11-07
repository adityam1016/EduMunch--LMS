import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../theme/neumorphic_theme.dart';

/// Top Navigation Bar exactly matching the user's reference screenshot
class NMAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool isRoot;
  final VoidCallback? onLeadingTap;
  final VoidCallback? onSearchTap;
  final VoidCallback? onNotificationTap;
  final bool showNotificationBadge;
  final List<Widget>? extraActions;

  const NMAppBar({
    super.key,
    this.title = 'EduMunch',
    this.isRoot = true,
    this.onLeadingTap,
    this.onSearchTap,
    this.onNotificationTap,
    this.showNotificationBadge = true,
    this.extraActions,
  });

  @override
  Size get preferredSize => const Size.fromHeight(72);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: NMTheme.bg,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: SafeArea(
        bottom: false,
        child: Row(
          children: [
            // Left Button: Menu (for root) or Back (for sub-screens)
            Builder(
              builder: (ctx) => NMIconButton(
                icon: isRoot ? Icons.menu_rounded : Icons.arrow_back_ios_new_rounded,
                size: 44,
                iconSize: 22,
                color: NMTheme.textPrimary,
                onTap: onLeadingTap ??
                    () {
                      if (isRoot) {
                        Scaffold.of(ctx).openDrawer();
                      } else {
                        Get.back();
                      }
                    },
              ),
            ),
            const SizedBox(width: 14),

            // Center Pill with Title ("EduMunch")
            Expanded(
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 10),
                  decoration: BoxDecoration(
                    color: NMTheme.surface,
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.8),
                      width: 1.2,
                    ),
                    boxShadow: NMTheme.raisedShadow(offset: 4, blur: 8),
                  ),
                  child: Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: NMTheme.primaryPurple,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 14),

            // Extra actions or standard Search + Notification
            if (extraActions != null)
              ...extraActions!
            else ...[
              // Search Button
              NMIconButton(
                icon: Icons.search_rounded,
                size: 44,
                iconSize: 22,
                color: NMTheme.textSecondary,
                onTap: onSearchTap ?? () => Get.toNamed('/courses'),
              ),
              const SizedBox(width: 10),

              // Notification Button with badge
              Stack(
                clipBehavior: Clip.none,
                children: [
                  NMIconButton(
                    icon: Icons.notifications_none_rounded,
                    size: 44,
                    iconSize: 23,
                    color: NMTheme.textSecondary,
                    onTap: onNotificationTap ?? () => Get.toNamed('/notifications'),
                  ),
                  if (showNotificationBadge)
                    Positioned(
                      top: 4,
                      right: 4,
                      child: Container(
                        width: 9,
                        height: 9,
                        decoration: BoxDecoration(
                          color: NMTheme.accentRed,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 1.5),
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Circular or Rounded Neumorphic Icon Button
class NMIconButton extends StatefulWidget {
  final IconData icon;
  final double size;
  final double iconSize;
  final Color? color;
  final VoidCallback? onTap;
  final double radius;

  const NMIconButton({
    super.key,
    required this.icon,
    this.size = 44,
    this.iconSize = 22,
    this.color,
    this.onTap,
    this.radius = 999,
  });

  @override
  State<NMIconButton> createState() => _NMIconButtonState();
}

class _NMIconButtonState extends State<NMIconButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final isCircular = widget.radius >= 999;
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: widget.onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 120),
        width: widget.size,
        height: widget.size,
        decoration: BoxDecoration(
          color: _isPressed ? NMTheme.sunkenBg : NMTheme.surface,
          shape: isCircular ? BoxShape.circle : BoxShape.rectangle,
          borderRadius: isCircular ? null : BorderRadius.circular(widget.radius),
          border: Border.all(
            color: Colors.white.withOpacity(0.8),
            width: 1.2,
          ),
          boxShadow: _isPressed
              ? []
              : NMTheme.raisedShadow(offset: 3.5, blur: 7),
        ),
        child: Center(
          child: Icon(
            widget.icon,
            size: widget.iconSize,
            color: widget.color ?? NMTheme.textPrimary,
          ),
        ),
      ),
    );
  }
}

/// Raised Neumorphic Card
class NMCard extends StatelessWidget {
  final Widget child;
  final double radius;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? color;
  final VoidCallback? onTap;
  final double elevation;
  final Border? border;

  const NMCard({
    super.key,
    required this.child,
    this.radius = 24,
    this.padding = const EdgeInsets.all(18),
    this.margin,
    this.color,
    this.onTap,
    this.elevation = 4.5,
    this.border,
  });

  @override
  Widget build(BuildContext context) {
    Widget content = Container(
      margin: margin,
      padding: padding,
      decoration: BoxDecoration(
        color: color ?? NMTheme.cardBg,
        borderRadius: BorderRadius.circular(radius),
        border: border ?? Border.all(color: Colors.white.withOpacity(0.7), width: 1.2),
        boxShadow: NMTheme.raisedShadow(offset: elevation, blur: elevation * 2),
      ),
      child: child,
    );

    if (onTap != null) {
      return GestureDetector(
        onTap: onTap,
        child: content,
      );
    }
    return content;
  }
}

/// Sunken / Inset Neumorphic Well
class NMInsetContainer extends StatelessWidget {
  final Widget child;
  final double radius;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? backgroundColor;
  final Color? borderColor;
  final double height;
  final double? width;

  const NMInsetContainer({
    super.key,
    required this.child,
    this.radius = 18,
    this.padding = const EdgeInsets.all(14),
    this.margin,
    this.backgroundColor,
    this.borderColor,
    this.height = double.nan,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height.isNaN ? null : height,
      margin: margin,
      padding: padding,
      decoration: NMTheme.insetDecoration(
        radius: radius,
        backgroundColor: backgroundColor,
        borderColor: borderColor,
      ),
      child: child,
    );
  }
}

/// Raised Pill / Rounded Button with white background and purple text (Like "Join now")
class NMWhiteButton extends StatefulWidget {
  final String text;
  final VoidCallback? onTap;
  final IconData? icon;
  final Color textColor;
  final EdgeInsetsGeometry padding;
  final double radius;

  const NMWhiteButton({
    super.key,
    required this.text,
    this.onTap,
    this.icon,
    this.textColor = NMTheme.primaryPurple,
    this.padding = const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
    this.radius = 16,
  });

  @override
  State<NMWhiteButton> createState() => _NMWhiteButtonState();
}

class _NMWhiteButtonState extends State<NMWhiteButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: widget.onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 120),
        padding: widget.padding,
        decoration: BoxDecoration(
          color: _isPressed ? const Color(0xFFF1F4F9) : Colors.white,
          borderRadius: BorderRadius.circular(widget.radius),
          border: Border.all(
            color: Colors.white,
            width: 1.2,
          ),
          boxShadow: _isPressed
              ? []
              : [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.12),
                    offset: const Offset(0, 4),
                    blurRadius: 10,
                  ),
                  const BoxShadow(
                    color: Colors.white,
                    offset: Offset(-2, -2),
                    blurRadius: 6,
                  ),
                ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (widget.icon != null) ...[
              Icon(widget.icon, size: 16, color: widget.textColor),
              const SizedBox(width: 6),
            ],
            Text(
              widget.text,
              style: TextStyle(
                color: widget.textColor,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Glowing "NOW" badge
class NMGlowingNowBadge extends StatelessWidget {
  const NMGlowingNowBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.22),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white.withOpacity(0.4), width: 1),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF10B981).withOpacity(0.5),
            blurRadius: 10,
            spreadRadius: 1,
          ),
        ],
      ),
      child: const Text(
        'NOW',
        style: TextStyle(
          color: Colors.white,
          fontSize: 11,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

/// "Live" Badge with 3 indicator dots
class NMLiveBadge extends StatelessWidget {
  const NMLiveBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.18),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Live',
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 6),
          _buildDot(const Color(0xFFFF453A)),
          const SizedBox(width: 3),
          _buildDot(const Color(0xFFFF9F0A)),
          const SizedBox(width: 3),
          _buildDot(const Color(0xFF30D158)),
        ],
      ),
    );
  }

  Widget _buildDot(Color color) {
    return Container(
      width: 5.5,
      height: 5.5,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.7),
            blurRadius: 4,
            spreadRadius: 1,
          ),
        ],
      ),
    );
  }
}

/// Raised White Pill Badge (e.g., "11/13")
class NMWhitePillBadge extends StatelessWidget {
  final String text;

  const NMWhitePillBadge({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            offset: const Offset(0, 3),
            blurRadius: 6,
          ),
        ],
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: NMTheme.textPrimary,
          fontSize: 13,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

/// Section Header with title and optional "See more"
class NMSectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onSeeMore;
  final String seeMoreText;

  const NMSectionHeader({
    super.key,
    required this.title,
    this.onSeeMore,
    this.seeMoreText = 'See more',
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w800,
              color: NMTheme.textPrimary,
              letterSpacing: -0.2,
            ),
          ),
          if (onSeeMore != null)
            GestureDetector(
              onTap: onSeeMore,
              child: Text(
                seeMoreText,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF7C3AED),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// Inset Neumorphic Search Bar
class NMSearchBar extends StatelessWidget {
  final String hintText;
  final ValueChanged<String>? onChanged;
  final TextEditingController? controller;

  const NMSearchBar({
    super.key,
    this.hintText = 'Search subjects, tests, teachers...',
    this.onChanged,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: NMTheme.insetDecoration(radius: 20),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        style: const TextStyle(fontSize: 14, color: NMTheme.textPrimary),
        decoration: InputDecoration(
          icon: const Icon(Icons.search_rounded, color: NMTheme.textMuted, size: 22),
          border: InputBorder.none,
          hintText: hintText,
          hintStyle: const TextStyle(color: NMTheme.textMuted, fontSize: 13.5),
        ),
      ),
    );
  }
}

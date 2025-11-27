// File: `lib/src/features/chat/presentation/widgets/service_card.dart`
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../model/action_button.dart';
import '../../data/models/service_model.dart';
import '../theme/chat_ui_config.dart';

class ServiceCard extends StatefulWidget {
  final ProductItemModel service;
  final ChatUIConfig? uiConfig;
  final List<ActionButton>? actionButtons;
  final bool showAnimation;
  final VoidCallback? onTap;

  const ServiceCard({
    super.key,
    required this.service,
    this.uiConfig,
    this.actionButtons,
    this.showAnimation = true,
    this.onTap,
  });

  @override
  State<ServiceCard> createState() => _ServiceCardState();
}

class _ServiceCardState extends State<ServiceCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _scaleAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutBack,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
      ),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOutCubic,
      ),
    );

    if (widget.showAnimation) {
      Future.delayed(const Duration(milliseconds: 100), () {
        if (mounted) _animationController.forward();
      });
    } else {
      _animationController.value = 1.0;
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: GestureDetector(
            onTapDown: (_) => setState(() => _isPressed = true),
            onTapUp: (_) => setState(() => _isPressed = false),
            onTapCancel: () => setState(() => _isPressed = false),
            onTap: widget.onTap,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOutCubic,
              margin: EdgeInsets.only(
                bottom: 16,
                left: 8,
                right:  8,
              ),
              transform: Matrix4.identity()
                ..translate(0.0, _isPressed ? 2.0 : 0.0)
                ..scale(_isPressed ? 0.98 : 1.0),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius:  12,
                    offset: Offset(0,  4),
                    spreadRadius:  0,
                  ),
                ],
                border: Border.all(
                  color: Colors.transparent,
                  width: 1.5,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildImage(context),
                  _buildContent(context),
                  _buildActions(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImage(BuildContext context) {
    final hasDiscount = _calculateDiscount() > 0;

    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      child: Stack(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            child: CachedNetworkImage(
              imageUrl: widget.service.thumbnails?.isNotEmpty == true
                  ? widget.service.thumbnails!.first.toString()
                  : '',
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(
                height: 200,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Theme.of(context).colorScheme.surfaceContainerHighest,
                      Theme.of(context)
                          .colorScheme
                          .surfaceContainerHighest
                          .withValues(alpha: 0.7),
                    ],
                  ),
                ),
                child: Center(
                  child: CircularProgressIndicator(
                    color: widget.uiConfig?.primaryColor ??
                        Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
              errorWidget: (context, url, error) => Container(
                height: 200,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Theme.of(context).colorScheme.surfaceContainerHighest,
                      Theme.of(context)
                          .colorScheme
                          .surfaceContainerHighest
                          .withValues(alpha: 0.7),
                    ],
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.image_not_supported_outlined,
                      size: 56,
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withValues(alpha: 0.3),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Image not available',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withValues(alpha: 0.4),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Gradient overlay for better text readability
          // Positioned(
          //   top: 0,
          //   left: 0,
          //   right: 0,
          //   child: Container(
          //     height: 80,
          //     decoration: BoxDecoration(
          //       gradient: LinearGradient(
          //         begin: Alignment.topCenter,
          //         end: Alignment.bottomCenter,
          //         colors: [
          //           Colors.black.withValues(alpha: 0.3),
          //           Colors.transparent,
          //         ],
          //       ),
          //     ),
          //   ),
          // ),
          // Discount badge
          if (hasDiscount)
            Positioned(
              top: 12,
              right: 12,
              child: _buildDiscountBadge(context),
            ),
          // Favorite button
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _buildPriceSection(context),
          ),
        ],
      ),
    );
  }

  Widget _buildDiscountBadge(BuildContext context) {
    final discount = _calculateDiscount();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.red.shade400,
            Colors.red.shade600,
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.red.withValues(alpha: 0.4),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.local_offer,
            size: 14,
            color: Colors.white,
          ),
          const SizedBox(width: 4),
          Text(
            '${discount.toStringAsFixed(0)}% OFF',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildContent(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  widget.service.title ?? 'Service',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    letterSpacing: -0.5,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          Text(
            widget.service.description ?? '',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context)
                  .colorScheme
                  .onSurface
                  .withValues(alpha: 0.7),
              height: 1.5,
            ),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }



  Widget _buildPriceSection(BuildContext context) {
    final hasPrice = widget.service.price != null;
    final hasMrp = widget.service.mrp != null;
    final hasDiscount = hasMrp && hasPrice && _calculateDiscount() > 0;

    if (!hasPrice && !hasMrp) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        // color: (widget.uiConfig?.primaryColor ??
        //     Theme.of(context).colorScheme.primary)
        //     .withValues(alpha: 0.05),
        gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end:Alignment.topCenter,
          colors: [
            (widget.uiConfig?.primaryColor ??
                Theme.of(context).colorScheme.primary)
                .withValues(alpha: 0.2),
            Colors.transparent,
          ],
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (hasDiscount) ...[
                Text(
                  '₹${widget.service.mrp}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    decoration: TextDecoration.lineThrough,
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withValues(alpha: 0.5),
                  ),
                ),
                const SizedBox(height: 2),
              ],
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '₹${widget.service.price ?? widget.service.mrp}',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: widget.uiConfig?.primaryColor ??
                          Theme.of(context).colorScheme.primary,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Text(
                      'onwards',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withValues(alpha: 0.6),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          if (hasDiscount)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: Colors.green.shade200,
                  width: 1,
                ),
              ),
              child: Text(
                'Save ₹${(double.tryParse(widget.service.mrp ?? '0') ?? 0) - (double.tryParse(widget.service.price ?? '0') ?? 0)}',
                style: TextStyle(
                  color: Colors.green.shade700,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildActions(BuildContext context) {
    final buttons = widget.actionButtons;
    return Padding(
      padding: const EdgeInsets.all(16).copyWith(top: 12),
      child: buttons != null && buttons.isNotEmpty
          ? Row(
        children: buttons.asMap().entries.map((entry) {
          final btn = entry.value;
          final isLast = entry.key == buttons.length - 1;
          return Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: isLast ? 0 : 8),
              child: _StylishButton(
                onTap: () => btn.onTap(widget.service),
                widget: btn.widget,
                isPrimary: entry.key == buttons.length - 1,
                uiConfig: widget.uiConfig,
              ),
            ),
          );
        }).toList(),
      )
          : _buildDefaultButton(context),
    );
  }

  Widget _buildDefaultButton(BuildContext context) {
    return _StylishButton(
      onTap: () => widget.uiConfig?.onTapDefaultActionButton?.call(
        widget.service,
      ),
      widget: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.calendar_today,
            size: 18,
            color: Colors.white,
          ),
          const SizedBox(width: 8),
          const Text(
            'Book Now',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(width: 4),
          Icon(
            Icons.arrow_forward,
            size: 18,
            color: Colors.white,
          ),
        ],
      ),
      isPrimary: true,
      uiConfig: widget.uiConfig,
    );
  }

  double _calculateDiscount() {
    if (widget.service.mrp == null || widget.service.price == null) return 0;
    final mrp = double.tryParse(widget.service.mrp!) ?? 0;
    final price = double.tryParse(widget.service.price!) ?? 0;
    if (mrp <= 0 || price >= mrp) return 0;
    return ((mrp - price) / mrp) * 100;
  }
}

class _StylishButton extends StatefulWidget {
  final VoidCallback? onTap;
  final Widget widget;
  final bool isPrimary;
  final ChatUIConfig? uiConfig;

  const _StylishButton({
    required this.onTap,
    required this.widget,
    this.isPrimary = false,
    this.uiConfig,
  });

  @override
  State<_StylishButton> createState() => _StylishButtonState();
}

class _StylishButtonState extends State<_StylishButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onTap?.call();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        transform: Matrix4.identity()..scale(_isPressed ? 0.95 : 1.0),
        decoration: BoxDecoration(
          gradient: widget.isPrimary
              ? LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              widget.uiConfig?.primaryColor ??
                  Theme.of(context).colorScheme.primary,
              (widget.uiConfig?.primaryColor ??
                  Theme.of(context).colorScheme.primary)
                  .withValues(alpha: 0.8),
            ],
          )
              : null,
          color: widget.isPrimary
              ? null
              : Theme.of(context).colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(12),
          boxShadow: widget.isPrimary
              ? [
            BoxShadow(
              color: (widget.uiConfig?.primaryColor ??
                  Theme.of(context).colorScheme.primary)
                  .withValues(alpha: _isPressed ? 0.2 : 0.4),
              blurRadius: _isPressed ? 8 : 12,
              offset: Offset(0, _isPressed ? 2 : 4),
            ),
          ]
              : null,
          border: !widget.isPrimary
              ? Border.all(
            color: Theme.of(context)
                .colorScheme
                .outline
                .withValues(alpha: 0.3),
          )
              : null,
        ),
        padding: const EdgeInsets.symmetric(vertical: 14),
        child: widget.widget,
      ),
    );
  }
}
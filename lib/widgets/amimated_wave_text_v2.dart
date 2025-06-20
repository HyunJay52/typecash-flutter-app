import 'package:flutter/material.dart';
import 'dart:math' as math;

class AnimatedWaveText extends StatefulWidget {
  final String text;
  final TextStyle textStyle;
  final Duration waveDelay;
  final double waveHeight;
  final Duration waveDuration;
  final bool repeat;
  final Curve curve;

  const AnimatedWaveText({
    super.key,
    required this.text,
    required this.textStyle,
    this.waveDelay = const Duration(milliseconds: 80),
    this.waveHeight = 10.0,
    this.waveDuration = const Duration(milliseconds: 1500),
    this.repeat = true,
    this.curve = Curves.easeInOut,
  });

  @override
  State<AnimatedWaveText> createState() => _AnimatedWaveTextState();
}

class _AnimatedWaveTextState extends State<AnimatedWaveText>
    with TickerProviderStateMixin {
  late List<AnimationController> _controllers;
  late List<Animation<double>> _animations;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _controllers = [];
    _animations = [];

    for (int i = 0; i < widget.text.length; i++) {
      final controller = AnimationController(
        duration: widget.waveDuration,
        vsync: this,
      );

      // 시차를 두고 애니메이션 시작
      Future.delayed(widget.waveDelay * i, () {
        if (mounted) {
          controller.forward();
          if (widget.repeat) {
            controller.repeat(reverse: true);
          }
        }
      });

      final animation = Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).animate(CurvedAnimation(parent: controller, curve: widget.curve));

      _controllers.add(controller);
      _animations.add(animation);
    }
  }

  @override
  void didUpdateWidget(AnimatedWaveText oldWidget) {
    super.didUpdateWidget(oldWidget);

    // 텍스트가 변경되면 애니메이션 재초기화
    if (oldWidget.text != widget.text) {
      for (var controller in _controllers) {
        controller.dispose();
      }
      _initializeAnimations();
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(widget.text.length, (index) {
        // 띄어쓰기 처리
        if (widget.text[index] == ' ') {
          return const SizedBox(width: 4);
        }

        return AnimatedBuilder(
          animation: _animations[index],
          builder: (context, child) {
            // 부드러운 사인파 모션
            final phase = index * 0.5; // 글자마다 위상차
            final value =
                math.sin((_animations[index].value * math.pi * 2) + phase) *
                widget.waveHeight;

            return Transform.translate(offset: Offset(0, value), child: child);
          },
          child: Text(widget.text[index], style: widget.textStyle),
        );
      }),
    );
  }
}

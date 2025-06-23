import 'package:flutter/material.dart';
import 'dart:math' as math;

class AnimatedWaveText extends StatefulWidget {
  final String text;
  final TextStyle textStyle;
  final Duration waveDelay;
  final double waveHeight;
  final Duration waveDuration;
  final bool repeat;

  const AnimatedWaveText({
    Key? key,
    required this.text,
    required this.textStyle,
    this.waveDelay = const Duration(milliseconds: 80),
    this.waveHeight = 10.0,
    this.waveDuration = const Duration(milliseconds: 1000),
    this.repeat = true,
  }) : super(key: key);

  @override
  State<AnimatedWaveText> createState() => _AnimatedWaveTextState();
}

class _AnimatedWaveTextState extends State<AnimatedWaveText> with TickerProviderStateMixin {
  List<AnimationController> _controllers = [];
  List<Animation<double>> _animations = [];

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    // 각 글자마다 컨트롤러와 애니메이션 생성
    for (int i = 0; i < widget.text.length; i++) {
      final controller = AnimationController(
        duration: widget.waveDuration,
        vsync: this,
      );

      // 지연 시작 (글자마다 약간의 시간차)
      Future.delayed(widget.waveDelay * i, () {
        if (mounted) {
          controller.forward();
          if (widget.repeat) {
            controller.repeat(reverse: true);
          }
        }
      });

      // 사인파 애니메이션 (위아래로 움직이는 효과)
      final animation = Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).animate(
        CurvedAnimation(
          parent: controller,
          curve: Curves.easeInOut,
        ),
      );

      _controllers.add(controller);
      _animations.add(animation);
    }
  }

  @override
  void dispose() {
    // 컨트롤러 정리
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
      children: List.generate(
        widget.text.length,
        (index) {
          // 띄어쓰기 처리
          if (widget.text[index] == ' ') {
            return const SizedBox(width: 4);
          }

          return AnimatedBuilder(
            animation: _animations[index],
            builder: (context, child) {
              // 사인파를 이용한 수직 변위 계산
              final value = math.sin(_animations[index].value * math.pi * 2) * widget.waveHeight;

              return Transform.translate(
                offset: Offset(0, value),
                child: Text(
                  widget.text[index],
                  style: widget.textStyle,
                ),
              );
            },
          );
        },
      ),
    );
  }
}
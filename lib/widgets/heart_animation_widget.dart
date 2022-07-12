import 'package:flutter/material.dart';

class HeartAnimation extends StatefulWidget {
  final Widget child;
  final bool isAnimating;
  final Duration duration;
final VoidCallback ? onend;
  HeartAnimation(
      {Key? key,
      this.duration = const Duration(microseconds: 200),
      required this.child,
      required this.isAnimating,this.onend})
      : super(key: key);

  @override
  State<HeartAnimation> createState() => _HeartAnimationState();
}

class _HeartAnimationState extends State<HeartAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<double> scale;

  @override
  void initState() {
    super.initState();

    final halfDuration = widget.duration.inMicroseconds~/2;
    animationController = AnimationController(
        vsync: this, duration: Duration(microseconds: halfDuration));
    scale = Tween<double>(begin: 1, end: 1.1).animate(animationController);
  }

  @override
  void dispose() {
    super.dispose();
    animationController.dispose();

  }

  @override
  void didUpdateWidget(HeartAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isAnimating!= oldWidget) {
      doAnimation();
    }
  }

  doAnimation() async{
  if(widget.isAnimating){
    await animationController.forward();

    await animationController.reverse();
    Future.delayed(Duration(milliseconds: 400));
    if( widget.onend!=null){
      widget.onend!();
    }
  }
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(scale: scale, child: widget.child);
  }
}

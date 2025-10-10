import 'dart:async';

import 'package:flutter/material.dart';

class TimerProgressBar extends StatefulWidget{
  final Duration testDuration;
  final VoidCallback? onTimerFinish;

  const TimerProgressBar({
    required this.testDuration,
    super.key,
    this.onTimerFinish
  });

  @override
  State<TimerProgressBar> createState() => _TimerProgressBarState();
}

class _TimerProgressBarState extends State<TimerProgressBar>
  with TickerProviderStateMixin{
  late AnimationController _controller;
  late Timer _timer;
  int _secondsRemaining = 0;

  @override
  void initState() {
    super.initState();
    _secondsRemaining = widget.testDuration.inSeconds;

    //Инициализация AnimationController
    _controller = AnimationController(
      vsync: this,
    duration: widget.testDuration
    )..forward();// Запускаем анимацию

    _timer = Timer.periodic(Duration(seconds: 1), (timer){
      setState(() {
        if(_secondsRemaining > 0){
          _secondsRemaining--;
        }
        else{
          timer.cancel();
          widget.onTimerFinish?.call();
        }
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
      return  Column(children: [
        AnimatedBuilder(
          animation: _controller,
          builder:(context, builder){
            return LinearProgressIndicator(
            value: 1 - _controller.value,
           backgroundColor: Colors.grey[300],
           valueColor: AlwaysStoppedAnimation<Color>(Colors.lightGreenAccent),
           minHeight: 10,
          );
          } 
        ),
        SizedBox(height: 8),
        Text(
          _formatDuration(Duration(seconds: _secondsRemaining)),
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ],);
  }
  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }
}
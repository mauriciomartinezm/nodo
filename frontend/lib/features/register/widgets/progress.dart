import 'package:flutter/material.dart';

class ProgressDots extends StatelessWidget {
  final int activeIndex;
  final bool isWorker;

  const ProgressDots({
    required this.activeIndex,
    this.isWorker = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final totalSteps = isWorker ? 5 : 4;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(totalSteps, (index) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 5),
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: index == activeIndex ? Colors.orange : Colors.blueGrey,
            shape: BoxShape.circle,
          ),
        );
      }),
    );
  }
}


import 'package:flutter/material.dart';

class ExplicitAnimationsScreen extends StatefulWidget {
  const ExplicitAnimationsScreen({super.key});

  @override
  State<ExplicitAnimationsScreen> createState() =>
      _ExplicitAnimationsScreenState();
}

class _ExplicitAnimationsScreenState extends State<ExplicitAnimationsScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 10),
  );

  late final Animation<Color?> _color = ColorTween(
    begin: Colors.amber,
    end: Colors.red,
  ).animate(_animationController);
  //addListner 매번 컨트롤러의 값이 바뀔 때마다 함수를 실행함
  // 컨트롤러 값 수정됨 => setState 실헹 => build 메사트 다시 실행시킴
  //but,애니메이션 컨트롤러의 매 스텝마다 setState를 하는 것은 성능적으로 좋지 않음
  //그래서 컨트롤러가 변경되었을 때 UI와 통신하는 것에 특화된 위젯 :

  late final Animation<Decoration> _decoration = DecorationTween(
    begin: BoxDecoration(
      color: const Color.fromARGB(255, 171, 255, 242),
      borderRadius: BorderRadius.circular(20),
    ),
    end: BoxDecoration(
      color: const Color.fromARGB(255, 246, 197, 236),
      borderRadius: BorderRadius.circular(120),
    ),
  ).animate(_curve);

  late final Animation<double> _rotation = Tween(
    begin: 0.0,
    end: 1.5,
  ).animate(_curve);

  late final Animation<double> _scale = Tween(
    begin: 1.0,
    end: 1.2,
  ).animate(_curve);

  late final Animation<Offset> _position = Tween(
    begin: const Offset(0, -0.1),
    end: const Offset(0, -0.3),
  ).animate(_curve);

//속성을 초기화할때 this를 쓸거면 late를 사용해야 한다.
  late final CurvedAnimation _curve = CurvedAnimation(
    parent: _animationController,
    curve: Curves.elasticOut,
  );

  void _play() {
    _animationController.forward();
  }

  void _pause() {
    _animationController.stop();
  }

  void _rewind() {
    _animationController.reverse();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("build");
    // animated builder를 사용하면 build는 explicit animations 호출할 때 한 번만 호출되게 된다

    return Scaffold(
      appBar: AppBar(
        title: const Text('Explicit Animations'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedBuilder(
              animation: _color,
              builder: (context, child) {
                return Container(
                  color: _color.value,
                  width: 400,
                  height: 400,
                );
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _play,
                  child: const Text("Play"),
                ),
                ElevatedButton(
                  onPressed: _pause,
                  child: const Text("Pause"),
                ),
                ElevatedButton(
                  onPressed: _rewind,
                  child: const Text("Rewind"),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

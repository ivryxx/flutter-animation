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
    duration: const Duration(seconds: 2),
    reverseDuration: const Duration(seconds: 1),
  )..addListener(() {
      _range.value = _animationController.value;
    });
  // ..addStatusListener((status) {
  //   if (status == AnimationStatus.completed) {
  //     _animationController.reverse();
  //   } else if (status == AnimationStatus.dismissed) {
  //     _animationController.forward();
  //   }
  // });

  // late final Animation<Color?> _color = ColorTween(
  //   begin: Colors.amber,
  //   end: Colors.red,
  // ).animate(_animationController);
  //addListner 매번 컨트롤러의 값이 바뀔 때마다 함수를 실행함
  // 컨트롤러 값 수정됨 => setState 실헹 => build 메사트 다시 실행시킴
  //but,애니메이션 컨트롤러의 매 스텝마다 setState를 하는 것은 성능적으로 좋지 않음
  //그래서 컨트롤러가 변경되었을 때 UI와 통신하는 것에 특화된 위젯 :

  late final Animation<Decoration> _decoration = DecorationTween(
    begin: BoxDecoration(
      color: Colors.amber,
      borderRadius: BorderRadius.circular(20),
    ),
    end: BoxDecoration(
      color: Colors.red,
      borderRadius: BorderRadius.circular(120),
    ),
  ).animate(_curve);

  late final Animation<double> _rotation = Tween(
    begin: 0.0,
    end: 0.5,
  ).animate(_curve);

  late final Animation<double> _scale = Tween(
    begin: 1.0,
    end: 1.1,
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
  void dispose() {
    _animationController.dispose();
    super.dispose();
  } //애니메이션 실행 중에 화면을 나가도 에러가 나지 않게 하기위해서는 컨트롤러를 만들면 폐기해야 함

  final ValueNotifier<double> _range = ValueNotifier(0.0);
  void _onChanged(double value) {
    _range.value = 0;
    _animationController.animateTo(value);
  }

  bool _looping = false;

  void _toggleLooping() {
    if (_looping) {
      _animationController.stop();
    } else {
      _animationController.repeat(reverse: true);
      //repeat에서 reverse를 true로 두면, 애니메이션이 처음으로 돌아가서 다시 repeat되는 게 아니라
      //min 값과 max값 사이를 왔다갔다 repeat한다
    }
    setState(() {
      _looping = !_looping;
    });
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
            SlideTransition(
              position: _position,
              child: ScaleTransition(
                scale: _scale,
                child: RotationTransition(
                  turns: _rotation,
                  child: DecoratedBoxTransition(
                    decoration: _decoration,
                    child: const SizedBox(
                      height: 400,
                      width: 400,
                    ),
                  ),
                ),
              ),
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
                ElevatedButton(
                  onPressed: _toggleLooping,
                  child: Text(
                    _looping ? "Stop looping" : "Start looping",
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 25,
            ),
            ValueListenableBuilder(
              valueListenable: _range,
              builder: (context, value, child) {
                return Slider(
                  value: value,
                  onChanged: _onChanged,
                );
              },
            )
          ],
        ),
      ),
    );
  }
}

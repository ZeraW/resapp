import 'package:flutter/material.dart';

class _TopModalSheet<T> extends StatefulWidget {
  final Widget child;
  Color backgroundColor;

  _TopModalSheet({Key? key, required this.child, this.backgroundColor = Colors.black54}): super(key: key);

  @override
  _TopModalSheetState<T> createState() => _TopModalSheetState<T>();
}

class _TopModalSheetState<T> extends State<_TopModalSheet<T>> with SingleTickerProviderStateMixin {
  final GlobalKey _childKey = GlobalKey();
  Animation<double>? _animation;
  AnimationController? _animationController;
  bool _isPoping = false;

  double get _childHeight {
    final RenderBox renderBox = _childKey.currentContext!.findRenderObject() as RenderBox;
    return renderBox.size.height;
  }

  bool get _dismissUnderway => _animationController!.status == AnimationStatus.reverse;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    _animation = Tween<double>(begin: -1, end: 0).animate(_animationController!);

    _animationController!.addStatusListener((status) {
      if (status == AnimationStatus.dismissed) {
        if(!_isPoping) {
          Navigator.pop(context);
        }
      }
    });

    _animationController!.forward();
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    if (_dismissUnderway) return;

    var change = details.primaryDelta! / (_childHeight);
    _animationController!.value += change;
  }

  void _handleDragEnd(DragEndDetails details) {
    if (_dismissUnderway) return;

    if (details.velocity.pixelsPerSecond.dy > 0) return;

    if (details.velocity.pixelsPerSecond.dy > 700) {
      final double flingVelocity = -details.velocity.pixelsPerSecond.dy / _childHeight;
      if (_animationController!.value > 0.0)
        _animationController!.fling(velocity: flingVelocity);
    } else if (_animationController!.value < 0.5) {
      if (_animationController!.value > 0.0)
        _animationController!.fling(velocity: -1.0);
    } else {
      _animationController!.reverse();
      widget.backgroundColor = Colors.transparent;
      setState(() { });
    }
  }

  Future<bool> onBackPressed({dynamic data}) async {
    _animationController!.reverse();
    widget.backgroundColor = Colors.transparent;
    setState(() {  });

    if(data != null){
      _isPoping = true;
      Navigator.of(context).pop(data);
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: onBackPressed,
        child: GestureDetector(
          onVerticalDragUpdate: _handleDragUpdate,
          onVerticalDragEnd: _handleDragEnd,
          child: SafeArea(
            child: Scaffold(

              backgroundColor: widget.backgroundColor,
              body: Column(
                key: _childKey,
                children: <Widget>[
                  AnimatedBuilder(animation: _animation!, child: widget.child, builder: (context, child) {
                    return Transform(
                      transform: Matrix4.translationValues(0.0, MediaQuery.of(context).size.height * _animation!.value, 0.0),
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        child: GestureDetector(behavior: HitTestBehavior.opaque, child: child, onTap: () {}, ),
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
          excludeFromSemantics: true,
        )
    );
  }

  @override
  void dispose() {
    _animationController!.dispose();
    super.dispose();
  }
}

class TopSheet {
  TopSheet._privateConstructor();

  static final TopSheet instance = TopSheet._privateConstructor();

  final _topModalSheetKey = GlobalKey<_TopModalSheetState>();
  void showTopSheet(BuildContext context,Widget child){
    Navigator.of(context).push<List<int>>(PageRouteBuilder(
        pageBuilder: (_, __, ___) {
          return _TopModalSheet(
            key: _topModalSheetKey,
            child: child,
          );
        },
        opaque: false));
  }
  void hideTopSheet(){
    _topModalSheetKey.currentState!
        .onBackPressed();
  }
}
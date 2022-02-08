import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shake_animation_widget/src/shake_animation_builder.dart';
import 'package:shake_animation_widget/src/shake_animation_controller.dart';
import 'package:shake_animation_widget/src/shake_animation_type.dart';

/// Created by: Created by zhaolong
/// Creation time: Created by on 2020/7/17.
///
/// lib/demo/shake/shake_animation_widget.dart
/// Component of the jitter effect
class ShakeAnimationWidget extends StatefulWidget {
  /// Child widget
  final Widget child;

  /// How violent the shake should be.
  final double shakeRange;

  /// Type of shake animation
  final ShakeAnimationType shakeAnimationType;

  /// Number of times to repeat animation
  final shakeCount;

  /// Randomization value to apply to the shake animation
  final double randomValue;

  final ShakeAnimationController? shakeAnimationController;

  /// Whether or not to start shake immediately
  final bool isForward;
  
  final int speed;

  ShakeAnimationWidget(
      {required this.child,
      this.shakeRange = 0.1,
      this.shakeCount = 0,
      this.shakeAnimationType = ShakeAnimationType.RoateShake,
      this.shakeAnimationController,
      this.isForward = true,
      this.randomValue = 4,
      this.speed = 200});

  @override
  State<StatefulWidget> createState() {
    return _ShakeAnimationState();
  }
}

class _ShakeAnimationState extends State<ShakeAnimationWidget>
    with SingleTickerProviderStateMixin {

  late AnimationController _animationController;

  late Animation<double> _angleAnimation;

  int _shakeTotalCount = 0;

  int _shakeCurrentCount = 0;

  late double _shakeRange;

  /// lib/demo/shake/shake_animation_widget.dart
  @override
  void initState() {
    super.initState();

    _shakeTotalCount = widget.shakeCount;

    _shakeRange = widget.shakeRange;
    if (_shakeRange <= 0) {
      _shakeRange = 0;
    } else if (_shakeRange > 1.0) {
      _shakeRange = 1.0;
    }

    _animationController = AnimationController(
        duration: const Duration(milliseconds: widget.speed), vsync: this);

    ///2、创建串行动画
    _angleAnimation = TweenSequence<double>([
      ///TweenSequenceItem来组合其他的Tween
      TweenSequenceItem<double>(
          tween: Tween(begin: 0, end: _shakeRange), weight: 1),
      TweenSequenceItem<double>(
          tween: Tween(begin: _shakeRange, end: 0), weight: 2),
      TweenSequenceItem<double>(
          tween: Tween(begin: 0, end: -_shakeRange), weight: 3),
      TweenSequenceItem<double>(
          tween: Tween(begin: -_shakeRange, end: 0), weight: 4),
    ]).animate(_animationController);

    ///----------------------------------------------------------------
    ///添加动画状态监听
    _angleAnimation.addStatusListener(statusListener);

    ///----------------------------------------------------------------
    ///添加动画控制器
    if (widget.shakeAnimationController != null) {
      ///参数一 isOpen 为true 是为打开动画
      ///参数二 shakeCount默认为1 执行一次抖动
      widget.shakeAnimationController?.setShakeListener(shakeListener);
    }
    if (widget.isForward) {
      ///正向执行
      _animationController.forward();
      if (widget.shakeAnimationController != null) {
        widget.shakeAnimationController?.animationRunging = true;
      }
    }
  }

  /// lib/demo/shake/shake_animation_widget.dart
  ///抖动动画控制器监听
  void shakeListener(isOpen, shakeCount) {

    _shakeCurrentCount = 0;

    if (isOpen) {
      ///赋值抖动次数
      _shakeTotalCount = shakeCount;
      _animationController.reset();
      _animationController.forward();
    } else {
      ///重置抖动次数
      _shakeTotalCount = widget.shakeCount;

      ///停止抖动动画
      _animationController.stop();
    }
  }

  /// lib/demo/shake/shake_animation_widget.dart
  ///动画执行状态监听
  void statusListener(status) {
    if (status == AnimationStatus.completed) {
      ///正向执行完毕后立刻反向执行（倒回去）
      _animationController.reverse();
    } else if (status == AnimationStatus.dismissed) {
      ///无次数限定执行
      if (_shakeTotalCount == 0) {
        ///反向执行完毕后立刻正向执行
        _animationController.forward();
      } else {
        ///有次数限定执行
        if (_shakeCurrentCount < _shakeTotalCount) {
          ///未执行够次数时继续执行
          _animationController.forward();
        } else {
          if (widget.shakeAnimationController != null) {
            widget.shakeAnimationController?.animationRunging = false;
          }
        }

        ///动画执行次数自增
        _shakeCurrentCount++;
      }
    }
  }

  /// lib/demo/shake/shake_animation_widget.dart
  @override
  void dispose() {
    ///销毁
    _animationController.dispose();
    if(widget.shakeAnimationController!=null){
      ///移动监听
      widget.shakeAnimationController?.removeListener();
    }
    super.dispose();
  }

  /// lib/demo/shake/shake_animation_widget.dar
  @override
  Widget build(BuildContext context) {
    return ShakeAnimationBuilder(
      //执行动画的Widget
      child: widget.child,
      //动画曲线
      animation: _angleAnimation,
      //动画类型
      shakeAnimationType: widget.shakeAnimationType,
      //随机动画时抖动的波动范围
      randomValue: widget.randomValue,
    );
  }
}

/*
 * Created by caowencheng on 2019-07-08
 * @Email 845982120@qq.com
 * @Website https://www.caowencheng.com
 */

import 'package:flutter/material.dart';

class Toast {
    static ToastView preToast;

    static show(BuildContext context, String msg, { bool mask = false }) {
        preToast?.dismiss();
        preToast = null;
        var overlayState = Overlay.of(context);
        var controllerShowAnim = new AnimationController(
            vsync: overlayState,
            duration: Duration(milliseconds: 250),
        );
        var controllerShowOffset = new AnimationController(
            vsync: overlayState,
            duration: Duration(milliseconds: 350),
        );
        var controllerHide = new AnimationController(
            vsync: overlayState,
            duration: Duration(milliseconds: 250),
        );
        var opacityAnim1 =
        new Tween(begin: 0.0, end: 1.0).animate(controllerShowAnim);
        var controllerCurvedShowOffset = new CurvedAnimation(
            parent: controllerShowOffset, curve: _BounceOutCurve._());
        var offsetAnim =
        new Tween(begin: 30.0, end: 0.0).animate(controllerCurvedShowOffset);
        var opacityAnim2 = new Tween(begin: 1.0, end: 0.0).animate(controllerHide);

        OverlayEntry overlayEntry = new OverlayEntry(builder: (context) {
            return ToastWidget(
                opacityAnim1: opacityAnim1,
                opacityAnim2: opacityAnim2,
                offsetAnim: offsetAnim,
                child: buildToastLayout(msg, mask),
            );
        });

        var toastView = ToastView();

        toastView.overlayEntry = overlayEntry;
        toastView.controllerShowAnim = controllerShowAnim;
        toastView.controllerShowOffset = controllerShowOffset;
        toastView.controllerHide = controllerHide;
        toastView.overlayState = overlayState;
        preToast = toastView;
        toastView._show();
    }

    static LayoutBuilder buildToastLayout(String msg, bool mask) {
        return LayoutBuilder(builder: (context, constraints) {
            return IgnorePointer(
                ignoring: !mask,
                child: Material(
                    color: Colors.white.withOpacity(0),
                    child: Stack(
                        alignment: AlignmentDirectional.center,
                        children: <Widget>[
                            Positioned(
                                child: Container(
                                    child: Text(
                                        msg,
                                        style: TextStyle(color: Colors.white),
                                    ),
                                    decoration: BoxDecoration(
                                        color: Colors.black.withOpacity(0.6),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5),
                                        ),
                                    ),
                                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                                ),
                                bottom: 200,
                            )
                        ],
                    )
                ),
            );
        });
    }
}

class ToastView {
    OverlayEntry overlayEntry;
    AnimationController controllerShowAnim;
    AnimationController controllerShowOffset;
    AnimationController controllerHide;
    OverlayState overlayState;
    bool dismissed = false;

    _show() async {
        overlayState.insert(overlayEntry);
        controllerShowAnim.forward();
        controllerShowOffset.forward();
        await Future.delayed(Duration(milliseconds: 3500));
        this.dismiss();
    }

    dismiss() async {
        if (dismissed) {
            return;
        }
        this.dismissed = true;
        controllerHide.forward();
        await Future.delayed(Duration(milliseconds: 250));
        overlayEntry?.remove();
    }
}

class ToastWidget extends StatelessWidget {
    final Widget child;
    final Animation<double> opacityAnim1;
    final Animation<double> opacityAnim2;
    final Animation<double> offsetAnim;

    ToastWidget(
        {this.child, this.offsetAnim, this.opacityAnim1, this.opacityAnim2});

    @override
    Widget build(BuildContext context) {
        return AnimatedBuilder(
            animation: opacityAnim1,
            child: child,
            builder: (context, childToBuild) {
                return Opacity(
                    opacity: opacityAnim1.value,
                    child: AnimatedBuilder(
                        animation: offsetAnim,
                        builder: (context, _) {
                            return Transform.translate(
                                offset: Offset(0, offsetAnim.value),
                                child: AnimatedBuilder(
                                    animation: opacityAnim2,
                                    builder: (context, _) {
                                        return Opacity(
                                            opacity: opacityAnim2.value,
                                            child: childToBuild,
                                        );
                                    },
                                ),
                            );
                        },
                    ),
                );
            },
        );
    }
}

class _BounceOutCurve extends Curve {
    const _BounceOutCurve._();

    @override
    double transform(double t) {
        t -= 1.0;
        return t * t * ((2 + 1) * t + 2) + 1.0;
    }
}

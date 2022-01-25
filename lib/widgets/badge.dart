import 'package:flutter/material.dart';

class Badge extends StatelessWidget {
  final Widget child;
  final String textValue;
  final Color? color;

  const Badge({required this.child, required this.textValue, this.color});
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        this.child,
        Positioned(
          top: 8,
          right: 8,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: this.color != null
                  ? this.color
                  : Theme.of(context).accentColor,
            ),
            constraints: BoxConstraints(maxHeight: 16, maxWidth: 16),
            child: Text(
              this.textValue,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 10),
            ),
          ),
        ),
      ],
    );
  }
}

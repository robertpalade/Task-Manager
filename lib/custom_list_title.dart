import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomListTile extends StatefulWidget {
  final String title;
  final String description;
  bool? isChecked;

  CustomListTile({
    required this.title,
    required this.description,
    required this.isChecked,
  });

  @override
  _CustomListTileState createState() => _CustomListTileState();
}

class _CustomListTileState extends State<CustomListTile>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(_animationController);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          widget.isChecked = !widget.isChecked!;
        });
        _animationController.forward(from: 0);
      },
      child: Row(
        children: [
          Checkbox(
            value: widget.isChecked,
            onChanged: (bool? value) {
              setState(() {
                widget.isChecked = value ?? false;
              });
            },
          ),
          SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                AnimatedBuilder(
                  animation: _animation,
                  builder: (context, child) {
                    return Opacity(
                      opacity: _animation.value,
                      child: Text(
                        widget.description,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CustomListTile extends StatefulWidget {
  final String title;
  final String description;
  final DateTime date;
  bool? isChecked;

  final Function(bool) onCheckboxChanged;
  final Function() onFavourite;
  final Function() onDelete;

  CustomListTile({
    required this.title,
    required this.description,
    required this.date,
    required this.isChecked,
    required this.onCheckboxChanged,
    required this.onFavourite,
    required this.onDelete,
  });

  @override
  _CustomListTileState createState() => _CustomListTileState();
}

class _CustomListTileState extends State<CustomListTile>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  bool _isFavourited = false;

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

  void _onHorizontalDrag(DragEndDetails details) {
    if (details.primaryVelocity! < 0) {
      widget.onDelete();
    } else if (details.primaryVelocity! > 0) {
      setState(() {
        _isFavourited = !_isFavourited;
      });
      widget.onFavourite();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragEnd: _onHorizontalDrag,
      onTap: () {
        setState(() {
          widget.isChecked = !widget.isChecked!;
        });
        _animationController.forward(from: 0);
      },
      child: Dismissible(
        key: UniqueKey(),
        direction: DismissDirection.horizontal,
        onDismissed: (direction) {
          if (direction == DismissDirection.startToEnd) {
            widget.onDelete();
          } else if (direction == DismissDirection.endToStart) {
            setState(() {
              _isFavourited = !_isFavourited;
            });
            widget.onFavourite();
          }
        },
        background: Container(
          color: Colors.red,
          child: Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.only(left: 16.0),
              child: Icon(
                Icons.delete,
                color: Colors.white,
              ),
            ),
          ),
        ),
        secondaryBackground: Container(
          color: Colors.yellow,
          child: Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: EdgeInsets.only(right: 16.0),
              child: Icon(
                _isFavourited ? Icons.favorite : Icons.favorite_border,
                color: Colors.white,
              ),
            ),
          ),
        ),
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
                  SizedBox(width: 8),
                  AnimatedBuilder(
                    animation: _animation,
                    builder: (context, child) {
                      return Opacity(
                        opacity: _animation.value,
                        child: Text(
                          DateFormat('yyyy-MM-dd HH:mm').format(widget.date),
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
            )
          ],
        ),
      ),
    );
  }
}

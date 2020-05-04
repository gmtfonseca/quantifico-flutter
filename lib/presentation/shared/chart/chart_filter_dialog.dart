import 'package:flutter/material.dart';

class ChartFilterDialog extends StatelessWidget {
  final Widget child;
  final VoidCallback onApply;

  ChartFilterDialog({
    Key key,
    this.child,
    this.onApply,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0)),
      backgroundColor: Colors.white,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: Text(
              'Filtros',
              style: Theme.of(context).textTheme.subtitle,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: child,
          ),
          ButtonBar(
            alignment: MainAxisAlignment.spaceEvenly,
            children: [
              FlatButton(
                child: Text('APLICAR'),
                onPressed: () {
                  onApply();
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                child: Text('CANCELAR'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          )
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NutrisiSlider extends StatefulWidget {
  final String node;

  const NutrisiSlider({super.key, required this.node});

  @override
  State<NutrisiSlider> createState() => _NutrisiSliderState();
}

class _NutrisiSliderState extends State<NutrisiSlider> {
  double _value = 560;

  @override
  void initState() {
    super.initState();
    _loadValue();
  }

  void _loadValue() async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getDouble(widget.node);
    if (value != null) {
      setState(() {
        _value = value;
      });
    } else {
      await prefs.setDouble(widget.node, _value);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Slider(
      value: _value,
      min: 560,
      max: 1000,
      divisions: 44,
      label: _value.round().toString(),
      onChanged: (double value) async {
        setState(() {
          _value = value;
        });
        final prefs = await SharedPreferences.getInstance();
        await prefs.setDouble(widget.node, value);
      },
    );
  }
}

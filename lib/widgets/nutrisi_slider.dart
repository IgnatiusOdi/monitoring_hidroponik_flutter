import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NutrisiSlider extends StatefulWidget {
  final String title;

  const NutrisiSlider({super.key, required this.title});

  @override
  State<NutrisiSlider> createState() => _NutrisiSliderState();
}

class _NutrisiSliderState extends State<NutrisiSlider> {
  double _currentSliderValue = 560;

  @override
  Widget build(BuildContext context) {
    return Slider(
      value: _currentSliderValue,
      min: 560,
      max: 1000,
      divisions: 44,
      label: _currentSliderValue.round().toString(),
      onChanged: (double value) async {
        setState(() => _currentSliderValue = value);
        final prefs = await SharedPreferences.getInstance();
        await prefs.setDouble(widget.title, value);
      },
    );
  }
}

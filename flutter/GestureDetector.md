## GestureDetectorを使って、ListViewのリスト全体をリンク化（タップ可能）にできる

https://api.flutter.dev/flutter/widgets/GestureDetector-class.html

```dart
// 略
GestureDetector(
  onTap: () {
    setState(() {
      // Toggle light when tapped.
      _lightIsOn = !_lightIsOn;
    });
  },
  child: Container(
    color: Colors.yellow.shade600,
    padding: const EdgeInsets.all(8),
    // Change button text when light changes state.
    child: Text(_lightIsOn ? 'TURN LIGHT OFF' : 'TURN LIGHT ON'),
  ),
),
```

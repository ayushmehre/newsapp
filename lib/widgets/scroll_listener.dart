
import 'package:flutter/cupertino.dart';

class ScrollListener extends ChangeNotifier {
  double bottom = 0;
  double _last = 0;

  ScrollListener.initialise(ScrollController controller, [double height = 56]) {
    controller.addListener(() {
      final current = controller.offset;
      bottom += _last - current;
      if (bottom <= -height) {
        print("11111111");
        print(bottom);
        bottom = -height;
      }
      if (bottom >= 0) {
        bottom = 0;
        print("22222222");
        print(bottom);
      }
      _last = current;
      if (bottom <= 0 && bottom >= -height) {
        print("33333333");
        print(bottom);
        notifyListeners();
      }
    });
  }
}
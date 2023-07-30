import 'package:flutter/material.dart';

class AppConfig {
  BuildContext _context;
  late double _height;
  late double _width;
  late double _heightPadding;
  late double _widthPadding;
  late MediaQueryData _queryData;
  AppConfig(this._context) {
    _queryData = MediaQuery.of(_context);
    _height = _queryData.size.height / 100.0;
    _width = _queryData.size.width / 100.0;
    _heightPadding = _height -
        ((_queryData.padding.top + _queryData.padding.bottom) / 100.0);
    _widthPadding =
        _width - (_queryData.padding.left + _queryData.padding.right) / 100.0;
  }
  double get bigTextSize => _queryData.size.width / 20;
  double get smallTextSize => _queryData.size.width / 30;

  double rH(double v) {
    return _height * v;
  }

  double rW(double v) {
    return _width * v;
  }

  double rHP(double v) {
    return _heightPadding * v;
  }

  double rWP(double v) {
    return _widthPadding * v;
  }
}

// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'package:flutter_bitshares/home/home.dart';
import 'package:flutter_bitshares/home/home_actions.dart';
import 'package:redux/redux.dart';

final tabsReducer = combineReducers<HomeBottomTab>([
  TypedReducer<HomeBottomTab, UpdateHomeTabAction>(_activeTabReducer),
]);

HomeBottomTab _activeTabReducer(HomeBottomTab activeTab, UpdateHomeTabAction action) {
  return action.newTab;
}

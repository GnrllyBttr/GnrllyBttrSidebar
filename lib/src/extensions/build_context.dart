import 'package:flutter/material.dart';
import 'package:gnrllybttr_sidebar/src/models/models.dart';
import 'package:gnrllybttr_sidebar/src/providers/providers.dart';
import 'package:gnrllybttr_sidebar/src/values/values.dart';

extension BuildContextX on BuildContext {
  GnrllyBttrDecoration get decoration {
    return GnrllyBttrSidebarProvider.of(this);
  }

  SidebarPosition get sidebarPosition {
    return GnrllyBttrSidebarPositionProvider.of(this);
  }
}

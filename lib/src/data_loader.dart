import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

mixin DataLoader<T extends StatefulWidget, E> on State<T> {
  bool isValid();

  E? error();

  FutureOr<void> retry();

  Widget loadingWidgetBuilder();

  Widget loadErrorWidgetBuilder(E? err, FutureOr<void> Function() retryCallback);

  void setRebuildIfValid() {
    if (isValid() || error() != null) {
      setStateEnsureMount();
    }
  }

  Widget buildContents(BuildContext context);

  void setStateEnsureMount() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  @nonVirtual
  Widget build(BuildContext context) {
    final err = error();
    if (err != null) {
      return loadErrorWidgetBuilder(err, () async {
        setStateEnsureMount();
        await retry();
      });
    }
    if (!isValid()) {
      return loadingWidgetBuilder();
    }
    return buildContents(context);
  }
}

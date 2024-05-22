import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

mixin DataLoader<T extends StatefulWidget> on State<T> {
  bool isDataValid();

  bool isError();

  void retry();

  Widget loadingWidgetBuilder();

  Widget loadErrorWidgetBuilder(void Function() retryCallback);

  void setRebuildIfValid() {
    if (isDataValid() || isError()) {
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
    if (isError()) {
      return loadErrorWidgetBuilder(() {
        retry();
        setStateEnsureMount();
      });
    }
    if (!isDataValid()) {
      return loadingWidgetBuilder();
    }
    return buildContents(context);
  }
}

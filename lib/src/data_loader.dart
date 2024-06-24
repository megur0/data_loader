import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

mixin DataLoader<T extends StatefulWidget> on State<T> {
  bool isValid();

  bool isError();

  void retry();

  Widget loadingWidgetBuilder();

  Widget loadErrorWidgetBuilder(void Function() retryCallback);

  void setRebuildIfValid() {
    if (isValid() || isError()) {
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
    if (!isValid()) {
      return loadingWidgetBuilder();
    }
    return buildContents(context);
  }
}

import 'package:flutter/material.dart';
class DialogUtlis{
static  void showMessageDialog(BuildContext context,
      {required String message,
        VoidCallback? posAction,
        VoidCallback? negAction,
        String? posTitle,
        String? negTitle}) {
    List<Widget> actions = [];
    if (posTitle != null) {
      actions.add(
        TextButton(
            onPressed: () {
              Navigator.pop(context);
              posAction?.call();
            },
            child: Text(posTitle)),
      );
    }
    if (negTitle != null) {
      actions.add(
        TextButton(
            onPressed: () {
              Navigator.pop(context);
              negAction?.call();
            },
            child: Text(negTitle)),
      );
    }
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Text(message),
          actions: actions,
        );
      },
    );
  }

 static void showLoadingDialog(BuildContext context, {required String message}) async{

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          content:
          SizedBox(
            width: double.infinity,
            child: Row(
              children: [
                const CircularProgressIndicator(),
                const SizedBox(width: 12),
                Text(message),
              ],
            ),
          ),
        );
      },
    );
  }

 static void hideLoadingDialog(BuildContext context) {
    Navigator.pop(context);
  }


}


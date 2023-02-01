import 'package:bibliophile/util/constant.dart';
import 'package:flutter/material.dart';

abstract class CustomFunction {
  static Future<void> logoutDialog(BuildContext context) async {
    return showDialog<void>(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) => AlertDialog(
        titlePadding: const EdgeInsets.only(left: 20, right: 10, top: 20),
        title:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Row(
            children: const [
              Icon(
                Icons.warning_amber_outlined,
                color: textSecondary,
              ),
              SizedBox(
                width: 5,
              ),
              Text(
                'OOPS!',
                style: TextStyle(
                    color: textSecondary,
                    fontWeight: FontWeight.w500,
                    fontSize: 16),
              )
            ],
          )
        ]),
        content: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'GOOGLE SIGN IN FAILED!',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: textPrimary, fontSize: 14),
                ),
              ],
            ),
          ),
        ),
        actionsPadding: const EdgeInsets.only(left: 5, right: 5, top: 5),
        actions: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Container(),
              ),
              const SizedBox(),
              Expanded(
                  child: TextButton(
                style: TextButton.styleFrom(
                    backgroundColor: bgInfo,
                    padding: const EdgeInsets.only(
                        left: 20, right: 20, top: 10, bottom: 10)),
                onPressed: () => {
                  Navigator.of(context).pop(),
                },
                child: const Text('OK',
                    style: TextStyle(
                        color: textSecondary,
                        fontSize: 12,
                        overflow: TextOverflow.ellipsis)),
              ))
            ],
          ),
          const SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}

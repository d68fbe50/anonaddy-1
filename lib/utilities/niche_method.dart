import 'package:anonaddy/shared_components/constants/toast_messages.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';

class NicheMethod {
  static String fixDateTime(dynamic input) {
    if (input.runtimeType == DateTime) {
      return '${input.month}/${input.day}/${input.year.toString().substring(2)} ${input.hour}:${input.minute}';
    } else {
      return '$input';
    }
  }

  static copyOnTap(String input) async {
    await Clipboard.setData(
      ClipboardData(text: input),
    ).catchError((error) {
      showToast("$kFailedToCopy: $error");
    }).whenComplete(() {
      showToast(kCopiedToClipboard);
    });
  }

  static showToast(String message) async {
    await Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.grey[600],
    );
  }

  static launchURL(String url) async {
    await launch(url).catchError((error, stackTrace) {
      throw showToast(error.toString());
    });
  }

  static correctAliasString(String input) {
    switch (input) {
      case 'random_characters':
        return 'Random Characters';
      case 'random_words':
        return 'Random Words';
      case 'custom':
        return 'Custom';
      default:
        return 'UUID';
    }
  }
}

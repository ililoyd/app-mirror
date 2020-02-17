import 'package:flutter/material.dart';

import 'package:flutter/gestures.dart';
typedef OnLinkTap = void Function(String url);
const linkStyle = const TextStyle(
        fontWeight: FontWeight.bold,
        color: Color(0xffef5055),
        decorationColor: Color(0xffef5055),);
class LinkTextSpan extends TextSpan {
  // Beware!
  //
  // This class is only safe because the TapGestureRecognizer is not
  // given a deadline and therefore never allocates any resources.
  //
  // In any other situation -- setting a deadline, using any of the less trivial
  // recognizers, etc -- you would have to manage the gesture recognizer's
  // lifetime and call dispose() when the TextSpan was no longer being rendered.
  //
  // Since TextSpan itself is @immutable, this means that you would have to
  // manage the recognizer from outside the TextSpan, e.g. in the State of a
  // stateful widget that then hands the recognizer to the TextSpan.
  final String url;

  LinkTextSpan(
      {TextStyle style,
      this.url,
      String text,
      OnLinkTap onLinkTap,
      List<TextSpan> children})
      : super(
          style: style,
          text: text,
          children: children ?? <TextSpan>[],
          recognizer: TapGestureRecognizer()
            ..onTap = () {
              onLinkTap(url);
            },
        );
}
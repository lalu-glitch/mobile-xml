import 'package:flutter/material.dart';

import '../../../../../core/helper/constant_finals.dart';

class InfoText extends StatelessWidget {
  final String label;
  final String value;

  const InfoText(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [TextLabel(label), TextBody(value)],
      ),
    );
  }
}

/// === TEXT HELPER WIDGETS ===

class TextTitle extends StatelessWidget {
  final String text;
  const TextTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
    );
  }
}

class TextSub extends StatelessWidget {
  final String text;
  const TextSub(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 12,
        color: kNeutral70,
        fontWeight: FontWeight.w400,
      ),
    );
  }
}

class TextLabel extends StatelessWidget {
  final String text;
  const TextLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 12,
        color: kNeutral70,
        fontWeight: FontWeight.w400,
      ),
    );
  }
}

class TextBody extends StatelessWidget {
  final String text;
  const TextBody(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
    );
  }
}

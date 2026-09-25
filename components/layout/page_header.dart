import 'package:flutter/material.dart';

import 'header_title.dart';

/// Standard top bar for a tab page that lives inside a bottom-nav shell and
/// has no [AppBar]. Matches an [AppBar]'s geometry — full status-bar inset
/// plus a [kToolbarHeight] row with vertically-centred content — so every
/// tab's header lines up. Renders the standardised [HeaderTitle] (or a
/// custom [leading] widget) followed by any trailing [actions].
class PageHeader extends StatelessWidget {
  const PageHeader({
    this.title,
    this.leading,
    this.actions,
    super.key,
  }) : assert(
          title != null || leading != null,
          'Provide either a title or a leading widget',
        );

  final String? title;
  final Widget? leading;
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: SizedBox(
        height: kToolbarHeight,
        child: Padding(
          padding: const EdgeInsets.only(left: 18, right: 8),
          child: Row(
            children: [
              Expanded(child: leading ?? HeaderTitle(title!)),
              ...?actions,
            ],
          ),
        ),
      ),
    );
  }
}

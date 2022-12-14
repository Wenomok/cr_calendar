import 'dart:ui';

import 'package:cr_calendar/cr_calendar.dart';
import 'package:flutter/material.dart';

class WeekDrawer {
  WeekDrawer(this.lines);

  List<EventsLineDrawer> lines;
}

class EventsLineDrawer {
  List<EventProperties> events = []; // max 7
}

/// Event widget properties used in [EventBuilder].
class EventProperties {
  EventProperties({
    required this.begin,
    required this.end,
    required this.name,
    required this.backgroundColor,
  });

  /// Begin day number.
  int begin; // min 1 / max 7
  /// End day number.
  int end; // min 1 / max 7
  /// Background color.
  Color backgroundColor;

  /// Name displayed at start of the event widget.
  String name;

  int size() => end - begin + 1;
}

class DXBEventProperties implements EventProperties {
  DXBEventProperties({
    required this.campaignBegin,
    required this.begin,
    required this.end,
    required this.dashboardEnd,
    required this.name,
    required this.backgroundColor,
  });

  int campaignBegin;
  /// Begin day number.
  @override
  int begin; // min 1 / max 7
  /// End day number.
  @override
  int end; // min 1 / max 7
  int dashboardEnd;
  /// Background color.
  @override
  Color backgroundColor;

  /// Name displayed at start of the event widget.
  @override
  String name;

  @override
  int size() => end - begin + 1;
}
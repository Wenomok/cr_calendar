import 'package:cr_calendar/cr_calendar.dart';
import 'package:flutter/material.dart';

class CalendarEventModel {
  CalendarEventModel({
    required this.name,
    required this.begin,
    required this.end,
    this.eventColor = Colors.green,
  });

  String name;
  DateTime begin;
  DateTime end;
  Color eventColor;
}

class DXBCalendarEventModel implements CalendarEventModel {
  DXBCalendarEventModel({
    required this.name,
    required this.campaignBegin,
    required this.begin,
    required this.end,
    required this.dashboardEnd,
    this.eventColor = Colors.green,
  });

  DateTime campaignBegin;
  @override
  DateTime begin;
  @override
  DateTime end;
  DateTime dashboardEnd;

  @override
  Color eventColor;

  @override
  String name;
}
import 'package:cr_calendar/src/contract.dart';
import 'package:cr_calendar/src/cr_calendar.dart';
import 'package:cr_calendar/src/extensions/datetime_ext.dart';
import 'package:cr_calendar/src/extensions/jiffy_ext.dart';
import 'package:cr_calendar/src/models/calendar_event_model.dart';
import 'package:cr_calendar/src/models/drawers.dart';
import 'package:cr_calendar/src/models/event_count_keeper.dart';
import 'package:jiffy/jiffy.dart';

///Returns list of events for [date]
List<CalendarEventModel> calculateAvailableEventsForDate(
    List<CalendarEventModel> events, Jiffy date) {
  final eventsHappen = <CalendarEventModel>[];
  for (final event in events) {
    final eventStartUtc =
        DateTime.utc(event.begin.year, event.begin.month, event.begin.day);
    final eventEndUtc =
        DateTime.utc(event.end.year, event.end.month, event.end.day);
    if (date.isInRange(eventStartUtc.toJiffy(), eventEndUtc.toJiffy())) {
      eventsHappen.add(event);
    }
  }

  return eventsHappen;
}

List<CalendarEventModel> calculateAvailableEventsForRange(
    List<CalendarEventModel> events, Jiffy? start, Jiffy? end) {
  final eventsHappen = <CalendarEventModel>[];

  for (final event in events) {
    final eventStartUtc =
        DateTime.utc(event.begin.year, event.begin.month, event.begin.day);
    final eventEndUtc =
        DateTime.utc(event.end.year, event.end.month, event.end.day);
    if (eventStartUtc.toJiffy().isInRange(start, end) ||
        eventEndUtc.toJiffy().isInRange(start, end) ||
        (start?.isInRange(eventStartUtc, eventEndUtc) ?? false) ||
        (end?.isInRange(eventStartUtc, eventEndUtc) ?? false)) {
      eventsHappen.add(event);
    }
  }

  return eventsHappen;
}

/// Returns drawers for [week]
List<EventProperties> resolveEventDrawersForWeek(
    int week, Jiffy monthStart, List<CalendarEventModel> events) {
  final drawers = <EventProperties>[];

  final beginDate = Jiffy.parseFromJiffy(monthStart).add(weeks: week);
  final endDate = Jiffy.parseFromJiffy(beginDate).add(days: Contract.kWeekDaysCount - 1);

  for (final e in events) {
    final simpleEvent = _mapSimpleEventToDrawerOrNull(e, beginDate, endDate);
    if (simpleEvent != null) {
      drawers.add(simpleEvent);
    }
  }

  return drawers;
}

/// This method maps CalendarEventItem to EventDrawer and calculates drawer begin and end
EventProperties? _mapSimpleEventToDrawerOrNull(
    CalendarEventModel event, Jiffy begin, Jiffy end) {
  if(event is DXBCalendarEventModel) {
    final jCampaignBegin = DateTime.utc(
      event.campaignBegin.year,
      event.campaignBegin.month,
      event.campaignBegin.day,
      event.campaignBegin.hour,
      event.campaignBegin.minute,
    ).toJiffy();
    final jBegin = DateTime.utc(
      event.begin.year,
      event.begin.month,
      event.begin.day,
      event.begin.hour,
      event.begin.minute,
    ).toJiffy();
    final jEnd = DateTime.utc(
      event.end.year,
      event.end.month,
      event.end.day,
      event.end.hour,
      event.end.minute,
    ).toJiffy();
    final jDashboardEnd = DateTime.utc(
      event.dashboardEnd.year,
      event.dashboardEnd.month,
      event.dashboardEnd.day,
      event.dashboardEnd.hour,
      event.dashboardEnd.minute,
    ).toJiffy();

    if (jDashboardEnd.isBefore(begin, unit: Unit.day) || jCampaignBegin.isAfter(end, unit: Unit.day)) {
      return null;
    }
    var campaignBeginDay = 1;
    if (jCampaignBegin.isSameOrAfter(begin)) {
      campaignBeginDay = (begin.dayOfWeek - jCampaignBegin.dayOfWeek < 1)
          ? 1 - (begin.dayOfWeek - jCampaignBegin.dayOfWeek)
          : 1 - (begin.dayOfWeek - jCampaignBegin.dayOfWeek) + WeekDay.values.length;
    }

    var beginDay = Contract.kWeekDaysCount;
    if (jBegin.isSameOrAfter(begin)) {
      beginDay = (begin.dayOfWeek - jBegin.dayOfWeek < 1)
          ? 1 - (begin.dayOfWeek - jBegin.dayOfWeek)
          : 1 - (begin.dayOfWeek - jBegin.dayOfWeek) + WeekDay.values.length;
    }

    var endDay = Contract.kWeekDaysCount;
    if (jEnd.isSameOrAfter(begin)) {
      endDay = (begin.dayOfWeek - jEnd.dayOfWeek < 1)
          ? 1 - (begin.dayOfWeek - jEnd.dayOfWeek)
          : 1 - (begin.dayOfWeek - jEnd.dayOfWeek) + WeekDay.values.length;
    }

    var dashboardEndDay = Contract.kWeekDaysCount;
    if (jDashboardEnd.isSameOrBefore(end)) {
      dashboardEndDay = (begin.dayOfWeek - jDashboardEnd.dayOfWeek < 1)
          ? 1 - (begin.dayOfWeek - jDashboardEnd.dayOfWeek)
          : 1 - (begin.dayOfWeek - jDashboardEnd.dayOfWeek) + WeekDay.values.length;
    }

    return DXBEventProperties(
        campaignBegin: campaignBeginDay,
        begin: beginDay,
        end: endDay,
        dashboardEnd: dashboardEndDay,
        name: event.name,
        backgroundColor: event.eventColor
    );
  } else {
    final jBegin = DateTime.utc(
      event.begin.year,
      event.begin.month,
      event.begin.day,
      event.begin.hour,
      event.begin.minute,
    ).toJiffy();
    final jEnd = DateTime.utc(
      event.end.year,
      event.end.month,
      event.end.day,
      event.end.hour,
      event.end.minute,
    ).toJiffy();

    if (jEnd.isBefore(begin, unit: Unit.day) || jBegin.isAfter(end, unit: Unit.day)) {
      return null;
    }

    var beginDay = 1;
    if (jBegin.isSameOrAfter(begin)) {
      beginDay = (begin.dayOfWeek - jBegin.dayOfWeek < 1)
          ? 1 - (begin.dayOfWeek - jBegin.dayOfWeek)
          : 1 - (begin.dayOfWeek - jBegin.dayOfWeek) + WeekDay.values.length;
    }

    var endDay = Contract.kWeekDaysCount;
    if (jEnd.isSameOrBefore(end)) {
      endDay = (begin.dayOfWeek - jEnd.dayOfWeek < 1)
          ? 1 - (begin.dayOfWeek - jEnd.dayOfWeek)
          : 1 - (begin.dayOfWeek - jEnd.dayOfWeek) + WeekDay.values.length;
    }

    return EventProperties(
        begin: beginDay,
        end: endDay,
        name: event.name,
        backgroundColor: event.eventColor);
  }
}

/// Map EventDrawers to EventsLineDrawer and sort them by duration on current week
List<EventsLineDrawer> placeEventsToLines(
    List<EventProperties> events, int maxLines) {
  final copy = <EventProperties>[...events]
    ..sort((a, b) => b.size().compareTo(a.size()));

  final lines = List.generate(maxLines, (index) {
    final lineDrawer = EventsLineDrawer();
    for (var day = 1; day <= Contract.kWeekDaysCount; day++) {
      final candidates = <EventProperties>[];
      copy.forEach((e) {
        if (day == e.begin) {
          candidates.add(e);
        }
      });
      candidates.sort((a, b) => b.size().compareTo(a.size()));
      if (candidates.isNotEmpty) {
        lineDrawer.events.add(candidates.first);
        copy.remove(candidates.first);
        day += candidates.first.size() - 1;
      }
    }
    return lineDrawer;
  });
  return lines;
}

///Return list of not fitted events
List<NotFittedWeekEventCount> calculateOverflowedEvents(
    List<List<EventProperties>> monthEvents, int maxLines) {
  final weeks = <NotFittedWeekEventCount>[];
  for (final week in monthEvents) {
    var countList = List.filled(WeekDay.values.length, 0);

    for (final event in week) {
      for (var i = event.begin - 1; i < event.end; i++) {
        countList[i]++;
      }
    }
    countList = countList.map((count) {
      final notFitCount = count - maxLines;
      return notFitCount <= 0 ? 0 : notFitCount;
    }).toList();
    weeks.add(NotFittedWeekEventCount(countList));
  }
  return weeks;
}

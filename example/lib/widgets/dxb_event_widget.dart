import 'package:cr_calendar/cr_calendar.dart';
import 'package:flutter/material.dart';

/// Custom event widget with rounded borders
class DXBEventWidget extends StatelessWidget {
  const DXBEventWidget({
    required this.drawer,
    super.key,
  });

  final DXBEventProperties drawer;

  @override
  Widget build(BuildContext context) {
    var diffCampaignBegin = drawer.begin == 7 ? drawer.begin - drawer.campaignBegin + 1 : drawer.begin - drawer.campaignBegin;
    if(drawer.campaignBegin > drawer.begin) {
      diffCampaignBegin = 7 - drawer.campaignBegin;
    }

    var diffEndBegin = drawer.end == 7 ? drawer.end - drawer.begin : drawer.end - drawer.begin;
    if(drawer.begin > drawer.end) {
      diffEndBegin = 7 - drawer.begin;
    } else {
      if(drawer.end == 7 && drawer.begin != 7) {
        diffEndBegin += 1;
      }
      // if(diffEndBegin == 0) {
      //   diffEndBegin = 1;
      // }
    }

    var diffDashboardEnd = drawer.dashboardEnd == 7 ? drawer.dashboardEnd - drawer.end : drawer.dashboardEnd - drawer.end;
    if(drawer.end > drawer.dashboardEnd) {
      diffDashboardEnd = 7 - drawer.end;
    } else {
      if(drawer.dashboardEnd == 7 && drawer.end != 7) {
        diffDashboardEnd += 1;
      }
    }

    final screenWidth = MediaQuery.of(context).size.width;

    return Row(
      children: [
        Container(
          // margin: const EdgeInsets.symmetric(horizontal: 3),
          // padding: const EdgeInsets.symmetric(horizontal: 5),
          width: diffCampaignBegin > 0 ? screenWidth * (diffCampaignBegin / 7.0) : 0.0,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.horizontal(left: Radius.circular(4)),
            border: Border.all(
              color: drawer.backgroundColor,
            ),
          ),
          // child: diffCampaignBegin > 0 ? Stack(
          //   children: [
          //     FittedBox(
          //       fit: BoxFit.fitHeight,
          //       alignment: Alignment.centerLeft,
          //       child: Text(
          //         drawer.name,
          //         overflow: TextOverflow.ellipsis,
          //         style: const TextStyle(color: Colors.black),
          //       ),
          //     ),
          //   ],
          // ) : null
        ),
        Container(
          // margin: const EdgeInsets.symmetric(horizontal: 3),
          // padding: const EdgeInsets.symmetric(horizontal: 5),
            width: diffEndBegin > 0 ? screenWidth * (diffEndBegin / 7.0) : 0.0,
            decoration: BoxDecoration(
              // borderRadius: const BorderRadius.all(Radius.circular(4)),
              color: drawer.backgroundColor,
            ),
            child: Stack(
              children: [
                FittedBox(
                  fit: BoxFit.fitHeight,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    drawer.name,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.black),
                  ),
                ),
              ],
            )
        ),
        Container(
          // margin: const EdgeInsets.symmetric(horizontal: 3),
          // padding: const EdgeInsets.symmetric(horizontal: 5),
          width: diffDashboardEnd > 0 ? screenWidth * (diffDashboardEnd / 7.0) : 0.0,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.horizontal(right: Radius.circular(4)),
            border: Border.all(
              color: drawer.backgroundColor,
            ),
          ),
          // child: diffDashboardEnd > 0 ? Stack(
          //   children: [
          //     FittedBox(
          //       fit: BoxFit.fitHeight,
          //       alignment: Alignment.centerLeft,
          //       child: Text(
          //         drawer.name,
          //         overflow: TextOverflow.ellipsis,
          //         style: const TextStyle(color: Colors.black),
          //       ),
          //     ),
          //   ],
          // ) : null
        )
      ],
    );
  }
}

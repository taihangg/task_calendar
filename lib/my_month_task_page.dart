import 'package:flutter/material.dart';

import 'my_global_data.dart';
import 'my_month_view.dart';
import 'my_task_view.dart';

class MyMonthViewPage extends StatelessWidget {
  final double screenWidth;
  final double screenHeight;
  MyMonthViewPage(this.screenWidth, this.screenHeight);

  @override
  build(BuildContext context) {
    List<Widget> headerSliverBuilder(
        BuildContext context, bool innerBoxIsScrolled) {
      return [
        SliverOverlapAbsorber(
          handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
          child: SliverAppBar(
//            floating: true,
//            snap: true,
            pinned: true, // bottom内容是否保留不滑出屏幕
            forceElevated: innerBoxIsScrolled,
            expandedHeight: screenWidth / 7 * 8, // 这个高度必须比flexibleSpace高度大
            flexibleSpace:
                FlexibleSpaceBar(background: MyMonthView(screenWidth)),
            bottom: PreferredSize(
// 46.0为TabBar的高度，也就是tabs.dart中的_kTabHeight值，因为flutter不支持反射所以暂时没法通过代码获取
//                preferredSize: Size(double.infinity, 46.0),
              preferredSize: Size(double.infinity, screenWidth / 8),
              child: MyTaskActionBar(screenWidth, screenHeight),
            ),
          ),
        ),
      ];
    }

    var tabBarView = TabBarView(children: [
      SafeArea(
          top: false,
          bottom: false,
          child: Builder(builder: (BuildContext context) {
            return CustomScrollView(
                /*key: PageStorageKey<_Page>(page), */ slivers: [
                  SliverOverlapInjector(
                      handle: NestedScrollView.sliverOverlapAbsorberHandleFor(
                          context)),
                  SliverPadding(
                    padding:
                        EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                    sliver: SliverList(
                        delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                        return Padding(
                          padding: EdgeInsets.symmetric(vertical: 0.0),
                          child: MyTaskView(screenWidth, () {
                            return MyGlobalData.data.selectedDate;
                          }),
                        );
                      },
                      childCount: 1,
                    )),
                  ),
                ]);
          })),
    ]);

    return DefaultTabController(
        length: 1,
        child: Scaffold(
            body: NestedScrollView(
          headerSliverBuilder: headerSliverBuilder,
          body: tabBarView,
        )));
  }
}

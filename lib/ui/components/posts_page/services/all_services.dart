import 'package:flutter/material.dart';
import 'package:jobfuse/ui/components/posts_page/services/tabs/all_services.dart';
import 'package:jobfuse/ui/components/posts_page/services/tabs/interests_tab.dart';

class AllServices extends StatefulWidget {
  const AllServices({Key? key}) : super(key: key);

  @override
  State<AllServices> createState() => _AllServicesState();
}

class _AllServicesState extends State<AllServices> with TickerProviderStateMixin{



  @override
  Widget build(BuildContext context) {
    TabController _tabController = TabController(length: 2, vsync: this);
    return Scaffold(

      appBar: AppBar(

        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(
              text: 'Category',
            ),
            Tab(
              text: 'Interests',
            ),
          ],
        ),
        ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Content of Tab 1
          AllServicesOffered(),
          // Content of Tab 2
          MyInterests()
        ],
      ),
      );





  }
}

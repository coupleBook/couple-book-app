import 'package:couple_book/core/theme/colors.gen.dart';
import 'package:couple_book/presentation/pages/timeline/viewmodels/timeline_view_model.dart';
import 'package:couple_book/presentation/pages/timeline/widgets/anniversary_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TimelineView extends StatefulWidget {
  const TimelineView({super.key});

  @override
  State<TimelineView> createState() => _TimelineViewState();
}

class _TimelineViewState extends State<TimelineView> with TickerProviderStateMixin {
  late TimelineViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = TimelineViewModel(this);
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _viewModel,
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('타임라인'),
            bottom: TabBar(
              controller: _viewModel.tabController,
              tabs: const [
                Tab(text: '기념일'),
                Tab(text: '일정'),
              ],
            ),
          ),
          body: TabBarView(
            controller: _viewModel.tabController,
            children: const [
              AnniversaryList(),
              Center(child: Text('일정 탭')),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: _viewModel.onAddAnniversary,
            child: const Icon(Icons.add),
          ),
        ),
      ),
    );
  }
} 
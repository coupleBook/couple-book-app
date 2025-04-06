import 'package:couple_book/core/theme/colors.gen.dart';
import 'package:couple_book/core/theme/text_style.dart';
import 'package:couple_book/presentation/pages/timeline/models/anniversary_item.dart';
import 'package:couple_book/presentation/pages/timeline/viewmodels/timeline_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TimelineView extends StatefulWidget {
  const TimelineView({super.key});

  @override
  State<TimelineView> createState() => _TimelineViewState();
}

class _TimelineViewState extends State<TimelineView> with TickerProviderStateMixin {
  late TabController _tabController;
  late TimelineViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_handleTabChange);
    _viewModel = TimelineViewModel();
  }

  void _handleTabChange() {
    if (_tabController.indexIsChanging) return;
    _viewModel.updateTabIndex(_tabController.index);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _viewModel,
      child: Scaffold(
        backgroundColor: const Color(0xFFF6F6D8),
        body: Column(
          children: [
            _buildTabBar(),
            Expanded(
              child: Consumer<TimelineViewModel>(
                builder: (context, vm, child) {
                  return TabBarView(
                    controller: _tabController,
                    children: [
                      _buildAnniversaryList(
                        vm.state.anniversaries,
                        vm.scrollController0,
                        highlightCondition: (item) => item.isToday,
                      ),
                      _buildAnniversaryList(
                        vm.state.anniversaries,
                        vm.scrollController1,
                        highlightCondition: (item) => item.label == '사귄 날',
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          backgroundColor: Colors.orange,
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  Widget _buildTabBar() {
    return Theme(
      data: Theme.of(context).copyWith(
        splashFactory: NoSplash.splashFactory,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        hoverColor: Colors.transparent,
        tabBarTheme: TabBarTheme(
          overlayColor: WidgetStateProperty.resolveWith<Color?>((states) => states.contains(WidgetState.pressed) ? Colors.transparent : null),
        ),
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          color: Colors.black,
          borderRadius: _tabController.index == 0
              ? const BorderRadius.only(topRight: Radius.circular(30.0))
              : const BorderRadius.only(topLeft: Radius.circular(30.0)),
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        labelColor: Colors.white,
        unselectedLabelColor: Colors.grey,
        labelStyle: const TextStyle(fontWeight: FontWeight.bold),
        tabs: [
          _buildTabText('전체보기', 0),
          _buildTabText('첫날보기', 1),
        ],
      ),
    );
  }

  Widget _buildTabText(String title, int index) {
    return SizedBox(
      width: double.infinity,
      height: 36,
      child: Center(
        child: Text(
          title,
          style: TextStyle(
            color: _tabController.index == index ? ColorName.pointBtnBg : ColorName.defaultGray,
          ),
        ),
      ),
    );
  }

  Widget _buildAnniversaryList(
    List<AnniversaryItem> items,
    ScrollController controller, {
    required bool Function(AnniversaryItem) highlightCondition,
  }) {
    return ListView.builder(
      controller: controller,
      itemCount: items.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) return _buildListHeader();
        final item = items[index - 1];
        final isHighlighted = highlightCondition(item);

        final labelStyle = TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
          color: isHighlighted ? Colors.orange : Colors.black,
        );
        final dateStyle = TextStyle(
          color: isHighlighted ? Colors.orange : Colors.grey,
          fontSize: 14,
        );
        final dDayStyle = TextStyle(
          color: isHighlighted ? Colors.orange : Colors.orange,
          fontSize: 16,
        );

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(0.0),
              child: Column(
                children: [
                  SizedBox(
                    height: 46.0,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Checkbox(value: false, onChanged: (_) {}),
                        Expanded(
                          flex: 7,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(item.label, style: labelStyle),
                              Text(item.date, style: dateStyle),
                            ],
                          ),
                        ),
                        Container(
                          width: 1.0,
                          color: ColorName.defaultGray,
                          margin: const EdgeInsets.symmetric(horizontal: 12.0),
                        ),
                        Expanded(
                          flex: 3,
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              item.dDay,
                              style: dDayStyle,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 1.0, child: Container(color: ColorName.defaultGray)),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildListHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Column(
        children: [
          SizedBox(height: 1.8, child: Container(color: ColorName.defaultGray)),
          SizedBox(
            height: 46.0,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(width: 15),
                Expanded(
                  flex: 7,
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      '기념일',
                      style: TypoStyle.notoSansR19_1_4.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: ColorName.defaultGray,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 15),
                Container(width: 1.0, color: ColorName.defaultGray),
                Expanded(
                  flex: 3,
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      '디데이',
                      style: TypoStyle.notoSansR19_1_4.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: ColorName.defaultGray,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 1.0, child: Container(color: ColorName.defaultGray)),
        ],
      ),
    );
  }
}

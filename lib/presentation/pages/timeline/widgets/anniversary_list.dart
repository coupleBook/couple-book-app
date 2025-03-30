import 'package:couple_book/core/theme/colors.gen.dart';
import 'package:couple_book/core/theme/text_style.dart';
import 'package:couple_book/presentation/pages/timeline/models/timeline_state.dart';
import 'package:couple_book/presentation/pages/timeline/viewmodels/timeline_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AnniversaryList extends StatelessWidget {
  const AnniversaryList({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<TimelineViewModel>(
      builder: (context, viewModel, child) {
        return ListView.builder(
          itemCount: viewModel.state.anniversaries.length + 1,
          itemBuilder: (context, index) {
            if (index == 0) {
              return _buildHeader();
            } else {
              final anniversary = viewModel.state.anniversaries[index - 1];
              return _buildAnniversaryItem(context, viewModel, anniversary);
            }
          },
        );
      },
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 0.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 1.8,
            child: Container(
              color: ColorName.defaultGray,
            ),
          ),
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
                    child: AppText(
                      '기념일',
                      style: TypoStyle.notoSansR19_1_4.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                      color: ColorName.defaultGray,
                    ),
                  ),
                ),
                const SizedBox(width: 15),
                Container(
                  width: 1.0,
                  color: ColorName.defaultGray,
                ),
                Expanded(
                  flex: 3,
                  child: Align(
                    alignment: Alignment.center,
                    child: AppText(
                      '디데이',
                      style: TypoStyle.notoSansR19_1_4.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                      color: ColorName.defaultGray,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 1.0,
            child: Container(
              color: ColorName.defaultGray,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnniversaryItem(
    BuildContext context,
    TimelineViewModel viewModel,
    AnniversaryItem anniversary,
  ) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 0.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 46.0,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Checkbox(
                      value: viewModel.isChecked(anniversary.id),
                      onChanged: (bool? value) {
                        viewModel.toggleCheckbox(anniversary.id);
                      },
                    ),
                    Expanded(
                      flex: 7,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            anniversary.label,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            anniversary.date,
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                            ),
                          ),
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
                          anniversary.dDay,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 1.0,
                child: Container(
                  color: ColorName.defaultGray,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
} 
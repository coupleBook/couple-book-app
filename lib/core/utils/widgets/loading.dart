import 'package:flutter/material.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Image.asset(
        'assets/contents/loading.gif',
        width: 100,
        height: 100,
      ),
    );
  }
}

void showLoadingDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false, // 다른 곳을 누르면 닫히지 않도록
    builder: (BuildContext context) {
      return const Dialog(
        backgroundColor: Colors.transparent,
        child: LoadingWidget(),
      );
    },
  );
}

void hideLoadingDialog(BuildContext context) {
  Navigator.of(context).pop(); // 로딩 창 닫기
}

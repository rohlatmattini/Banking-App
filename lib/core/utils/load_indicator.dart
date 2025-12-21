// // lib/view/widget/complaint/load_more_indicator.dart
//
// import 'package:flutter/material.dart';
//
// import '../constant/app_color.dart';
//
// class LoadMoreIndicator extends StatelessWidget {
//   final bool isLoading;
//
//   const LoadMoreIndicator({
//     Key? key,
//     required this.isLoading,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(16.0),
//       child: Center(
//         child: isLoading
//             ? CircularProgressIndicator(color: AppColor.darkgreen)
//             : const SizedBox.shrink(),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';

class AppRefreshIndicator extends StatelessWidget {
  final Future<void> Function() onRefresh;
  final Widget child;

  const AppRefreshIndicator({
    Key? key,
    required this.onRefresh,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      color: Theme.of(context).primaryColor,
      child: child,
    );
  }
}

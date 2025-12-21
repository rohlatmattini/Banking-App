// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
//
// import '../constant/app_color.dart';
//
// class CustomScaffold extends StatelessWidget {
//   final Widget? child;
//   final String? backgroundImage;
//   final AppBar? appBar;
//   final Widget? drawer;
//   final Color? backgroundColor;
//
//   const CustomScaffold({
//     super.key,
//     this.child,
//     this.backgroundImage,
//     this.appBar,
//     this.drawer,
//     this.backgroundColor,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     final bool isDark = Theme.of(context).brightness == Brightness.dark;
//
//     return Scaffold(
//       // backgroundColor: backgroundColor ?? (isDark ? AppColor.darkBackground : AppColor.white),
//       appBar: appBar,
//       drawer: drawer,
//       extendBodyBehindAppBar: true,
//       body: Stack(
//         children: [
//           if (backgroundImage != null)
//             SizedBox(
//               width: double.infinity,
//               height: 250.h,
//               child: Image.asset(
//                 backgroundImage!,
//                 fit: BoxFit.cover,
//                 color: isDark ? Colors.black54 : null,
//                 colorBlendMode: isDark ? BlendMode.darken : null,
//               ),
//             )
//           else
//             Container(
//               // color: isDark ? AppColor.darkSubtitle : AppColor.grey,
//               height: 200.h,
//               width: double.infinity,
//             ),
//
//           SafeArea(child: child ?? const SizedBox()),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';

class CustomScaffold extends StatelessWidget {
  final Widget? child;
  final String? backgroundImage;
  final AppBar? appBar;
  final Widget? drawer;
  final Color? backgroundColor;
  final Widget? body; // أضف هذا
  final Widget? bottomNavigationBar; // أضف هذا
  final bool? resizeToAvoidBottomInset; // أضف هذا
  final Widget? floatingActionButton; // أضف هذا
  final FloatingActionButtonLocation? floatingActionButtonLocation; // أضف هذا

  const CustomScaffold({
    super.key,
    this.child,
    this.backgroundImage,
    this.appBar,
    this.drawer,
    this.backgroundColor,
    this.body, // أضف هذا
    this.bottomNavigationBar, // أضف هذا
    this.resizeToAvoidBottomInset, // أضف هذا
    this.floatingActionButton, // أضف هذا
    this.floatingActionButtonLocation, // أضف هذا
  });

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: appBar,
      drawer: drawer,
      body: body ?? (backgroundImage != null
          ? Stack(
        children: [
          SizedBox(
            width: double.infinity,
            height: 250,
            child: Image.asset(
              backgroundImage!,
              fit: BoxFit.cover,
              color: isDark ? Colors.black54 : null,
              colorBlendMode: isDark ? BlendMode.darken : null,
            ),
          ),
          SafeArea(child: child ?? const SizedBox()),
        ],
      )
          : child),
      bottomNavigationBar: bottomNavigationBar,
      resizeToAvoidBottomInset: resizeToAvoidBottomInset ?? true,
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: floatingActionButtonLocation,
    );
  }
}
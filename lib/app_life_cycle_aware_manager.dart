// import 'package:flutter/material.dart';
//
// class AppLifecycleAwareManager extends StatefulWidget {
//   final Widget child;
//   final VoidCallback? onResume;
//   final bool forceRebuild;
//
//   const AppLifecycleAwareManager({
//     Key? key,
//     required this.child,
//     this.onResume,
//     this.forceRebuild = true,
//   }) : super(key: key);
//
//   @override
//   State<AppLifecycleAwareManager> createState() => _AppLifecycleAwareManagerState();
// }
//
// class _AppLifecycleAwareManagerState extends State<AppLifecycleAwareManager> with WidgetsBindingObserver {
//   Key _rebuildKey = UniqueKey();
//
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addObserver(this);
//   }
//
//   @override
//   void dispose() {
//     WidgetsBinding.instance.removeObserver(this);
//     super.dispose();
//   }
//
//   @override
//   void didChangeAppLifecycleState(AppLifecycleState state) {
//     super.didChangeAppLifecycleState(state);
//     if (state == AppLifecycleState.resumed) {
//       if (widget.onResume != null) {
//         widget.onResume!();
//       }
//       if (mounted && widget.forceRebuild) {
//         setState(() {
//           _rebuildKey = UniqueKey();
//         });
//       }
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return KeyedSubtree(
//       key: _rebuildKey,
//       child: widget.child,
//     );
//   }
// }
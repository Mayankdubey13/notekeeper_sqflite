import 'package:flutter/material.dart';

class CustomToast
{
  String? message;
  CustomToast({required BuildContext context, required String message, required IconData iconData, required Color iconColor}) {
      final overlay = Overlay.of(context);
      final overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        bottom: 120,
        left: MediaQuery.of(context).size.width * 0.35,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.grey.shade900, width: 1)
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.notifications_on_rounded, color: Colors.blue,),
              const SizedBox(width: 8),
              Text(
                message,
                style: const TextStyle(color: Colors.black, fontSize: 11, decoration: TextDecoration.none),
              ),
            ],
          ),
        ),
      ),
    );
    overlay.insert(overlayEntry);

    Future.delayed(const Duration(seconds: 2), () {
      overlayEntry.remove();
    });
  }
}
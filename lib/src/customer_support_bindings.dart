import 'package:get/get.dart';

import 'customer_support_controller.dart';

class InAppWebViewBindings extends Bindings {
  final String url;
  final Function(String)? onUrlChanged;
  final Function(String)? onPageFinished;
  final Function(String, int)? onError;

  InAppWebViewBindings({
    required this.url,
    this.onUrlChanged,
    this.onPageFinished,
    this.onError,
  });

  @override
  void dependencies() {
    Get.put(
      CustomerSupportController(
        url: url,
        onPageFinished: onPageFinished,
        onError: onError,
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'customer_support_bindings.dart';
import 'customer_support_screen.dart';

class CustomerSupportPage {
  final String name;
  final String url;
  final String title;
  final bool showAppBar;
  final Widget? customAppBar;
  final Function(String)? onUrlChanged;
  final Function(String)? onPageFinished;
  final Function(String, int)? onError;

  CustomerSupportPage({
    required this.name,
    required this.url,
    required this.title,
    this.showAppBar = true,
    this.customAppBar,
    this.onUrlChanged,
    this.onPageFinished,
    this.onError,
  });

  GetPage getPage() {
    return GetPage(
      name: name,
      page:
          () => CustomerSupportScreen(
            url: url,
            title: title,
            showAppBar: showAppBar,
            customAppBar: customAppBar,
          ),
      binding: InAppWebViewBindings(
        url: url,
        onUrlChanged: onUrlChanged,
        onPageFinished: onPageFinished,
        onError: onError,
      ),
    );
  }
}

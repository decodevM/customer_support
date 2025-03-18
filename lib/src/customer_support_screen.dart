import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';

import 'customer_support_controller.dart';

class CustomerSupportScreen extends GetView<CustomerSupportController> {
  final String url;
  final String title;
  final bool showAppBar;
  final Widget? customAppBar;

  const CustomerSupportScreen({
    super.key,
    required this.url,
    required this.title,
    this.showAppBar = true,
    this.customAppBar,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          showAppBar
              ? (customAppBar as PreferredSizeWidget?) ??
                  AppBar(title: Text(title))
              : null,
      body: SafeArea(
        child: Stack(children: [_buildWebView(), _buildProgressBar()]),
      ),
    );
  }

  Widget _buildWebView() {
    return InAppWebView(
      key: controller.webViewKey,
      initialUrlRequest: URLRequest(url: WebUri(url)),
      initialUserScripts: UnmodifiableListView<UserScript>([]),
      initialSettings: controller.settings,
      pullToRefreshController: controller.pullToRefreshController,
      onWebViewCreated: controller.onWebViewCreated,
      onLoadStart: controller.onLoadStart,
      onLoadStop: controller.onLoadStop,
      onProgressChanged: controller.onProgressChanged,
      onReceivedError: controller.onReceivedError,
      onPermissionRequest: controller.handlePermissionRequest,
      shouldOverrideUrlLoading: controller.handleUrlLoading,
      onConsoleMessage: (controller, consoleMessage) {},
    );
  }

  Widget _buildProgressBar() {
    return Obx(
      () =>
          controller.progress.value < 1
              ? LinearProgressIndicator(value: controller.progress.value)
              : const SizedBox.shrink(),
    );
  }
}

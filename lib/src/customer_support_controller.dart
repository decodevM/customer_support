import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';

class CustomerSupportController extends GetxController {
  final String url;
  final Function(String)? onPageFinished;
  final Function(String, int)? onError;

  CustomerSupportController({
    required this.url,
    this.onPageFinished,
    this.onError,
  });

  final isLoading = true.obs;
  final progress = 0.0.obs;

  InAppWebViewController? webViewController;
  PullToRefreshController? pullToRefreshController;
  final GlobalKey webViewKey = GlobalKey();

  late final InAppWebViewSettings settings;

  @override
  void onInit() {
    super.onInit();
    _initializeSettings();
    _initializePullToRefresh();
  }

  void _initializeSettings() {
    settings = InAppWebViewSettings(
      isInspectable: kDebugMode,
      mediaPlaybackRequiresUserGesture: false,
      allowsInlineMediaPlayback: true,
      iframeAllow: "camera; microphone; camera *; display-capture",
      allowFileAccess: true,
      allowContentAccess: true,
      iframeAllowFullscreen: true,
      supportMultipleWindows: true,
      useShouldOverrideUrlLoading: true,
      useOnDownloadStart: true,
      allowFileAccessFromFileURLs: true,
      allowUniversalAccessFromFileURLs: true,
    );
  }

  void _initializePullToRefresh() {
    if (!GetPlatform.isWeb && (GetPlatform.isIOS || GetPlatform.isAndroid)) {
      pullToRefreshController = PullToRefreshController(
        settings: PullToRefreshSettings(color: Get.theme.primaryColor),
        onRefresh: _handleRefresh,
      );
    }
  }

  Future<void> _handleRefresh() async {
    if (GetPlatform.isAndroid) {
      await webViewController?.reload();
    } else if (GetPlatform.isIOS) {
      final currentUrl = await webViewController?.getUrl();
      await webViewController?.loadUrl(urlRequest: URLRequest(url: currentUrl));
    }
  }

  Future<NavigationActionPolicy> handleUrlLoading(
    InAppWebViewController controller,
    NavigationAction navigationAction,
  ) async {
    return NavigationActionPolicy.ALLOW;
  }

  void onWebViewCreated(InAppWebViewController controller) {
    webViewController = controller;
  }

  void onLoadStart(InAppWebViewController controller, WebUri? url) {
    isLoading.value = true;
  }

  void onLoadStop(InAppWebViewController controller, WebUri? url) {
    isLoading.value = false;
    pullToRefreshController?.endRefreshing();
    if (url != null && onPageFinished != null) {
      onPageFinished!(url.toString());
    }
  }

  void onProgressChanged(InAppWebViewController controller, int progress) {
    this.progress.value = progress / 100;
    if (progress == 100) {
      pullToRefreshController?.endRefreshing();
    }
  }

  void onReceivedError(
    InAppWebViewController controller,
    WebResourceRequest request,
    WebResourceError error,
  ) {
    pullToRefreshController?.endRefreshing();
  }

  Future<PermissionResponse> handlePermissionRequest(
    InAppWebViewController controller,
    PermissionRequest request,
  ) async {
    // Log the requested permissions in debug mode
    if (kDebugMode) {
      print('Permission requested: ${request.resources}');
    }

    // Explicitly grant camera and file system permissions
    if (request.resources.contains(PermissionResourceType.CAMERA)) {
      return PermissionResponse(
        resources: request.resources,
        action: PermissionResponseAction.GRANT,
      );
    }

    return PermissionResponse(
      resources: request.resources,
      action: PermissionResponseAction.GRANT,
    );
  }

  @override
  void onClose() {
    webViewController?.dispose();
    super.onClose();
  }
}

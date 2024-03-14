import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:stackfood_multivendor_driver/feature/cash_in_hand/widgets/fund_payment_dialog_widget.dart';
import 'package:stackfood_multivendor_driver/helper/route_helper.dart';
import 'package:stackfood_multivendor_driver/util/app_constants.dart';
import 'package:stackfood_multivendor_driver/util/dimensions.dart';
import 'package:stackfood_multivendor_driver/common/widgets/custom_app_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';

class PaymentScreen extends StatefulWidget {
  final String? redirectUrl;
  const PaymentScreen({super.key, this.redirectUrl});

  @override
  PaymentScreenState createState() => PaymentScreenState();
}

class PaymentScreenState extends State<PaymentScreen> {

  late String selectedUrl;
  double value = 0.0;
  final bool _isLoading = true;
  PullToRefreshController? pullToRefreshController;
  late MyInAppBrowser browser;
  double? maxCodOrderAmount;

  @override
  void initState() {
    super.initState();
    selectedUrl = widget.redirectUrl!;
    _initData();
  }

  void _initData() async {

    browser = MyInAppBrowser(redirectUrl: widget.redirectUrl);

    await InAppWebViewController.setWebContentsDebuggingEnabled(true);

    bool swAvailable = await WebViewFeature.isFeatureSupported(WebViewFeature.SERVICE_WORKER_BASIC_USAGE);
    bool swInterceptAvailable = await WebViewFeature.isFeatureSupported(WebViewFeature.SERVICE_WORKER_SHOULD_INTERCEPT_REQUEST);

    if (swAvailable && swInterceptAvailable) {
      ServiceWorkerController serviceWorkerController = ServiceWorkerController.instance();
      await serviceWorkerController.setServiceWorkerClient(ServiceWorkerClient(
        shouldInterceptRequest: (request) async {
          if (kDebugMode) {
            print(request);
          }
          return null;
        },
      ));
    }
    debugPrint('------$browser');
    await browser.openUrlRequest(
      urlRequest: URLRequest(url: WebUri(selectedUrl)),
      settings: InAppBrowserClassSettings(
        webViewSettings: InAppWebViewSettings(useShouldOverrideUrlLoading: true, useOnLoadResource: true),
        browserSettings: InAppBrowserSettings(hideUrlBar: true, hideToolbarTop: GetPlatform.isAndroid),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        _exitApp().then((value) => value!);
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        appBar: CustomAppBarWidget(title: 'payment'.tr, onBackPressed: () => _exitApp()),
        body: Center(
          child: SizedBox(
            width: Dimensions.webMaxWidth,
            child: Stack(children: [

              _isLoading ? Center(
                child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor)),
              ) : const SizedBox.shrink(),

            ]),
          ),
        ),
      ),
    );
  }

  Future<bool?> _exitApp() async {
    return Get.dialog(const FundPaymentDialogWidget());
  }

}

class MyInAppBrowser extends InAppBrowser {
  final String? redirectUrl;
  MyInAppBrowser({super.windowId, super.initialUserScripts, this.redirectUrl});

  bool _canRedirect = true;

  @override
  Future onBrowserCreated() async {
    if (kDebugMode) {
      print("\n\nBrowser Created!\n\n");
    }
  }

  @override
  Future onLoadStart(url) async {
    if (kDebugMode) {
      print("\n\nStarted: $url\n\n");
    }
    _redirect(url.toString());
  }

  @override
  Future onLoadStop(url) async {
    pullToRefreshController?.endRefreshing();
    if (kDebugMode) {
      print("\n\nStopped: $url\n\n");
    }
    _redirect(url.toString());
  }

  @override
  void onLoadError(url, code, message) {
    pullToRefreshController?.endRefreshing();
    if (kDebugMode) {
      print("Can't load [$url] Error: $message");
    }
  }

  @override
  void onProgressChanged(progress) {
    if (progress == 100) {
      pullToRefreshController?.endRefreshing();
    }
    if (kDebugMode) {
      print("Progress: $progress");
    }
  }

  @override
  void onExit() {
    if(_canRedirect) {
    }
    if (kDebugMode) {
      print("\n\nBrowser closed!\n\n");
    }
  }

  @override
  Future<NavigationActionPolicy> shouldOverrideUrlLoading(navigationAction) async {
    if (kDebugMode) {
      print("\n\nOverride ${navigationAction.request.url}\n\n");
    }
    return NavigationActionPolicy.ALLOW;
  }

  @override
  void onLoadResource(resource) {
    if (kDebugMode) {
      print("Started at: ${resource.startTime}ms ---> duration: ${resource.duration}ms ${resource.url ?? ''}");
    }
  }

  @override
  void onConsoleMessage(consoleMessage) {
    if (kDebugMode) {
      print("""
      console output:
      message: ${consoleMessage.message}
      messageLevel: ${consoleMessage.messageLevel.toValue()}
    """);
    }
  }

  void _redirect(String url) {
    if (kDebugMode) {
      print('---url---$url');
    }
    if(_canRedirect) {
      bool isSuccess = url.contains('${AppConstants.baseUrl}/success?flag=success');
      bool isFailed = url.contains('${AppConstants.baseUrl}/success?flag=fail');
      bool isCancel = url.contains('${AppConstants.baseUrl}/success?flag=cancel');
      if (isSuccess || isFailed || isCancel) {
        _canRedirect = false;
        close();
      }

      if(isSuccess || isFailed || isCancel) {
        if(Get.currentRoute.contains(RouteHelper.payment)) {
          Get.back();
        }
        Get.back();
        Get.toNamed(RouteHelper.getSuccessRoute(isSuccess ? 'success' : isFailed ? 'fail' : 'cancel'));
      }
    }
  }

}
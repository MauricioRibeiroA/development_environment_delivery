abstract class CashInHandServiceInterface {
  Future<dynamic> makeCollectCashPayment(double amount, String paymentGatewayName);
  Future<dynamic> makeWalletAdjustment();
  Future<dynamic> getWalletPaymentList();
}
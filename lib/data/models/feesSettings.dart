class FeesSettings {
  FeesSettings({
    required this.razorpayStatus,
    required this.razorpaySecretKey,
    required this.razorpayApiKey,
    required this.stripeStatus,
    required this.stripePublishableKey,
    required this.stripeWebhookSecret,
    required this.stripeSecretKey,
    required this.currencyCode,
    required this.currencySymbol,
    required this.feesDueCharges,
    required this.feesDueDate,
  });

  late final String razorpayStatus;
  late final String razorpaySecretKey;
  late final String? razorpayApiKey;

  late final String stripeStatus;
  late final String stripePublishableKey;
  late final String stripeWebhookSecret;
  late final String stripeSecretKey;

  late final String currencyCode;
  late final String currencySymbol;
  late final String feesDueCharges;
  late final String feesDueDate;

  FeesSettings.fromJson(Map<String, dynamic> json) {
    currencyCode = json['currency_code'] ?? "";
    currencySymbol = json['currency_symbol'] ?? "";
    feesDueCharges = json['fees_due_charges'] ?? "";
    feesDueDate =
        json['fees_due_date'] == null ? "" : json['fees_due_date'].toString();
    razorpayStatus = json['razorpay_status'] ?? "0";
    stripeStatus = json['stripe_status'] ?? "0";
    razorpaySecretKey = json['razorpay_secret_key'] ?? "";
    razorpayApiKey = json['razorpay_api_key'] ?? "";
    stripePublishableKey = json['stripe_publishable_key'] ?? "";
    stripeWebhookSecret = json['stripe_webhook_secret'] ?? "";
    stripeSecretKey = json['stripe_secret_key'] ?? "";
  }
}

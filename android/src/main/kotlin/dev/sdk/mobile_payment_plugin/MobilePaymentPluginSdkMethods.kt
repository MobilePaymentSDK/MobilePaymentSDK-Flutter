package dev.sdk.mobile_payment_plugin

import android.widget.Toast
import com.edesign.paymentsdk.Inquiry.InquiryRequest
import com.edesign.paymentsdk.Inquiry.InquiryResponse
import com.edesign.paymentsdk.Refund.RefundRequest
import com.edesign.paymentsdk.Refund.RefundResponse
import com.edesign.paymentsdk.version2.Checkout
import com.edesign.paymentsdk.version2.OpenPaymentRequest
import com.edesign.paymentsdk.version2.PaymentMethod
import com.edesign.paymentsdk.version2.PaymentResultListener
import com.edesign.paymentsdk.version2.completion.CompletionCallback
import com.edesign.paymentsdk.version2.completion.CompletionRequest
import com.edesign.paymentsdk.version2.completion.CompletionResponse
import com.edesign.paymentsdk.version2.completion.SmartRouteCompletionService
import com.edesign.paymentsdk.version2.inquiry.InquiryCallback
import com.edesign.paymentsdk.version2.inquiry.SmartRouteInquiryService
import com.edesign.paymentsdk.version2.refund.RefundCallback
import com.edesign.paymentsdk.version2.refund.SmartRouteRefundService
import com.google.gson.Gson
import io.flutter.embedding.android.FlutterActivity
import io.flutter.plugin.common.MethodChannel

open class MobilePaymentPluginSdkMethods(
    private val activity: FlutterActivity,
    private var channel: MethodChannel
) :
    PaymentResultListener {

    private fun getResult(result: Map<String, Any>) {
        channel.invokeMethod("getResult", result)
    }

    private fun onDeleteCard(token: String, deleted: Boolean) {
        val result = mapOf("token" to token, "deleted" to deleted)
        channel.invokeMethod("onDeleteCard", result)
    }


    fun paymentMethod(params: Map<String, Any>) {
        val request = OpenPaymentRequest()
        request.paymentType = params["paymentType"] as String
        //PaymentType.PREAUTH.name
        request.add("AuthenticationToken", params["authenticationToken"] as String)
        request.add("TransactionID", params["transactionId"] as String)
        request.add("MerchantID", params["merchantID"] as String)
        request.add("ClientIPaddress", params["clientIPaddress"] as String)
        request.add("Amount", params["amount"] as String)
        request.add("Currency", params["currency"] as String)
        request.add("PaymentDescription", params["paymentDescription"] as String)
        request.add("AgreementID", "")
        request.add("AgreementType", "")
        request.add("Language", params["langCode"] as String)
        request.add("ThreeDSEnable", params["isThreeDSSecure"] as Boolean)
        request.add("TokenizeCard", params["shouldTokenizeCard"] as Boolean)
        request.add("CardScanningEnable", params["isCardScanEnable"] as Boolean)
        request.add("SaveCard", params["isSaveCardEnable"] as Boolean)
        request.add("PaymentMethod", arrayListOf<String>(PaymentMethod.Cards.name))
        request.add(
            "CardType",
            params["cardsType"] as List<String>,
        )
        //optional param
        //request.addOptional("ItemID", params["itemId"] as String)
        //request.addOptional("Quantity", params["quantity"] as String)
        request.addOptional("Version", params["version"] as String)
        request.addOptional("FrameworkInfo", params["frameworkInfo"] as String)
        val tokenList = params["tokens"] as List<String>
        request.add("Tokens", tokenList.joinToString(","))
        val checkout = Checkout(activity, this)
        checkout.open(request)
    }

    override fun onDeleteCardResponse(token: String, deleted: Boolean) {
        onDeleteCard(token, deleted)
    }

    override fun onPaymentFailed(a: MutableMap<String, String>) {
        val result = mapOf("status" to "failed", "data" to a)
        getResult(result)
    }

    override fun onResponse(a: MutableMap<String, String>) {
        val result = mapOf("status" to "success", "data" to a)
        getResult(result)
    }


    fun refund(params: Map<String, Any>) {
        val request = RefundRequest()
        request.setPaymentAuthenticationToken(
            "AuthenticationToken",
            params["authenticationToken"] as String
        )
        request.add("MessageID", "5")
        request.add("MerchantID", params["merchantID"] as String)
        request.add("TransactionID", params["transactionID"] as String)
        request.add("CurrencyISOCode", params["currencyISOCode"] as String)
        request.add("Amount", params["amount"] as String)
        request.add(
            "OriginalTransactionID", params["originalTransactionID"] as String
        )
        request.add("Version", "1.0")
        val paymentService = SmartRouteRefundService(activity)
        paymentService.process(
            request,
            object : RefundCallback {
                override fun onResponse(response: RefundResponse) {
                    val result = mapOf("data" to response.response)
                    getResult(result)
                }
            },
        )
    }

    fun completion(params: Map<String, Any>) {
        val request = CompletionRequest()
        request.setPaymentAuthenticationToken(
            "AuthenticationToken",
            params["authenticationToken"] as String
        )
        request.add("MessageID", "5")
        request.add("MerchantID", params["merchantID"] as String)
        request.add("TransactionID", params["transactionID"] as String)
        request.add("CurrencyISOCode", params["currencyISOCode"] as String)
        request.add("Amount", params["amount"] as String)
        request.add(
            "OriginalTransactionID", params["originalTransactionID"] as String
        )
        val paymentService = SmartRouteCompletionService(activity)
        paymentService.process(
            request,
            object : CompletionCallback {
                override fun onResponse(response: CompletionResponse) {
                    val result = mapOf("data" to response.response)
                    getResult(result)

                }

            },
        )
    }

    fun inquiry(params: Map<String, Any>) {
        val request = InquiryRequest()
        request.setPaymentAuthenticationToken(
            "AuthenticationToken",
            params["authenticationToken"] as String
        )
        request.add("MessageID", "2")
        request.add("MerchantID", params["merchantID"] as String)
        request.add(
            "OriginalTransactionID", params["originalTransactionID"] as String
        )
        request.add("Version", "1.0")
        val paymentService = SmartRouteInquiryService(activity)
        paymentService.process(
            request,
            object : InquiryCallback {
                override fun onResponse(response: InquiryResponse) {
                    val result = mapOf("data" to response.response)
                    getResult(result)
                }
            },
        )
    }
}
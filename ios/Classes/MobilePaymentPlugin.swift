import Flutter
import UIKit
import MobilePaymentSDK

public class MobilePaymentPlugin: NSObject, FlutterPlugin {
    private var result: FlutterResult?
    public static let shared = MobilePaymentPlugin()
    
    override private init() {}
    public static func register(with registrar: FlutterPluginRegistrar) {
        let instance = MobilePaymentPlugin()
        let channel = FlutterMethodChannel(name: "samples.flutter.dev/paymentIOS", binaryMessenger: registrar.messenger())
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        MobilePaymentPlugin.shared.result = result
        switch call.method {
        case "initializeSDK":
            guard let args = call.arguments as? [String : Any] else {
                let object = FlutterError(code: "5000", message: "Arguments is not valid", details: nil)
                result(object)
                return
            }
            handleInitializeSDK(args: args)
        case "openPaymentPage":
            if let viewController = UIApplication.shared.windows.first?.rootViewController as? UIViewController {
                guard let args = call.arguments as? [String : Any] else {
                    let object = FlutterError(code: "5000", message: "Arguments is not valid", details: nil)
                    result(object)
                    return
                }
                handleOpenPaymentPage(viewController: viewController, args: args, result: result)
            } else {
                let object = FlutterError(code: "5006", message: "View controller is not valid", details: nil)
                result(object)
            }
        case "getInquiry":
            guard let args = call.arguments as? [String : Any] else {return}
            guard let forTransactionId = args["originalTransactionID"] as? String
            else {
                result(FlutterError(code: "INVALID_ARGUMENTS", message: "Invalid payment data", details: nil))
                return
            }
            MobilePaymentSDK.shared.getInquiry(forTransactionId: forTransactionId)
        case "refund":
            guard let args = call.arguments as? [String : Any] else {return}
            guard let forOriginalTransactionId = args["originalTransactionID"] as? String,
                  let forTransactionId = args["transactionID"] as? String,
                  let forIsoCountry = args["currencyISOCode"] as? String,
                  let forAmount = args["amount"] as? String
            else {
                result(FlutterError(code: "INVALID_ARGUMENTS", message: "Invalid payment data", details: nil))
                return
            }
            self.result = result
            MobilePaymentSDK.shared.requestForPaymentRefund(
                forOriginalTransactionId: forOriginalTransactionId,
                forTransactionId: forTransactionId,
                forIsoCountry: forIsoCountry,
                forAmount: forAmount)
        case "completion":
            guard let args = call.arguments as? [String : Any] else {return}
            guard let forOriginalTransactionId = args["originalTransactionID"] as? String,
                  let forTransactionId = args["transactionID"] as? String,
                  let forIsoCountry = args["currencyISOCode"] as? String,
                  let forAmount = args["amount"] as? String
            else {
                result(FlutterError(code: "INVALID_ARGUMENTS", message: "Invalid payment data", details: nil))
                return
            }
            self.result = result
            MobilePaymentSDK.shared.requestForPaymentCompletion(
                forOriginalTransactionId: forOriginalTransactionId,
                forTransactionId: forTransactionId,
                forIsoCountry: forIsoCountry,
                forAmount: forAmount)
        default:
            result(FlutterMethodNotImplemented)
        }
    }

    func handleInitializeSDK(args: [String: Any]) {
        guard let merchantId = args["merchantId"] as? String,
              let secretKey = args["secretKey"] as? String,
              let appleMerchantId = args["appleMerchantId"] as? String
        else {
            result?(FlutterError(code: "INVALID_ARGUMENTS", message: "Invalid payment data", details: nil))
            return
        }
        
        try? MobilePaymentSDK.initializeSDK(
            withMerchantID: merchantId,
            secretKey: secretKey,
            delegate: MobilePaymentPlugin.shared,
            appleMerchantId: appleMerchantId
        )
    }
    func handleOpenPaymentPage(viewController: UIViewController, args: [String: Any], result: @escaping FlutterResult) {
        MobilePaymentPlugin.shared.result = result
        // Extract necessary data from Flutter method call arguments
        guard let amount = args["amount"] as? String,
              let currency = args["currency"] as? String,
              let transactionId = args["transactionId"] as? String,
              let paymentTitle = args["paymentTitle"] as? String,
              let paymentDescription = args["paymentDescription"] as? String,
              let itemId = args["itemId"] as? String,
              let quantity = args["quantity"] as? String,
              let is3DSAuth = args["isThreeDSSecure"] as? Bool,
              let shouldTokenizeCard = args["shouldTokenizeCard"] as? Bool,
              let isCardScanningEnabled = args["isCardScanEnable"] as? Bool,
              let paymentMethods = args["cardsType"] as? [Int],
              let tokensValues = args["tokens"] as? [String],
              let paymentTypeValue = args["paymentType"] as? Int,
              let langCode = args["langCode"] as? String,
              let agreementId = args["agreementId"] as? String,
              let agreementTypeValue = args["agreementType"] as? String
        else {
            result(FlutterError(code: "5004", message: "Invalid payment data", details: nil))
            return
        }
        var paymentMthds: [MobilePaymentSDKPaymentMethod] = []
        for item in paymentMethods {
            paymentMthds.append(MobilePaymentSDKPaymentMethod(rawValue: item).unsafelyUnwrapped)
        }
        var tokens: [String] = []
        for item in tokensValues {
            tokens.append(item)
        }
        guard let paymentType = MobilePaymentType(rawValue: paymentTypeValue) else {
            result(FlutterError(code: "5007", message: "PaymentType is not valid", details: nil))
            return
        }
        guard let lang = MobilePaymentSupportedLanguage(rawValue: langCode) else {
            result(FlutterError(code: "5006", message: "Language is not valid", details: nil))
            return
        }
        guard let agreementType = MobileAgreementType(rawValue: agreementTypeValue) else {
            result(FlutterError(code: "5005", message: "AgreementType is not valid", details: nil))
            return
        }
        MobilePaymentSDK.shared.showPaymentPage(
            fromViewController: viewController,
            amount: amount,
            currency: currency,
            tokens: tokens,
            paymentMethods: paymentMthds,
            transactionId: transactionId,
            paymentType: paymentType,
            is3DSAuth: is3DSAuth,
            shouldTokenizeCard: shouldTokenizeCard,
            isCardScanningEnabled: isCardScanningEnabled,
            language: lang,
            paymentDescription: paymentDescription,
            paymentTitle: paymentTitle,
            quantity: quantity,
            itemId: itemId,
            agreementId: agreementId,
            agreementType: agreementType
        )
    }
    
    
}

extension MobilePaymentPlugin: MobilePaymentSDKDelegate {
    public func onPaymentSuccess(withTransactionId transactionId: String, infoDictionary: [String: Any], tokenizedCard: String?, shouldStoreCard: Bool) {
        
        var newInfoDictionary: [String: Any] = [:]
        
        newInfoDictionary["tokenizedCard"] = tokenizedCard ?? ""
        newInfoDictionary["shouldStoreCard"] = shouldStoreCard
        newInfoDictionary["transactionId"] = transactionId
        newInfoDictionary["code"] = "200"
        
        for item in infoDictionary {
            newInfoDictionary[item.key] = item.value
        }
        MobilePaymentPlugin.shared.result?(newInfoDictionary)
    }
    
    public func onPaymentError(_ error: MobilePaymentError, transactionId: String) {
        var newInfoDictionary: [String: Any?] = [:]

        newInfoDictionary["transactionId"] = transactionId
        newInfoDictionary["code"] = error.code

        for item in error.userInfo {
            if let key = item.key as? String {
                newInfoDictionary[key] = item.value
            }
        }
        
        MobilePaymentPlugin.shared.result?(newInfoDictionary)
    }
    
    public func onPaymentCancelled(transactionId: String) {
        MobilePaymentPlugin.shared.result?(FlutterError(code: "5002", message: "Payment cancelled by user", details: ["transactionId": transactionId]))
    }
    
    public func didTapDeleteCard(_ withToken: String) {
        let object = ["cardToken": withToken]
        MobilePaymentPlugin.shared.result?(object)
    }
    
    public func onPaymentCompletion(withResponse response: MobilePaymentGatewayResponse) {
        var dictionary = response.getGatewayRawResponse()
        dictionary?["shouldStoreCard"] = response.getUserSavedCard()
        MobilePaymentPlugin.shared.result?(dictionary)
    }
}

struct FlutterResponse {
    var data: [String: Any]?
    var error: FlutterError?
    var method: MobilePaymentSDKMethodsEnum
}

enum MobilePaymentSDKMethodsEnum {
    case success
    case error
    case cancelled
}

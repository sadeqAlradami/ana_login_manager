
import Flutter
import UIKit

public class SwiftAnaLoginManagerPlugin: NSObject, FlutterPlugin {
   
   var flutterCallbackResult: FlutterResult?
    var clientId:String?
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "analogin", binaryMessenger: registrar.messenger())
    let instance = SwiftAnaLoginManagerPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
     registrar.addApplicationDelegate(instance)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    //result("iOS " + UIDevice.current.systemVersion)
    // Note: this method is invoked on the UI thread.
      self.flutterCallbackResult = result
      if (call.method == "init") {
          let args=call.arguments as? [String:Any] ?? [String:Any]()
          clientId = args["clientId"] as? String ?? ""
          self.flutterCallbackResult?(FlutterError(code: "1", message: "SDK initialized", details: "SDK initialized"))
      }else if (call.method == "login") {
          login(args:call.arguments as? [String:Any] ?? [String:Any]())

      }
  }
    func login(args: [String:Any]) {
       // print("onInitialize \(args)")
        let scope=args["scope"] as? String ?? ""
        //let url = "anaapp:anaapp?index=1"
        let url = "anaapp:anaApp?clientId=\(clientId ?? "")&scope=\(scope)"
        print("onInitialize \(url)")
       // UIApplication.shared.open(NSURL(string: url)! as URL)
        if (UIApplication.shared.canOpenURL(NSURL(string: url)! as URL)) {
           // The URL was delivered successfully!
            print("canOpenURL successfully")
            UIApplication.shared.open(NSURL(string: url)! as URL) { (result) in
                if result {
                   // The URL was delivered successfully!
                    print("he URL was delivered successfully")
                }
            }
        }else{
           flutterCallbackResult?(FlutterError(code: "-1", message: "App not installed", details: "App not installed"))
        }
    }
    public func application(_ application: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        print("SwiftAnaLoginManagerPlugin Response in Plugin")
        // Determine who sent the URL.
        if let sourceAppId = options[.sourceApplication]  as? String{
            print("source application = \(sourceAppId)")
            if(sourceAppId=="com.outsource.ana"){
                print(url.absoluteString)
                let dict = self.separateDeeplinkParamsIn(url: url.absoluteString, byRemovingParams: nil)
                let authId = dict["authId"] ?? ""

                if(!authId.isEmpty){
        //            var data = [String : Any]()
        //            data["data"] = dict
                   
                    let jsonData = try! JSONSerialization.data(withJSONObject: dict)
                    let x = String(data: jsonData, encoding: String.Encoding(rawValue: NSUTF8StringEncoding))!
                    flutterCallbackResult?(x) // MARK: Called to send response to flutter app in result parameter
                }else{
                    flutterCallbackResult?(FlutterError(code: "0", message: "Deny", details: "Deny")) // MARK: Called to send response to flutter app in result parameter

                }
                
            }
            
        }

        
       
       return true
    }
//     func startTransaction(parameters: [String:Any], callBack: @escaping FlutterResult) {
//         self.flutterCallbackResult = callBack
//         if let mid = parameters["mid"] as? String, let isStaging = parameters["isStaging"] as? Bool, let orderId = parameters["orderId"] as? String, let transactionToken = parameters["txnToken"] as? String, let amount = parameters["amount"] as? String, let restrictAppInvoke = parameters["restrictAppInvoke"] as? Bool {
//             DispatchQueue.main.async {
//               var env:AIEnvironment = .production
//               if isStaging {
//                 env = .staging
//               } else {
//                 env = .production
//               }
//               self.appinvoke.setBridgeName(name: "Flutter")
//               self.appinvoke.restrictAppInvokeFlow(restrict: restrictAppInvoke)
//                self.appinvoke.openPaytm(merchantId: mid, orderId: orderId, txnToken: transactionToken, amount: amount, callbackUrl: "", delegate: self, environment: env, urlScheme: "")
//             }
//         }
//     }

     /*public func application(_ application: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
         print("Response in Plugin")
         print(url.absoluteString)
        let dict = self.separateDeeplinkParamsIn(url: url.absoluteString, byRemovingParams: nil)
        self.handleResponseAppInvoke(dict) // MARK: Called to send response to flutter app in result parameter.
        return true
     }*/

         //MARK: response got in the URL can be segregated and converted into json from here.
    func separateDeeplinkParamsIn(url: String?, byRemovingParams rparams: [String]?)  -> [String: String] {
        guard let url = url else {
            return [String : String]()
        }

        /// This url gets mutated until the end. The approach is working fine in current scenario. May need a revisit.
        var urlString = stringByRemovingDeeplinkSymbolsIn(url: url)

        var paramList = [String : String]()
        let pList = urlString.components(separatedBy: CharacterSet.init(charactersIn: "&?//"))
        for keyvaluePair in pList {
            let info = keyvaluePair.components(separatedBy: CharacterSet.init(charactersIn: "="))
            if let fst = info.first , let lst = info.last, info.count == 2 {
                paramList[fst] = lst.removingPercentEncoding
                if let rparams = rparams, rparams.contains(info.first!) {
                    urlString = urlString.replacingOccurrences(of: keyvaluePair + "&", with: "")
                    //Please dont interchage the order
                    urlString = urlString.replacingOccurrences(of: keyvaluePair, with: "")
                }
            }
            if info.first == "response" {
                paramList["response"] = keyvaluePair.replacingOccurrences(of: "response=", with: "").removingPercentEncoding
            }
        }

        if let trimmedURL = pList.first {
            paramList["trimmedurl"] = trimmedURL
        }
        return paramList
    }

    func  stringByRemovingDeeplinkSymbolsIn(url: String) -> String {
        var urlString = url.replacingOccurrences(of: "$", with: "&")

        /// This may need a revisit. This is doing more than just removing the deeplink symbol.
        if let range = urlString.range(of: "&"), urlString.contains("?") == false{
            urlString = urlString.replacingCharacters(in: range, with: "?")
        }

        return urlString
    }

 }

//
//extension SwiftAllInOneSdkPlugin: AIDelegate {
//   public func didFinish(with status: AIPaymentStatus, response: [String : Any]) {
//            self.handleResponseRedirection(response)
//    }
//
//    fileprivate func handleResponseRedirection(_ response: [String: Any]) {
//        if let STATUS = response["STATUS"] as? String, STATUS == "TXN_SUCCESS" {
//            self.flutterCallbackResult?(response)
//        } else {
//
//            var message = ""
//            if let errorMSG = response["RESPMSG"] as? String {
//                message = errorMSG
//            }
//            let error = FlutterError(code: "0", message: message, details: response)
//            self.flutterCallbackResult?(error)
//        }
//    }
//
//    fileprivate func handleResponseAppInvoke(_ response: [String: Any]) {
//        var status: MerchantPaymentStatus = .none
//        if let statusCode = response["status"] as? String {
//            switch  statusCode {
//            case "PYTM_103": status = .paymentDeduction
//            case "PYTM_104": status = .errorInParameter
//            case "PYTM_105": status = .error
//            case "PYTM_106": status = .cancel
//            default: status = .error
//            }
//        }
//
//        if status == .paymentDeduction {
//            self.flutterCallbackResult?(response)
//        }
//        else if status == .error {
//            let error = FlutterError(code: "0", message: "Transaction Failure", details: response)
//            self.flutterCallbackResult?(error)
//        }
//        else if status == .cancel {
//            let error = FlutterError(code: "0", message: "User has not completed transaction.", details: response)
//            self.flutterCallbackResult?(error)
//        }
//        else if status == .errorInParameter {
//            let error = FlutterError(code: "0", message: "Invalid Parameters", details: response)
//            self.flutterCallbackResult?(error)
//        }
//        else {
//            self.flutterCallbackResult?(response)
//        }
//    }
//
//
//
//        public func openPaymentWebVC(_ controller: UIViewController?) {
//            print("Response2")
//
//            if let vc = controller {
//                DispatchQueue.main.async {
//                    UIApplication.shared.keyWindow?.rootViewController?.present(vc, animated: true, completion: nil)
//                }
//            }
//        }
//  }


//
//  PaymentVC.swift
//  Agewise
//
//  Created by 최대성 on 8/31/24.
//

import UIKit
import WebKit
import iamport_ios
import SnapKit
import RxCocoa
import RxSwift


final class PaymentVC: BaseVC {
    
    var payInfo: PostModelToWrite?
    private let disposeBag = DisposeBag()
    
    let webView: WKWebView = {
        var view = WKWebView()
        view.backgroundColor = UIColor.clear
        return view
    }()
    
    lazy var payment = IamportPayment(
        pg: PG.html5_inicis.makePgRawName(pgId: "INIpayTest"),
        merchant_uid: "ios_\(APIKey.DeveloperKey)_\(Int(Date().timeIntervalSince1970))",
        amount: "\(payInfo?.price ?? 1000)").then {
            $0.pay_method = PayMethod.card.rawValue
            $0.name = "결제 수단 선택"
            $0.buyer_name = "\(UserDefaultManager.userNickname)"
            $0.app_scheme = "sesac"
        }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureLayout()
        requestPayment()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    func configureLayout() {
        view.addSubview(webView)
        webView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    func requestPayment() {
        print("이거실행")
        let usercode = "imp57573124"
        
        Iamport.shared.paymentWebView(
            webViewMode: webView,
            userCode: usercode,
            payment: payment) { [weak self] iamportResponse in
                print(String(describing: iamportResponse))
                
                let payInfoDetail = PaymentQuery(imp_uid: iamportResponse?.imp_uid ?? "", post_id: self?.payInfo?.postID ?? "" )
                
                PostNetworkManager.shared.postNetwork(api: .payment(query: payInfoDetail), model: PayModel.self)
                    .subscribe(onSuccess: { (statusCode, success) in
                        print("결제 성공 statusCode = \(statusCode)")
                    }, onFailure: { error in
                        print("결제 실패", error)
                    })
                    .disposed(by: self?.disposeBag ?? DisposeBag())
            }
    }
}

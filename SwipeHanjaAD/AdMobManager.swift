//
//  AdMobManager.swift
//  SwipeHanja
//
//  Created by Anto-Yang on 1/4/25.
//
import Foundation
import GoogleMobileAds

class AdMobManager: NSObject {
    static let shared = AdMobManager()
    private override init() { }
    private var interstitial: GADInterstitialAd?
    private var completion: ((Bool) -> Void)?
    
    func configure() {
        GADMobileAds.sharedInstance().start(completionHandler: nil)
    }
    
    
    /// 광고를 표시한다.
    /// - Parameters:
    ///   - baseVC: 광고표시할 base VC
    ///   - completion: 광고 후 실행할 동작,  bool값은 광고표시 success 여부.
    func showAD(baseVC: UIViewController? = nil, completion: ((Bool) -> Void)? = nil) {
        self.completion = completion
        
        Task {
            do {
                interstitial = try await GADInterstitialAd.load(
                    withAdUnitID: "ca-app-pub-3940256099942544/4411468910",
                    request: GADRequest()
                )
                interstitial?.fullScreenContentDelegate = self
            } catch {
                shLog("Ad 에러:Failed to load interstitial ad with error: \(error.localizedDescription)")
                completion?(false) // 광고 로드 실패 시 completion 호출
                return
            }
            
            guard let interstitial = interstitial else {
                shLog("Ad 에러: Ad wasn't ready.")
                completion?(false) // 광고가 준비되지 않았을 경우 completion 호출
                return
            }

            await MainActor.run {
                if let baseVC = baseVC {
                    interstitial.present(fromRootViewController: baseVC)
                } else {
                    shLog("Ad 에러: Base view controller is nil.")
                    completion?(false) // baseVC가 nil인 경우 completion 호출
                }
            }
        }
    }
}

// MARK: - GADFullScreenContentDelegate
extension AdMobManager: GADFullScreenContentDelegate {
    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        shLog("Ad 성공: 표시 후 닫힘")
        completion?(true) // 광고 닫힌 후 completion 호출
        completion = nil // 클로저 해제
    }
    
    func adDidFailToPresentFullScreenContent(_ ad: GADFullScreenPresentingAd, withError error: Error) {
        shLog("Ad 에러: Failed to present with error: \(error.localizedDescription)")
        completion?(false) // 광고 표시 실패 시 completion 호출
        completion = nil // 클로저 해제
    }
}





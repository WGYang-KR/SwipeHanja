//
//  AdMobManager.swift
//  SwipeHanja
//
//  Created by Anto-Yang on 1/4/25.
//
import Foundation
import GoogleMobileAds

class AdMobManager {
    static let shared = AdMobManager()
    private init() { }
    private var interstitial: GADInterstitialAd?
    
    func configure() {
        GADMobileAds.sharedInstance().start(completionHandler: nil)
    }
    
    func showAD(baseVC: UIViewController? = nil) {
        Task {
            do {
                interstitial = try await GADInterstitialAd.load(
                    withAdUnitID: "ca-app-pub-3940256099942544/4411468910", request: GADRequest())
            } catch {
                print("Failed to load interstitial ad with error: \(error.localizedDescription)")
            }
            
            guard let interstitial = interstitial else {
              return print("Ad wasn't ready.")
            }

            await MainActor.run {
                // The UIViewController parameter is an optional.
                interstitial.present(fromRootViewController: baseVC)
            }
            
        }
        
        
    }
}

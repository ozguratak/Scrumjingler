//
//  AdmobBannerView.swift
//  Scrumdinger
//
//  Created by ozgur.atak on 22.03.2023.
//

import SwiftUI
import GoogleMobileAds
import UIKit

// App Id : ca-app-pub-5989837650310108~8534648253
// Unit Id : ca-app-pub-5989837650310108/8320979549

private struct BannerVC: UIViewControllerRepresentable {
    var bannerID: String
    var width: CGFloat

    func makeUIViewController(context: Context) -> UIViewController {
        let view = GADBannerView(adSize: GADCurrentOrientationAnchoredAdaptiveBannerAdSizeWithWidth(width))

        let viewController = UIViewController()
        #if DEBUG
        view.adUnitID = "ca-app-pub-5989837650310108/8320979549"
        #else
        view.adUnitID = bannerID
        #endif
        view.rootViewController = viewController
        viewController.view.addSubview(view)
        view.load(GADRequest())

        return viewController
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
}

struct Banner: View {
    var bannerID: String
    var width: CGFloat

    var size: CGSize {
        return GADCurrentOrientationAnchoredAdaptiveBannerAdSizeWithWidth(width).size
    }

    var body: some View {
        BannerVC(bannerID: bannerID, width: width)
            .frame(width: size.width, height: size.height)
    }
}

struct Banner_Previews: PreviewProvider {
    static var previews: some View {
        Banner(bannerID: "ca-app-pub-5989837650310108/8320979549", width: UIScreen.main.bounds.width)
    }
}


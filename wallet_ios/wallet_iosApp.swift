//
//  mPayAppHahaApp.swift
//  mPayAppHaha
//
//  Created by Appiness on 28/11/25.
//

import SwiftUI

@main
struct mPayAppHahaApp: App {
    init() {
            setupNavigationBarAppearance()
        }
    var body: some Scene {
        WindowGroup {
            AppView()
        }
    }
    private func setupNavigationBarAppearance() {
			let appearance = UINavigationBarAppearance()
			appearance.configureWithTransparentBackground()

			// Replace with your correct PostScript name:
			appearance.titleTextAttributes = [
					.font: UIFont(name: "OpenRunde-Semibold", size: 20)!,
					.foregroundColor: UIColor.label,
					.kern: -0.4
			]

			appearance.largeTitleTextAttributes = [
					.font: UIFont(name: "OpenRunde-Bold", size: 34)!,
					.foregroundColor: UIColor.label,
					.kern: -0.2
			]

			UINavigationBar.appearance().standardAppearance = appearance
			UINavigationBar.appearance().scrollEdgeAppearance = appearance
			UINavigationBar.appearance().compactAppearance = appearance
	}
}


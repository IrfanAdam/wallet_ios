import SwiftUI
import AVKit

struct transactOpts: View {
	@State private var searchText = ""
	@State private var isSearchActive = false
	@Environment(\.dismiss) private var dismiss
	@State private var sheetDetent: PresentationDetent = .medium
	var body: some View {
		NavigationStack {
			ZStack {
				PseudoCameraView(videoName: "pay_mock")
					.overlay(
						Color.black.opacity(0.24)
					).ignoresSafeArea()
			}
			.toolbar {
				ToolbarItem(placement: .navigationBarLeading) {
					Button {
						dismiss()
					} label: {
						Image(systemName: "xmark")
					}
				}
			}
			.toolbarVisibility(sheetDetent == .large ? .hidden : .visible)
		}
		.sheet(isPresented: .constant(true)) {
			TransactOptions(currentDetent: $sheetDetent)
				.presentationDetents([.medium, .large], selection: $sheetDetent)
				.presentationBackgroundInteraction(.enabled(upThrough: .large))
				.presentationDragIndicator(.visible)
				.interactiveDismissDisabled(true)
				.presentationBackground(Color(red: 250/255, green: 248/255, blue: 245/255))
		}
	}
}

struct PseudoCameraView: View {
	let player: AVQueuePlayer
	private let looper: AVPlayerLooper

	init(videoName: String, fileExtension: String = "mp4") {
		let url = Bundle.main.url(forResource: videoName, withExtension: fileExtension)!
		let item = AVPlayerItem(url: url)

		let queuePlayer = AVQueuePlayer()
		self.player = queuePlayer
		self.looper = AVPlayerLooper(player: queuePlayer, templateItem: item)
	}

	var body: some View {
		VideoPlayer(player: player)
			.scaledToFill()
			.frame(maxWidth: .infinity, maxHeight: .infinity)
			.clipped()
			.ignoresSafeArea()
			.onAppear {
				player.play()
			}
	}
}

#Preview {
	transactOpts()
}

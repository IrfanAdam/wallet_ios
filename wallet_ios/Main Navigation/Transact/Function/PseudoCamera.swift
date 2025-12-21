import SwiftUI
import AVKit

// Custom UIViewRepresentable for smooth video playback
struct PseudoCameraView: UIViewRepresentable {
	let videoName: String
	let fileExtension: String

	init(videoName: String, fileExtension: String = "mp4") {
		self.videoName = videoName
		self.fileExtension = fileExtension
	}

	func makeUIView(context: Context) -> VideoPlayerUIView {
		return VideoPlayerUIView(videoName: videoName, fileExtension: fileExtension)
	}

	func updateUIView(_ uiView: VideoPlayerUIView, context: Context) {
		// No updates needed - keeps video stable
	}

	static func dismantleUIView(_ uiView: VideoPlayerUIView, coordinator: ()) {
		uiView.cleanup()
	}
}

// UIView wrapper for AVPlayer with proper layer management
class VideoPlayerUIView: UIView {
	private var player: AVQueuePlayer?
	private var playerLayer: AVPlayerLayer?
	private var looper: AVPlayerLooper?

	init(videoName: String, fileExtension: String) {
		super.init(frame: .zero)
		setupPlayer(videoName: videoName, fileExtension: fileExtension)
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	private func setupPlayer(videoName: String, fileExtension: String) {
		guard let url = Bundle.main.url(forResource: videoName, withExtension: fileExtension) else {
			print("Video file not found")
			return
		}

		let item = AVPlayerItem(url: url)
		let queuePlayer = AVQueuePlayer()

		// Configure player layer for aspect fill
		let playerLayer = AVPlayerLayer(player: queuePlayer)
		playerLayer.videoGravity = .resizeAspectFill
		playerLayer.frame = bounds
		layer.addSublayer(playerLayer)

		self.player = queuePlayer
		self.playerLayer = playerLayer
		self.looper = AVPlayerLooper(player: queuePlayer, templateItem: item)

		// Start playing
		queuePlayer.play()
	}

	override func layoutSubviews() {
		super.layoutSubviews()
		// Update layer frame on layout changes
		playerLayer?.frame = bounds
	}

	func cleanup() {
		player?.pause()
		looper = nil
		player = nil
		playerLayer?.removeFromSuperlayer()
		playerLayer = nil
	}
}

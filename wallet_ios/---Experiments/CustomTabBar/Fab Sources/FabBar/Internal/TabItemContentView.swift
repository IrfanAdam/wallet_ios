import UIKit

/// A custom-draw view that renders a tab item (SF Symbol icon + title) at the current graphics context scale.
///
/// This view supports `NSCoding` so it survives the system accessibility popover's archive/unarchive cycle.
/// When the popover copies segment content, it archives this view and unarchives a copy. Because the
/// symbol name and title are encoded as simple strings, the copy can re-render via `draw(_:)` at whatever
/// scale the popover uses — producing crisp output without any timing hacks or pre-rendered bitmaps.
@available(iOS 26.0, *)
@objc(FabBarTabItemContentView)
final class TabItemContentView: UIView {
	private var symbolName: String = ""
	private var customImageName: String = ""
	private var customImageBundleIdentifier: String = ""
	private var title: String = ""
	
	private let font = UIFont.systemFont(ofSize: Constants.tabTitleFontSize, weight: .semibold)
	//    private let imageAreaHeight = Constants.iconViewSize
	private let iconSize: CGFloat = 32
	private let verticalPadding: CGFloat = 6
	private let spacing: CGFloat = 4
	
	private var renderingMode: UIImage.RenderingMode = .alwaysTemplate
	private var showRing: Bool = false

	init(title: String, symbolName: String, showRing: Bool = false) {
		self.title = title
		self.symbolName = symbolName
		self.showRing = showRing
		super.init(frame: .zero)
		isOpaque = false
		isUserInteractionEnabled = false
		contentMode = .redraw
	}
	
	init(
		title: String,
		imageName: String,
		imageBundle: Bundle?,
		renderingMode: UIImage.RenderingMode,
		showRing: Bool = false,
	) {
		self.title = title
		self.customImageName = imageName
		self.customImageBundleIdentifier = imageBundle?.bundleIdentifier ?? ""
		self.renderingMode = renderingMode
		self.showRing = showRing
		super.init(frame: .zero)
		isOpaque = false
		isUserInteractionEnabled = false
		contentMode = .redraw
	}
	
	// MARK: - NSCoding
	
	required init?(coder: NSCoder) {
		self.symbolName = coder.decodeObject(forKey: "symbolName") as? String ?? ""
		self.customImageName = coder.decodeObject(forKey: "customImageName") as? String ?? ""
		self.customImageBundleIdentifier = coder.decodeObject(forKey: "customImageBundleIdentifier") as? String ?? ""
		self.title = coder.decodeObject(forKey: "title") as? String ?? ""
		super.init(coder: coder)
		// When unarchived by the accessibility popover, hide this view so only the
		// native segment labels are visible. The system renders those at popover scale.
		isHidden = true
		
		if let raw = coder.decodeObject(forKey: "renderingMode") as? Int,
			 let mode = UIImage.RenderingMode(rawValue: raw) {
			self.renderingMode = mode
		} else {
			self.renderingMode = .alwaysTemplate
		}
		self.showRing = coder.decodeBool(forKey: "showRing")
	}
	
	override func encode(with coder: NSCoder) {
		super.encode(with: coder)
		coder.encode(symbolName, forKey: "symbolName")
		coder.encode(customImageName, forKey: "customImageName")
		coder.encode(customImageBundleIdentifier, forKey: "customImageBundleIdentifier")
		coder.encode(title, forKey: "title")
		
		coder.encode(renderingMode.rawValue, forKey: "renderingMode")
		coder.encode(showRing, forKey: "showRing")
	}
	
	override func tintColorDidChange() {
		super.tintColorDidChange()
		setNeedsDisplay()
	}
	
	// MARK: - Sizing
	
	override var intrinsicContentSize: CGSize {
		let textSize = (title as NSString).size(withAttributes: [.font: font])
		let icon = loadIcon()
		let contentWidth = max(icon?.size.width ?? 0, textSize.width)
		//        let height = imageAreaHeight + textSize.height
		
		let height = verticalPadding + iconSize + spacing + textSize.height + verticalPadding
		return CGSize(width: contentWidth, height: height)
	}
	
	// MARK: - Drawing
	
	override func draw(_ rect: CGRect) {
		let tintColor = tintColor ?? .secondaryLabel
		
		let icon = loadIcon()
		//        let textAttributes: [NSAttributedString.Key: Any] = [
		//            .font: font,
		//            .foregroundColor: tintColor,
		//        ]
		//        let textSize = (title as NSString).size(withAttributes: textAttributes)
		//
		//        let contentNudgeUp: CGFloat = 1
		//        let iconTextGap: CGFloat = 1
		
		// Draw icon centered in top area
		if let icon {
			let targetRect = CGRect(
				x: (bounds.width - iconSize) / 2,
				y: 2 * verticalPadding,
				width: iconSize,
				height: iconSize
			)
			
			let renderedIcon = icon.withRenderingMode(renderingMode)
			
			if renderingMode == .alwaysOriginal {
				guard let cgImage = renderedIcon.cgImage else { return }
				
				let imageSize = CGSize(width: cgImage.width, height: cgImage.height)
				
				let gap: CGFloat = 1.5
				let ringWidth: CGFloat = 1.5
				
				// 🔥 Define inner image rect (smaller than 32x32)
				let imageRect = targetRect.insetBy(dx: gap * 1.5, dy: gap * 1.5)
				
				let scale = max(
					imageRect.width / imageSize.width,
					imageRect.height / imageSize.height
				)
				
				let scaledSize = CGSize(
					width: imageSize.width * scale,
					height: imageSize.height * scale
				)
				
				let drawRect = CGRect(
					x: imageRect.midX - scaledSize.width / 2,
					y: imageRect.midY - scaledSize.height / 2,
					width: scaledSize.width,
					height: scaledSize.height
				)
				
				guard let ctx = UIGraphicsGetCurrentContext() else { return }
				
				// 🔥 Draw clipped circular image
				ctx.saveGState()
				ctx.addEllipse(in: imageRect)
				ctx.clip()
				
				renderedIcon.draw(in: drawRect)
				
				ctx.restoreGState()
				
				if showRing {
					// Ring draws inside the same clip pass — composited with the image,
					// colored by tintColor so the mask system drives inactive vs accent.
					let ringRect = targetRect
					let path = UIBezierPath(ovalIn: ringRect.insetBy(dx: ringWidth / 2, dy: ringWidth / 2))
					UIColor.systemBlue.setStroke()
					path.lineWidth = ringWidth
					path.stroke()
				}				
			} else {
				// ✅ EXISTING FIT LOGIC (unchanged)
				let aspect = icon.size.width / icon.size.height
				
				let drawSize: CGSize
				
				if aspect > 1 {
					drawSize = CGSize(width: iconSize, height: iconSize / aspect)
				} else {
					drawSize = CGSize(width: iconSize * aspect, height: iconSize)
				}
				
				let imageRect = CGRect(
					x: (bounds.width - drawSize.width) / 2,
					y: (2 * verticalPadding) + (iconSize - drawSize.height) / 2,
					width: drawSize.width,
					height: drawSize.height
				)
				
				tintColor.setFill()
				renderedIcon.draw(in: imageRect)
			}
		}
			
		
		// Draw text centered below icon area
		//        let textX = (bounds.width - textSize.width) / 2
		//        let textPoint = CGPoint(x: textX, y: imageAreaHeight - contentNudgeUp + iconTextGap)
		//        (title as NSString).draw(at: textPoint, withAttributes: textAttributes)
	}
	
	// MARK: - Private
	
	private func loadIcon() -> UIImage? {
		let config = UIImage.SymbolConfiguration(
			pointSize: Constants.tabIconPointSize,
			weight: .medium,
			scale: .large
		)
		
		if !symbolName.isEmpty {
			return UIImage(systemName: symbolName, withConfiguration: config)
		} else if !customImageName.isEmpty {
			let bundle: Bundle?
			if customImageBundleIdentifier.isEmpty {
				bundle = .main
			} else {
				bundle = Bundle(identifier: customImageBundleIdentifier)
			}
//			return UIImage(named: customImageName, in: bundle, with: config)
			return UIImage(named: customImageName, in: bundle, compatibleWith: nil)
		}
		
		return nil
	}
}

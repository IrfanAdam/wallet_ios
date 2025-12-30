import UIKit

extension UIImage {
	func circularImage(size: CGFloat) -> UIImage? {
		let targetSize = CGSize(width: size, height: size)
		let rect = CGRect(origin: .zero, size: targetSize)

		let scale = max(
			targetSize.width / self.size.width,
			targetSize.height / self.size.height
		)

		let scaledSize = CGSize(
			width: self.size.width * scale,
			height: self.size.height * scale
		)

		let drawOrigin = CGPoint(
			x: (targetSize.width - scaledSize.width) / 2,
			y: (targetSize.height - scaledSize.height) / 2
		)

		UIGraphicsBeginImageContextWithOptions(targetSize, false, 0)
		UIBezierPath(ovalIn: rect).addClip()

		self.draw(in: CGRect(origin: drawOrigin, size: scaledSize))

		let image = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()

		return image?.withRenderingMode(.alwaysOriginal)
	}
}

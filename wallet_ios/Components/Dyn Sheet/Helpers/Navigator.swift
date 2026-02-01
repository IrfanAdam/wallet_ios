import SwiftUI

enum RouteNavigator {
	static func previous<Route: CaseIterable & Equatable>(
		_ route: Route
	) -> Route? {
		let all = Array(Route.allCases)
		guard let index = all.firstIndex(of: route), index > 0 else {
			return nil
		}
		return all[index - 1]
	}
	
	static func next<Route: CaseIterable & Equatable>(
		_ route: Route
	) -> Route? {
		let all = Array(Route.allCases)
		guard let index = all.firstIndex(of: route),
					index + 1 < all.count else {
			return nil
		}
		return all[index + 1]
	}
}

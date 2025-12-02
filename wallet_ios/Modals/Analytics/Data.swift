import SwiftUI
import Foundation

// MARK: - Models

struct TimeRangeID: Identifiable, Hashable {
	let id = UUID()
	let label: String
	let start: Date
	let end: Date
}

struct Actual {
	let spent: Double
	let received: Double
}

struct Forecast {
	let projectedSpent: Double?
	let projectedReceived: Double?
}

struct Budget {
	let limit: Double
	let remaining: Double
}

struct SpendingEntry: Identifiable {
	let id = UUID()
	let time: TimeRangeID
	let actual: Actual?
	let forecast: Forecast?
	let budget: Budget?
}

// MARK: - Helpers

func date(_ string: String, format: String = "yyyy-MM-dd") -> Date {
	let formatter = DateFormatter()
	formatter.dateFormat = format
	formatter.timeZone = .current
	return formatter.date(from: string) ?? Date()
}

// MARK: - Data

let monthlyRanges: [TimeRangeID] = [
	TimeRangeID(label: "JAN", start: date("2025-01-01"), end: date("2025-01-31")),
	TimeRangeID(label: "FEB", start: date("2025-02-01"), end: date("2025-02-28")),
	TimeRangeID(label: "MAR", start: date("2025-03-01"), end: date("2025-03-31")),
	TimeRangeID(label: "APR", start: date("2025-04-01"), end: date("2025-04-30")),
	TimeRangeID(label: "MAY", start: date("2025-05-01"), end: date("2025-05-31")),
	TimeRangeID(label: "JUN", start: date("2025-06-01"), end: date("2025-06-30")),
	TimeRangeID(label: "JUL", start: date("2025-07-01"), end: date("2025-07-31")),
	TimeRangeID(label: "AUG", start: date("2025-08-01"), end: date("2025-08-31")),
	TimeRangeID(label: "SEP", start: date("2025-09-01"), end: date("2025-09-30")),
	TimeRangeID(label: "OCT", start: date("2025-10-01"), end: date("2025-10-31")),
	TimeRangeID(label: "NOV", start: date("2025-11-01"), end: date("2025-11-30")),
	TimeRangeID(label: "DEC", start: date("2025-12-01"), end: date("2025-12-31"))
]

let spendingYear: [SpendingEntry] = [
	// Actual months
	SpendingEntry(time: monthlyRanges[0], actual: Actual(spent: 24, received: 120), forecast: nil, budget: Budget(limit: 150, remaining: 126)),
	SpendingEntry(time: monthlyRanges[1], actual: Actual(spent: 80, received: 32), forecast: nil, budget: Budget(limit: 140, remaining: 60)),
	SpendingEntry(time: monthlyRanges[2], actual: Actual(spent: 100, received: 42), forecast: nil, budget: Budget(limit: 160, remaining: 60)),
	SpendingEntry(time: monthlyRanges[3], actual: Actual(spent: 200, received: 50), forecast: nil, budget: Budget(limit: 220, remaining: 20)),
	SpendingEntry(time: monthlyRanges[4], actual: Actual(spent: 120, received: 90), forecast: nil, budget: Budget(limit: 180, remaining: 60)),
	SpendingEntry(time: monthlyRanges[5], actual: Actual(spent: 80, received: 60), forecast: nil, budget: Budget(limit: 140, remaining: 60)),
	SpendingEntry(time: monthlyRanges[6], actual: Actual(spent: 150, received: 70), forecast: nil, budget: Budget(limit: 200, remaining: 50)),
	SpendingEntry(time: monthlyRanges[7], actual: Actual(spent: 180, received: 100), forecast: Forecast(projectedSpent: 20, projectedReceived: 40), budget: Budget(limit: 240, remaining: 60)),

	// Future months with ghost + forecast
	SpendingEntry(time: monthlyRanges[8], actual: nil, forecast: Forecast(projectedSpent: 290, projectedReceived: 40), budget: nil),
	SpendingEntry(time: monthlyRanges[9], actual: nil, forecast: Forecast(projectedSpent: 100, projectedReceived: 20), budget: nil),
	SpendingEntry(time: monthlyRanges[10], actual: nil, forecast: Forecast(projectedSpent: 210, projectedReceived: 60), budget: nil),
	SpendingEntry(time: monthlyRanges[11], actual: nil, forecast: Forecast(projectedSpent: 320, projectedReceived: 40), budget: nil)
]

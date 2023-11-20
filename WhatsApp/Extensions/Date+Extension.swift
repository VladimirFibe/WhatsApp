import Foundation

extension Date {

    func timeElapsed() -> String {

        let seconds = Date().timeIntervalSince(self)

        if seconds < 60 {
            return "Just now"
        } else if seconds < 60 * 60 {

            let minutes = Int(seconds / 60)
            let minText = minutes > 1 ? "mins" : "min"
            return "\(minutes) \(minText)"

        } else if seconds < 24 * 60 * 60 {
            let hours = Int(seconds / (60 * 60))
            let hourText = hours > 1 ? "hours" : "hour"
            return "\(hours) \(hourText)"

        } else {
            return longDate()
        }
    }

    func longDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy"
        return dateFormatter.string(from: self)
    }

    func stringDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "ddMMMyyyyHHmmss"
        return dateFormatter.string(from: self)
    }

    func time() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.string(from: self)
    }

    func interval(ofComponent comp: Calendar.Component, from date: Date) -> Float {

        let currentCalendar = Calendar.current

        guard  let start = currentCalendar.ordinality(of: comp, in: .era, for: date) else { return 0 }
        guard  let end = currentCalendar.ordinality(of: comp, in: .era, for: self) else { return 0 }

        return Float(start - end)
    }
}

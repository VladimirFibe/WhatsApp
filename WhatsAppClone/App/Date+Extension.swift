import Foundation

extension Date {
    var timeElapsed: String {
        let seconds = Date().timeIntervalSince(self)
        if seconds < 60 {
            return "Just now"
        } else if seconds < 3600 {
            let minutes = Int(seconds / 60)
            let minText = minutes == 1 ? "min" : "mins"
            return "\(minutes) \(minText)"
        } else if seconds < 24 * 3600 {
            let hours = Int(seconds / 3600)
            let hoursText = hours == 1 ? "hour" : "hours"
            return "\(hours) \(hoursText)"
        } else {
            return longDate
        }
    }

    var longDate: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy"
        return dateFormatter.string(from: self)
    }
}

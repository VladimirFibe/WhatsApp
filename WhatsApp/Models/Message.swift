import Foundation
import RealmSwift

class Message: Object, Codable {

    @objc dynamic var id = ""
    @objc dynamic var date = Date()
    @objc dynamic var name = ""
    @objc dynamic var uid = ""
    @objc dynamic var initials = ""
    @objc dynamic var readDate = Date()
    @objc dynamic var type = ""
    @objc dynamic var status = ""
    @objc dynamic var text = ""
    @objc dynamic var audioUrl = ""
    @objc dynamic var videoUrl = ""
    @objc dynamic var pictureUrl = ""
    @objc dynamic var latitude = 0.0
    @objc dynamic var longitude = 0.0
    @objc dynamic var audioDuration = 0.0
    @objc dynamic var incoming = false

    override class func primaryKey() -> String? {"id"}
    var data: [String: Any] {[
        "id": id,
        "date": date,
        "uid": uid,
        "initials": initials,
        "readDate": readDate,
        "status": status,
        "audioUrl": audioUrl,
        "videoUrl": videoUrl,
        "pictureUrl": pictureUrl,
        "latitude": latitude,
        "longitude": longitude,
        "autdioDuration": audioDuration,
        "incoming": incoming
    ]}
}

import Foundation

struct Notification: Identifiable, Codable {
    var id: UUID
    var type: NotificationType
    var message: String
    var date: Date

    enum NotificationType: String, Codable {
        case follow
        // 他の通知タイプを追加する場合はここに追加
    }
}
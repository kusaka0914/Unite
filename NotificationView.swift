import Foundation

struct Notification: Identifiable, Codable {
    var id: UUID
    var type: NotificationType
    var message: String
    var date: Date
    var senderId: UUID
    var isRead: Bool = false // 既読かどうかを示すプロパティを追加

    enum NotificationType: String, Codable {
        case follow
        // 他の通知タイプを追加する場合はここに追加
    }
}
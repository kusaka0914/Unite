import Foundation

struct DraggableText: Identifiable, Codable {
    var id: UUID
    var text: String
    var position: CGPoint
}

struct Story: Identifiable, Codable {
    var id = UUID()
    var imageName: String
    var isViewed: Bool = false
    var texts: [DraggableText] = [] // テキスト情報を追加
    var imageOffset: CGSize = .zero // 画像のオフセットを追加
    var imageScale: CGFloat = 1.0 // 画像のスケールを追加
    var postedDate: Date = Date() // 投稿日時を追加

    // カスタムイニシャライザを更新
    init(imageName: String, isViewed: Bool = false, texts: [DraggableText] = [], imageOffset: CGSize = .zero, imageScale: CGFloat = 1.0, postedDate: Date = Date()) {
        self.imageName = imageName
        self.isViewed = isViewed
        self.texts = texts
        self.imageOffset = imageOffset
        self.imageScale = imageScale
        self.postedDate = postedDate
    }

    // CodingKeysの定義を更新
    enum CodingKeys: String, CodingKey {
        case id
        case imageName
        case isViewed
        case texts
        case imageOffset // 画像のオフセットを追加
        case imageScale // 画像のスケールを追加
        case postedDate // 投稿日時を追加
    }

    // カスタムデコードロジックを更新
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        imageName = try container.decode(String.self, forKey: .imageName)
        isViewed = try container.decodeIfPresent(Bool.self, forKey: .isViewed) ?? false
        texts = try container.decodeIfPresent([DraggableText].self, forKey: .texts) ?? []
        imageOffset = try container.decodeIfPresent(CGSize.self, forKey: .imageOffset) ?? .zero // 画像のオフセットをデコード
        imageScale = try container.decodeIfPresent(CGFloat.self, forKey: .imageScale) ?? 1.0 // 画像のスケールをデコード
        postedDate = try container.decodeIfPresent(Date.self, forKey: .postedDate) ?? Date() // 投稿日時をデコード
    }

    // エンコードロジックを更新
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(imageName, forKey: .imageName)
        try container.encode(isViewed, forKey: .isViewed)
        try container.encode(texts, forKey: .texts)
        try container.encode(imageOffset, forKey: .imageOffset) // 画像のオフセットをエンコード
        try container.encode(imageScale, forKey: .imageScale) // 画像のスケールをエンコード
        try container.encode(postedDate, forKey: .postedDate) // 投稿日時をエンコード
    }
}
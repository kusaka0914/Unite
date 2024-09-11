import Foundation

struct Post: Identifiable, Codable {
    var id: UUID
    var text: String
    var images: [Data]
}

struct User: Identifiable, Codable {
    var id: UUID
    var username: String
    var university: String
    var posts: [Post] // 投稿の配列
    var followers: [UUID]
    var following: [UUID]
    var accountname: String
    var faculty: String
    var department: String
    var club: String
    var bio: String
    var twitterHandle: String
    var email: String
    var stories: [Story] = [] // デフォルト値を設定
    var iconImageData: Data?
    var notifications: [Notification] = []
    
    init(id: UUID = UUID(), username: String, university: String, posts: [Post] = [], followers: [UUID] = [], following: [UUID] = [], accountname: String, faculty: String, department: String, club: String, bio: String, twitterHandle: String, email: String, stories: [Story] = [], iconImageData: Data? = nil, notifications: [Notification] = []) {
        self.id = id
        self.username = username
        self.university = university
        self.posts = posts
        self.followers = followers
        self.following = following
        self.accountname = accountname
        self.faculty = faculty
        self.department = department
        self.club = club
        self.bio = bio
        self.twitterHandle = twitterHandle
        self.email = email
        self.stories = stories
        self.iconImageData = iconImageData
        self.notifications = notifications
    }
    
    func isFollowing(user: User) -> Bool {
        return following.contains(user.id)
    }
    
    // カスタムデコードロジックを追加
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        username = try container.decode(String.self, forKey: .username)
        university = try container.decode(String.self, forKey: .university)
        posts = try container.decode([Post].self, forKey: .posts) // 投稿のデコード
        followers = try container.decode([UUID].self, forKey: .followers)
        following = try container.decode([UUID].self, forKey: .following)
        accountname = try container.decode(String.self, forKey: .accountname)
        faculty = try container.decode(String.self, forKey: .faculty)
        department = try container.decode(String.self, forKey: .department)
        club = try container.decode(String.self, forKey: .club)
        bio = try container.decode(String.self, forKey: .bio)
        twitterHandle = try container.decode(String.self, forKey: .twitterHandle)
        email = try container.decode(String.self, forKey: .email)
        stories = try container.decodeIfPresent([Story].self, forKey: .stories) ?? []
        iconImageData = try container.decodeIfPresent(Data.self, forKey: .iconImageData)
        notifications = try container.decodeIfPresent([Notification].self, forKey: .notifications) ?? []
    }
}

class UserDefaultsHelper {
    static let shared = UserDefaultsHelper()
    
    private let userKey = "savedUsers"
    private let currentUserKey = "currentUser"
    
    private init() {}
    
    func saveUser(_ user: User) {
        var users = loadUser()
        if let index: Array<User>.Index = users.firstIndex(where: { $0.id == user.id }) {
            users[index] = user
        } else {
            users.append(user)
        }
        do {
            let data = try JSONEncoder().encode(users)
            UserDefaults.standard.set(data, forKey: userKey)
        } catch {
            print("Failed to encode users: \(error)")
        }
    }
    
    func saveUsers(_ users: [User]) {
        do {
            let data = try JSONEncoder().encode(users)
            UserDefaults.standard.set(data, forKey: userKey)
        } catch {
            print("Failed to encode users: \(error)")
        }
    }
    
    func loadUser() -> [User] {
        guard let data = UserDefaults.standard.data(forKey: userKey) else {
            print("No data found in UserDefaults")
            return []
        }
        do {
            var users = try JSONDecoder().decode([User].self, from: data)
            
            // マイグレーション: storiesフィールドが存在しない場合にデフォルト値を設定
            for i in 0..<users.count {
                if users[i].stories.isEmpty {
                    users[i].stories = []
                }
            }
            
            print("Loaded users: \(users)") // デバッグプリント
            return users
        } catch {
            print("Failed to decode users: \(error)")
            return []
        }
    }
    
    func deleteUser(_ user: User) {
        var users = loadUser()
        users.removeAll { $0.id == user.id }
        do {
            let data = try JSONEncoder().encode(users)
            UserDefaults.standard.set(data, forKey: userKey)
        } catch {
            print("Failed to encode users: \(error)")
        }
    }
    
    // 現在のユーザーを保存するメソッド
    func saveCurrentUser(_ user: User) {
        do {
            let data = try JSONEncoder().encode(user)
            UserDefaults.standard.set(data, forKey: currentUserKey)
        } catch {
            print("Failed to encode current user: \(error)")
        }
    }
    
    // 現在のユーザーをロードするメソッド
    func loadCurrentUser() -> User? {
        guard let data = UserDefaults.standard.data(forKey: currentUserKey) else {
            print("No current user data found in UserDefaults")
            return nil
        }
        do {
            let user = try JSONDecoder().decode(User.self, from: data)
            print("Loaded current user: \(user)") // デバッグプリント
            return user
        } catch {
            print("Failed to decode current user: \(error)")
            return nil
        }
    }
    
    // ユーザーをフォローするメソッド
    func followUser(follower: User, followee: User) {
        var users = loadUser()
        
        if let followerIndex = users.firstIndex(where: { $0.id == follower.id }),
           let followeeIndex = users.firstIndex(where: { $0.id == followee.id }) {
            users[followerIndex].following.append(followee.id)
            users[followeeIndex].followers.append(follower.id)

            let notification = Notification(id: UUID(), type: .follow, message: "\(follower.username)があなたをフォローしました", date: Date())
            users[followeeIndex].notifications.append(notification)            
            
            do {
                let data = try JSONEncoder().encode(users)
                UserDefaults.standard.set(data, forKey: userKey)
            } catch {
                print("Failed to encode users: \(error)")
            }
        }
    }
    
    // ユーザーのフォローを解除するメソッド
    func unfollowUser(follower: User, followee: User) {
        var users = loadUser()
        
        if let followerIndex = users.firstIndex(where: { $0.id == follower.id }),
           let followeeIndex = users.firstIndex(where: { $0.id == followee.id }) {
            users[followerIndex].following.removeAll { $0 == followee.id }
            users[followeeIndex].followers.removeAll { $0 == follower.id }
            
            do {
                let data = try JSONEncoder().encode(users)
                UserDefaults.standard.set(data, forKey: userKey)
            } catch {
                print("Failed to encode users: \(error)")
            }
        }
    }
}
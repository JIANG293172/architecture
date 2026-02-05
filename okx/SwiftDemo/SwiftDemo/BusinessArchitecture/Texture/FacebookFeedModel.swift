import Foundation

struct FacebookFeedModel {
    let userName: String
    let timeAgo: String
    let contentText: String
    let userAvatarUrl: String
    let contentImageUrl: String?
    let likesCount: Int
    let commentsCount: Int
    
    static func mockData() -> [FacebookFeedModel] {
        return [
            FacebookFeedModel(
                userName: "Mark Zuckerberg",
                timeAgo: "2 hours ago",
                contentText: "Working on the future of the metaverse! Texture makes our feed so smooth. 🚀 #Meta #Texture #iOS",
                userAvatarUrl: "https://randomuser.me/api/portraits/men/1.jpg",
                contentImageUrl: "https://picsum.photos/id/1/600/400",
                likesCount: 12500,
                commentsCount: 890
            ),
            FacebookFeedModel(
                userName: "Apple News",
                timeAgo: "5 hours ago",
                contentText: "The new iPhone 16 Pro features a stunning display and advanced camera capabilities. Pre-order starts Friday!",
                userAvatarUrl: "https://randomuser.me/api/portraits/lego/1.jpg",
                contentImageUrl: "https://picsum.photos/id/2/600/400",
                likesCount: 45000,
                commentsCount: 1200
            ),
            FacebookFeedModel(
                userName: "iOS Developer Community",
                timeAgo: "1 day ago",
                contentText: "Texture (AsyncDisplayKit) is still one of the best frameworks for building high-performance lists in iOS. Why do you use it?",
                userAvatarUrl: "https://randomuser.me/api/portraits/women/2.jpg",
                contentImageUrl: nil,
                likesCount: 850,
                commentsCount: 45
            ),
            FacebookFeedModel(
                userName: "TechCrunch",
                timeAgo: "3 hours ago",
                contentText: "Breaking: New advancements in AI are changing the landscape of software engineering forever.",
                userAvatarUrl: "https://randomuser.me/api/portraits/men/3.jpg",
                contentImageUrl: "https://picsum.photos/id/3/600/400",
                likesCount: 3200,
                commentsCount: 120
            )
        ]
    }
}

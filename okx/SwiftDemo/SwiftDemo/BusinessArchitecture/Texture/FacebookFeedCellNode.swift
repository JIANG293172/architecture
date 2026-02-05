import Foundation
import AsyncDisplayKit

class FacebookFeedCellNode: ASCellNode {
    
    // UI Elements
    private let avatarNode = ASNetworkImageNode()
    private let nameNode = ASTextNode()
    private let timeNode = ASTextNode()
    private let contentNode = ASTextNode()
    private let contentImageNode = ASNetworkImageNode()
    private let actionButtonNode = ASButtonNode()
    private let separatorNode = ASDisplayNode()
    
    private let model: FacebookFeedModel
    
    init(model: FacebookFeedModel) {
        self.model = model
        super.init()
        
        // 1. Initialize nodes
        automaticallyManagesSubnodes = true
        backgroundColor = .white
        
        // Avatar
        avatarNode.url = URL(string: model.userAvatarUrl)
        avatarNode.style.preferredSize = CGSize(width: 44, height: 44)
        avatarNode.cornerRadius = 22
        avatarNode.clipsToBounds = true
        
        // Name
        nameNode.attributedText = NSAttributedString(
            string: model.userName,
            attributes: [
                .font: UIFont.boldSystemFont(ofSize: 16),
                .foregroundColor: UIColor.black
            ]
        )
        
        // Time
        timeNode.attributedText = NSAttributedString(
            string: model.timeAgo,
            attributes: [
                .font: UIFont.systemFont(ofSize: 12),
                .foregroundColor: UIColor.gray
            ]
        )
        
        // Content Text
        contentNode.attributedText = NSAttributedString(
            string: model.contentText,
            attributes: [
                .font: UIFont.systemFont(ofSize: 14),
                .foregroundColor: UIColor.darkGray
            ]
        )
        
        // Content Image (Optional)
        if let imageUrl = model.contentImageUrl {
            contentImageNode.url = URL(string: imageUrl)
            contentImageNode.style.preferredSize = CGSize(width: UIScreen.main.bounds.width, height: 250)
            contentImageNode.contentMode = .scaleAspectFill
        }
        
        // Action Button (Like/Comment info)
        let actionText = "👍 \(model.likesCount)  💬 \(model.commentsCount)"
        actionButtonNode.setTitle(actionText, with: UIFont.systemFont(ofSize: 13), with: .blue, for: .normal)
        
        // Separator
        separatorNode.backgroundColor = UIColor(white: 0.9, alpha: 1.0)
        separatorNode.style.preferredSize = CGSize(width: UIScreen.main.bounds.width, height: 8)
    }
    
    // 2. Layout Engine (The most powerful part of Texture)
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        // Header Stack: [Avatar] [Name/Time]
        let nameTimeStack = ASStackLayoutSpec(
            direction: .vertical,
            spacing: 2,
            justifyContent: .start,
            alignItems: .start,
            children: [nameNode, timeNode]
        )
        
        let headerStack = ASStackLayoutSpec(
            direction: .horizontal,
            spacing: 12,
            justifyContent: .start,
            alignItems: .center,
            children: [avatarNode, nameTimeStack]
        )
        headerStack.style.spacingBefore = 12
        headerStack.style.spacingAfter = 12
        
        // Insets for text content
        let contentInset = ASInsetLayoutSpec(
            insets: UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12),
            child: contentNode
        )
        
        // Vertical stack for the whole cell
        var mainStackChildren: [ASLayoutElement] = [headerStack, contentInset]
        
        if model.contentImageUrl != nil {
            mainStackChildren.append(contentImageNode)
        }
        
        let actionInset = ASInsetLayoutSpec(
            insets: UIEdgeInsets(top: 8, left: 12, bottom: 8, right: 12),
            child: actionButtonNode
        )
        mainStackChildren.append(actionInset)
        mainStackChildren.append(separatorNode)
        
        return ASStackLayoutSpec(
            direction: .vertical,
            spacing: 0,
            justifyContent: .start,
            alignItems: .stretch,
            children: mainStackChildren
        )
    }
}

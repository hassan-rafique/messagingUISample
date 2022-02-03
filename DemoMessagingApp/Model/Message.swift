//
//  MessageModel.swift
//  DemoMessagingApp
//
//  Created by Hassan Rafique Awan on 02/02/2022.
//

import Foundation
import UIKit

enum MessageType:String {
    case none = "none"
    case text = "Text"
    case photo = "Photo"
    case video = "Video"
    case sticker = "Sticker"
    case photoWithText = "PhotoWithText"
}

class Message {
    let id = UUID()
    let content: String
    let image: UIImage?
    let gifUrl: URL?
    var type: MessageType
    let messageTime = Date()
    let sender: User
    
    init(content: String, image: UIImage? = nil, gifUrl: URL? = nil, type: MessageType, sender: User) {
        self.content = content
        self.image = image
        self.gifUrl = gifUrl
        self.type = type
        self.sender = sender
    }
}

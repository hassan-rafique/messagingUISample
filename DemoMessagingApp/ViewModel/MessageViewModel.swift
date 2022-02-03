//
//  MessageViewModel.swift
//  DemoMessagingApp
//
//  Created by Hassan Rafique Awan on 03/02/2022.
//

import Foundation
import UIKit

protocol MessageViewModelDelegate {
    func didAddNewMessage(_ message: Message, atIndex index: Int)
}

class MessageViewModel {
    
    // MARK: - Properties
    private (set) var demoMessagesList: [Message] = []
    private (set) var messagesList: [Message] = []
    let loginUser = User(id: 1, name: "James")
    let recieverUser = User(id: 2, name: "Smith")
    private (set) var stickerList: [URL] = []
    
    private var timer: Timer?

    var delegate: MessageViewModelDelegate?
 
    init(delegate: MessageViewModelDelegate? = nil) {
        var stickerList = [URL]()
        for position in 1...6 {
            if let gifUrl = Bundle.main.url(forResource: "stic_\(position)", withExtension: ".gif") {
                stickerList.append(gifUrl)
            }
        }
        self.stickerList = stickerList
        self.delegate = delegate
    }
    
    func prepareMockMessages() {
        messagesList.append(Message(content: "Hi!", type: .text, sender: recieverUser))

        demoMessagesList.append(Message(content: "Hey Brother", type: .text, sender: recieverUser))
        demoMessagesList.append(Message(content: "How it's looking now?", type: .text, sender: recieverUser))
        demoMessagesList.append(Message(content: "Okay 👍", type: .text, sender: recieverUser))
        demoMessagesList.append(Message(content: "Pizza Party 🍕", type: .text, sender: recieverUser))
        demoMessagesList.append(Message(content: "", image: .smithAvatar, type: .photo, sender: recieverUser))
        demoMessagesList.append(Message(content: "This is text messgae with photo, This is a large multiline sample message.", image: .emoji, type: .photoWithText, sender: recieverUser))
        demoMessagesList.append(Message(content: "", gifUrl: Bundle.main.url(forResource: "stic_1", withExtension: ".gif"), type: .sticker, sender: recieverUser))
        demoMessagesList.append(Message(content: "", gifUrl: Bundle.main.url(forResource: "stic_4", withExtension: ".gif"), type: .sticker, sender: recieverUser))
        demoMessagesList.append(Message(content: "", gifUrl: Bundle.main.url(forResource: "stic_5", withExtension: ".gif"), type: .sticker, sender: recieverUser))
        
        timer = Timer.scheduledTimer(withTimeInterval: 6, repeats: true, block: { [weak self] _ in
            guard let self = self else {
                return
            }
            
            let newMessage = self.demoMessagesList[Int.random(in: 0...8)]
            self.messagesList.append(newMessage)
            self.delegate?.didAddNewMessage(newMessage, atIndex: self.messagesList.count-1)
        })
    }
    
    func chatCellIdentifierForRowAtIndexPath(_ indexPath: IndexPath) -> String {
        let messageObj = messagesList[indexPath.item]
        
        switch messageObj.type {
        case .photo:
            return PhotoMessageCell.identifier
        case .text:
            return TextMessageCell.identifier
        case .sticker:
            return StickerCollectionViewCell.identifier
        case .photoWithText:
            return PhotoWithTextMessageCell.identifier
        default:
            return ""
        }
        
    }
    
    func sendTextMessage(_ text: String) {
        let newMessage = Message(content: text, type: .text, sender: loginUser)
        messagesList.append(newMessage)
        delegate?.didAddNewMessage(newMessage, atIndex: messagesList.count-1)
    }
    
    func sendPhotoMessage(image: UIImage, withText text: String = "") {
        let newMessage = Message(content: text, image: image, type: .photo, sender: loginUser)
        if !text.isEmpty {
            newMessage.type = .photoWithText
        }
        messagesList.append(newMessage)
        delegate?.didAddNewMessage(newMessage, atIndex: messagesList.count-1)
    }
    
    func sendGifSticker(gifUrl: URL) {
        let newMessage = Message(content: "", gifUrl: gifUrl, type: .sticker, sender: loginUser)
        messagesList.append(newMessage)
        delegate?.didAddNewMessage(newMessage, atIndex: messagesList.count-1)
    }

    deinit {
        timer?.invalidate()
        timer = nil
    }
}

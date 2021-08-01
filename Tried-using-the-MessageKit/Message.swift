/// Copyright (c) 2018 Razeware LLC
///
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
///
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import MessageKit
import MessageUI

struct Message: MessageType {
	var sender: SenderType
	let id: String?
	let content: String
	let sentDate: Date
	var kind: MessageKind {
		if let image = image {
			return .photo(MediaItemImage(image: image))
		} else {
			return .text(content)
		}
	}
	
	var messageId: String {
		return id ?? UUID().uuidString
	}
	
	var image: UIImage?
	var downloadURL: URL?
	
	init(user: User, content: String) {
		sender = Sender(senderId: user.uid.uuidString,
						displayName: user.name)
		self.content = content
		sentDate = Date()
		id = nil
	}
	
	init(user: User, image: UIImage) {
		sender = Sender(senderId: user.uid.uuidString,
							displayName: user.name)
		self.image = image
		content = ""
		sentDate = Date()
		id = nil
	}
}

private struct MediaItemImage: MediaItem {
	var url: URL?
	var image: UIImage?
	var placeholderImage: UIImage
	var size: CGSize
	
	init(image: UIImage) {
		self.image = image
		self.size = CGSize(width: 240, height: 240)
		self.placeholderImage = UIImage()
	}
}

extension Message: Comparable {
	
	static func == (lhs: Message, rhs: Message) -> Bool {
		return lhs.id == rhs.id
	}
	
	static func < (lhs: Message, rhs: Message) -> Bool {
		return lhs.sentDate < rhs.sentDate
	}
	
}

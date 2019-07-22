//
//  Image.swift
//  TwoApiCallText
//
//  Created by DEV_MOBILE_IOS_JUNIOR on 22/07/2019.
//  Copyright © 2019 DEV_MOBILE_IOS_JUNIOR. All rights reserved.
//

import UIKit

class ImageRecord: NSObject {
    
    var image: UIImage
    var datetime: String?
    var imageUrl: String?
    
    let getDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        // HH와 hh의 차이?
        formatter.dateFormat = "YYYY-MM-DD'T'hh:mm:ss.0000"
        return formatter
    }()
    
    let setDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYYMMDDHHmmss"
        return formatter
    }()
    
    // MARK: - Initializer
    init(with imageDocument: IMDocuments) {
        self.imageUrl = imageDocument.thumbnailUrl
        self.datetime = imageDocument.datetime
        self.image = UIImage.init(named: "Placeholder")!
    }
    
    init(with vclipDocument: VMDocuments) {
        self.imageUrl = vclipDocument.thumbnail
        self.datetime = vclipDocument.datetime
        self.image = UIImage.init(named: "Placeholder")!
    }
    
    // MARK: - Public Method
    public func dateTime() -> Int {
        if let datetime = self.datetime {
            let newDatetime = datetime.components(separatedBy: "+")[0]
            if let date = getDateFormatter.date(from: newDatetime) {
                print("THIS IS DATE!!!!!!!", date)
                let dateString = setDateFormatter.string(from: date)
                return Int(dateString)!
            }
        }
        return 0
    }
}

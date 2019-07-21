//
//  DocumentModel.swift
//  EJPhotoStorage
//
//  Created by DEV_MOBILE_IOS_JUNIOR on 21/07/2019.
//  Copyright © 2019 DEV_MOBILE_IOS_JUNIOR. All rights reserved.
//

import UIKit

class Image : NSObject {
    
    var imageUrl : String?
    var dateTime : String?
    var image : UIImage?
    
    init(by ImageModel: IMDocuments) {
        self.dateTime = ImageModel.datetime
        self.imageUrl = ImageModel.thumbnailUrl
    }
    
    init(by Vclip: VMDocuments) {
        self.dateTime = Vclip.datetime
        self.imageUrl = Vclip.thumbnail
    }
    
    // MARK: - Public func
    public func generateUrlToImage(urlString: String){
        guard let url = URL.init(string: urlString) else { return }
        
        if let data = try? Data(contentsOf: url) {
            if let image = UIImage(data: data) {
                self.image = image
            }
        }
    }
    
}

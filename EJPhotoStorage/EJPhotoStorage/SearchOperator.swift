//
//  Documents2.swift
//  EJPhotoStorage
//
//  Created by DEV_MOBILE_IOS_JUNIOR on 24/07/2019.
//  Copyright © 2019 DEV_MOBILE_IOS_JUNIOR. All rights reserved.
//

import Foundation

class SearchOperator {

    // MARK: - Class Property
    var keyword = ""
    var page = 1
    
    var imageResult: SearchResult
    var vclipResult: SearchResult
    
    var images: [Document] = []
    
    // MARK: - Init
    init(_ image: SearchResult, _ vclip: SearchResult) {
        self.imageResult = image
        self.vclipResult = vclip
    }
    
    // MARK: - Public function
    func combineResults() {
        imageResult.documents.forEach { images.append($0) }
        vclipResult.documents.forEach { images.append($0) }
        
        images.sort { (document1, document2) -> Bool in
            let decoder = JSONDecoder()
            return true
        }
    }

    func isRequestEnd() -> Bool {
        return imageResult.meta.isEnd && vclipResult.meta.isEnd
    }

    func isResultEmpty() -> Bool {
        return (imageResult.documents.count == 0) && (vclipResult.documents.count == 0)
    }

    func firstPage() -> Int {
        page = 1
        return page
    }
    
    func nextPage() -> Int {
        page += 1
        return page
    }
    
}

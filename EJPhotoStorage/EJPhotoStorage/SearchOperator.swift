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
    
    var imageResult: SearchResult?
    var newImageResult: SearchResult?
    var imageData: Data?
    var vclipResult: SearchResult?
    var newVclipresult: SearchResult?
    var vclipData: Data?
    
    var images: [Document] = []
    
    // MARK: - Init
    init() {
        
    }
    
    init(with keyword: String) {
        self.keyword = keyword
    }
    
    // MARK: - Public function
    func decodeData() {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
    
        if let imageData = imageData {
            print("image:", imageData)
            
            newImageResult = try! decoder.decode(SearchResult.self, from: imageData)
        }
        if let vclipData = vclipData {
            newVclipresult = try! decoder.decode(SearchResult.self, from: vclipData)
        }
    }
    
    func combineResults() {
        if let image = imageResult {
            image.documents.forEach { images.append($0) }
        }
        
        if let vclip = vclipResult {
            vclip.documents.forEach { images.append($0) }
        }
        
        // 따로 빼야해
        images.sort { (document1, document2) -> Bool in
            
            return true
        }
    }
    
    func appendNewResult() {
        if let newImage = newImageResult {
            newImage.documents.forEach {
                self.imageResult?.documents.append($0)
            }
            self.newImageResult = nil
        }
        
        if let newVclip = newVclipresult {
            newVclip.documents.forEach {
                self.vclipResult?.documents.append($0)
            }
            self.newVclipresult = nil
        }
    }
    
    // MARK: - Image Info
    func numOfLoadedImages() -> Int {
        // 새로 로드된 이미지 갯수
        return 0
    }

    // MARK: - isEnd Decision
    func isImageEnd() -> Bool {
        if let result = imageResult {
            return result.meta.isEnd
        } else {
            return false
        }
    }
    
    func isVclipEnd() -> Bool {
        if let result = vclipResult {
            return result.meta.isEnd
        } else {
            return false
        }
    }
    
    func isAllRequestEnd() -> Bool {
        return isImageEnd() && isVclipEnd()
    }
    
    // MARK: - isEmpty Decision
    func isDocumentEmpty() -> Bool {
        return images.isEmpty
    }

    func isResultEmpty() -> Bool {
        if isAllRequestEnd() {
            if let image = imageResult, let vclip = vclipResult {
                return (image.documents.count == 0) && (vclip.documents.count == 0)
            }
        }
        
        return false
    }

    
    // MARK: - Page operation
    func firstPage() {
        page = 1
    }
    
    func nextPage() {
        page += 1
    }
    
}

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
    func decodeData(with status: SearchStatus) {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(DateFormatter.iso8601Full)
        
        switch status {
        case .initial:
            if let imageData = imageData {
                do {
                    imageResult = try decoder.decode(SearchResult.self, from: imageData)
                } catch {
                    print("Got Error whild decoding imageData: \(error)")
                }
            }
            if let vclipData = vclipData {
                do {
                    vclipResult = try decoder.decode(SearchResult.self, from: vclipData)
                } catch {
                    print("Got Error while decoding vclipData: \(error)")
                }
            }
        case .loading:
            if let imageData = imageData {
                newImageResult = try! decoder.decode(SearchResult.self, from: imageData)
            }
            if let vclipData = vclipData {
                newVclipresult = try! decoder.decode(SearchResult.self, from: vclipData)
            }
            appendNewResult()
        default:
            print("Status Nothing")
        }
    }
    
    func combineResults() {
        if let image = imageResult {
            print("Image result:", image)
            image.documents.forEach { images.append($0) }
        }
        
        if let vclip = vclipResult {
            vclip.documents.forEach { images.append($0) }
        }
        
        print("Images: ", images)
        
        images.sort { $0.datetime.compare($1.datetime) == .orderedDescending }
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


extension DateFormatter {
    static let iso8601Full: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.000xxx"
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter
    }()
}

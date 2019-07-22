//
//  MainViewController.swift
//  EJPhotoStorage
//
//  Created by DEV_MOBILE_IOS_JUNIOR on 19/07/2019.
//  Copyright © 2019 DEV_MOBILE_IOS_JUNIOR. All rights reserved.
//

import UIKit
import ESPullToRefresh
import CHTCollectionViewWaterfallLayout

enum SearchStatus {
    case initial, searched
}

class MainViewController: UIViewController, CHTCollectionViewDelegateWaterfallLayout, UICollectionViewDataSource, MainDetailViewDelegate, UISearchBarDelegate {
    
    // MARK: - Property
    var searchedImages: [ImageRecord] = []
    var storedImages: [ImageRecord] = []
    var searchKeyword = ""
    
    var isEndOfImage = false
    var imagePage = 1
    
    // MARK: - IBOutlet
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchResultLabel: UILabel!
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        layout()
        
        self.collectionView.es.addPullToRefresh { [unowned self] in
            self.requestImages(for: self.searchKeyword)
        }
        
        self.collectionView.es.addInfiniteScrolling { [unowned self] in
            if self.isEndOfImage {
                print("isEndofImage")
                self.collectionView.es.stopLoadingMore()
            } else {
                print("isNotEnd!!!")
                self.requestLoadMoreImages()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setSearchResultLabel(by: .initial)
    }
    
    // MARK: - CollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return searchedImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ResultCollectionViewCell.identifier, for: indexPath) as! ResultCollectionViewCell
        
        let imageDetail = searchedImages[indexPath.item]
        cell.imageView.image = imageDetail.image
        
        // 상태 빼버림 ㅋㅋ 
        cell.setCellImage(by: imageDetail)
        
        return cell
    }
    
    
    // MARK: - CHTCollectionViewWaterfallLayout Delegate
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
        let result = searchedImages[indexPath.item]
        return result.image.size
    }
    
    
    // MARK: - Save Photo Delegate
    func saveSelectedPhoto(to images: [ImageRecord]) {
        storedImages = images
//        print("Photo Saved!!")
    }
    
    // MARK: - UISearchBar Delegate
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // Hide Keyboard
        self.view.endEditing(true)
        
        // 아무런 검색어도 입력 안했을 때 예외처리!!
        if let searchKeyword = searchBar.text {
            self.searchKeyword = searchKeyword
            requestImages(for: searchKeyword)
        }
    }
    
    // MARK: - Private Method
    fileprivate func requestImages(for keyword: String) {
        pendingOperations.startRequest(keyword: keyword,
                                       page: 1) { (resultRecords, isEnd) in
            self.searchedImages = resultRecords
            self.isEndOfImage = isEnd
                                        print("1: ", self.isEndOfImage)
                                        print("2: ", isEnd)
            self.imagePage = 2
                                        
            self.setSearchResultLabel(by: .searched)
            self.collectionView.reloadData()
            self.collectionView.es.stopPullToRefresh()
        }
    }
    
    fileprivate func requestLoadMoreImages() {
        pendingOperations.startRequest(keyword: searchKeyword, page: imagePage+1) { (resultRecords, isEnd) in
            self.isEndOfImage = isEnd
            self.imagePage += 1
            
            self.collectionView.performBatchUpdates({
                let indexPaths = self.indexPathsForLoadMore(by: resultRecords)
                self.collectionView.insertItems(at: indexPaths)
                self.appendLoaded(resultRecords)
            }, completion: { (success) in
                self.collectionView.es.stopLoadingMore()
                print(success)
            })
        }
    }
    
    fileprivate func appendLoaded(_ images: [ImageRecord]) {
        images.forEach { self.searchedImages.append($0) }
    }
    
    fileprivate func indexPathsForLoadMore(by resultRecords: [ImageRecord]) -> [IndexPath] {
        var moreIndexPaths: [IndexPath] = []
        let startIndex = self.searchedImages.count
        
        for index in 0..<resultRecords.count {
            let indexPath = IndexPath.init(item: startIndex+index, section: 0)
            moreIndexPaths.append(indexPath)
        }
        
        return moreIndexPaths
    }
    
    fileprivate func layout() {
        let waterfallLayout = CHTCollectionViewWaterfallLayout()
        waterfallLayout.minimumColumnSpacing = 5.0
        waterfallLayout.minimumInteritemSpacing = 5.0
        collectionView.collectionViewLayout = waterfallLayout
        searchBar.placeholder = "검색어 입력"
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier
        {
        case .some("main_detail_segue"):
            if let destination = segue.destination as? MainDetailViewController,
                let cell = sender as? UICollectionViewCell, let indexPath = collectionView.indexPath(for: cell) {
                destination.images = searchedImages
                destination.indexPath = indexPath
                destination.delegate = self
            }
        case "main_storage_segue":
            let destination = segue.destination as! StorageViewController
            destination.images = storedImages
        default:
            super.prepare(for: segue, sender: sender)
        }
    }
    
    fileprivate func setSearchResultLabel(by status: SearchStatus) {
        
        searchResultLabel.text = ""
        
        switch status {
        case .initial:
            if searchedImages.count == 0 {
                searchResultLabel.text = "검색어를 입력해주세요."
            }
        case .searched:
            if searchedImages.count == 0 {
                searchResultLabel.text = "검색 결과가 없습니다."
            }
        }
    }
}

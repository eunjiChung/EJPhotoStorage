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

class MainViewController: UIViewController, CHTCollectionViewDelegateWaterfallLayout, UICollectionViewDataSource, SavePhotoDelegate, UISearchBarDelegate {
    
    // MARK: - Property
    var searchedImages: [ImageRecord] = []
    var storedImages: [ImageRecord] = []
    var searchKeyword: String?
    
    // MARK: - IBOutlet
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchResultLabel: UILabel!
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        layout()
        
        self.collectionView.es.addPullToRefresh { [unowned self] in
            if let keyword = self.searchKeyword {
                self.requestImages(for: keyword)
            }
        }
        
        self.collectionView.es.addInfiniteScrolling { [unowned self] in
            print("Infinite Scrolling")
            if let keyword = self.searchKeyword {
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
        cell.imageView.image = imageDetail.image // 처음엔 placeholder 넣어준다
        
        switch imageDetail.state {
        case .new, .cancel:
            cell.setCellImage(by: imageDetail)
        case .downloaded:
            print("Already downloaded image")
        case .fail:
            cell.imageView.image = UIImage(named: "Failed")
        }
        
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
        print("Photo Saved!!")
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
        pendingOperations.startRequest(for: keyword) { resultRecords in
            self.searchedImages = resultRecords
            self.setSearchResultLabel(by: .searched)
            self.collectionView.reloadData()
            self.collectionView.es.stopPullToRefresh()
        }
    }
    
    fileprivate func requestLoadMoreImages() {
        print("LoadMore Images")
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
        switch status {
        case .initial:
            searchResultLabel.text = "검색어를 입력해주세요."
        case .searched:
            if searchedImages.count == 0 {
                searchResultLabel.text = "검색 결과가 없습니다."
            } else {
                searchResultLabel.text = ""
            }
        }
    }
}

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

class MainViewController: UIViewController, CHTCollectionViewDelegateWaterfallLayout, UICollectionViewDataSource, SavePhotoDelegate, UISearchBarDelegate {
    
    // MARK: - Property
    var images: [ImageRecord] = []
    var storedImages: [ImageRecord] = []
    var searchKeyword: String?
    
    let pendingOperations = PendingOperations()
    
    // MARK: - IBOutlet
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchResultLabel: UILabel!
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        layout()
        
        self.collectionView.es.addPullToRefresh { [unowned self] in
            print("PullToRefresh")
            if let keyword = self.searchKeyword {
                self.requestImages(for: keyword)
            }
        }
        
        self.collectionView.es.addInfiniteScrolling { [unowned self] in
            print("Infinite Scrolling")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setSearchStatus()
    }
    
    // MARK: - CollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ResultCollectionViewCell.identifier, for: indexPath) as! ResultCollectionViewCell
        
        let imageDetail = images[indexPath.item]
        cell.imageView.image = imageDetail.image
        
        switch imageDetail.state {
        case .fail:
            print("Image Download failed...")
        case .cancel:
            print("Cancelled Operation!")
        case .new, .downloaded:
            if !collectionView.isDragging && !collectionView.isDecelerating {
                startImageDownloading(for: imageDetail, at: indexPath)
            }
        }
        
        return cell
    }
    
    
    // MARK: - CHTCollectionViewWaterfallLayout Delegate
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
        
        let result = images[indexPath.item]
        if let image = result.image {
            return image.size
        }
        
        return CGSize.zero
    }
    
    // MARK: - UIScrollView Delegate
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        suspendAllOperations()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            loadImagesForOnScreenCells()
            resumeAllOperations()
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        loadImagesForOnScreenCells()
        resumeAllOperations()
    }
    
    // MARK: - Manage Operation
    func suspendAllOperations() {
        pendingOperations.requestQueue.isSuspended = true
        pendingOperations.downloadQueue.isSuspended = true
    }
    
    func resumeAllOperations() {
        pendingOperations.requestQueue.isSuspended = false
        pendingOperations.downloadQueue.isSuspended = false
    }
    
    func loadImagesForOnScreenCells() {
        let pathsArray = collectionView.indexPathsForVisibleItems
        
        let allPendingOperations = Set(pendingOperations.downloadsInProgress.keys)
        var toBeCancelled = allPendingOperations
        let visiblePaths = Set(pathsArray)
    
        toBeCancelled.subtract(visiblePaths)
        
        var toBeStarted = visiblePaths
        toBeStarted.subtract(allPendingOperations)
        
        for indexPath in toBeCancelled {
            if let pendingDownload = pendingOperations.downloadsInProgress[indexPath] {
                pendingDownload.cancel()
            }
            pendingOperations.downloadsInProgress.removeValue(forKey: indexPath)
        }
        
        for indexPath in toBeStarted {
            let recordToProgress = images[indexPath.row]
            startImageDownloading(for: recordToProgress, at: indexPath)
        }
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
        
        if let searchKeyword = searchBar.text {
            self.searchKeyword = searchKeyword
            requestImages(for: searchKeyword)
        }
    }
    
    // MARK: - Private Method
    fileprivate func requestImages(for keyword: String) {
        print("Search keyword: ", keyword)
        let imageRequester = ImageRequester.init(keyword)
        
        imageRequester.completionBlock = {
            self.images = imageRequester.images
            
            DispatchQueue.main.async {
                print("Reload!")
                self.setSearchStatus()
                self.collectionView.reloadData()
                self.collectionView.es.stopPullToRefresh()
            }
        }
        
        self.pendingOperations.requestQueue.addOperation(imageRequester)
    }
    
    fileprivate func startImageDownloading(for imageRecord: ImageRecord, at indexPath: IndexPath) {
        switch imageRecord.state {
        case .new:
            startDownload(for: imageRecord, at: indexPath)
        case .downloaded:
            print("It already downloaded!!!")
        default:
            print("Nothing....")
        }
    }
    
    fileprivate func startDownload(for imageRecord: ImageRecord, at indexPath: IndexPath) {
        
        guard pendingOperations.downloadsInProgress[indexPath] == nil else { return }
        
        let imageDownloader = ImageDownloader.init(imageRecord)
        
        imageDownloader.completionBlock = {
//            print("??")
            
            if imageDownloader.isCancelled {
                return
            }
            
            DispatchQueue.main.async {
                self.pendingOperations.downloadsInProgress.removeValue(forKey: indexPath)
                self.collectionView.reloadItems(at: [indexPath])
            }
        }
        
        pendingOperations.downloadsInProgress[indexPath] = imageDownloader
        pendingOperations.downloadQueue.addOperation(imageDownloader)
    }
    
    fileprivate func layout() {
        let waterfallLayout = CHTCollectionViewWaterfallLayout()
        waterfallLayout.minimumColumnSpacing = 2.0
        waterfallLayout.minimumInteritemSpacing = 2.0
        collectionView.collectionViewLayout = waterfallLayout
        
        searchBar.placeholder = "검색어 입력"
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier
        {
        case .some("main_detail_segue"):
            if let destination = segue.destination as? MainDetailViewController,
                let cell = sender as? UICollectionViewCell,
                let indexPath = collectionView.indexPath(for: cell) {
                destination.images = images
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
    
    fileprivate func setSearchStatus() {
        if images.count == 0 {
            searchResultLabel.text = "검색어를 입력해주세요."
        } else {
            searchResultLabel.text = ""
        }
    }
}

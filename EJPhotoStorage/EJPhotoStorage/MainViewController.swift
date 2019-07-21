//
//  MainViewController.swift
//  EJPhotoStorage
//
//  Created by DEV_MOBILE_IOS_JUNIOR on 19/07/2019.
//  Copyright © 2019 DEV_MOBILE_IOS_JUNIOR. All rights reserved.
//

import UIKit
import CHTCollectionViewWaterfallLayout

class MainViewController: UIViewController, CHTCollectionViewDelegateWaterfallLayout, UICollectionViewDataSource, SavePhotoDelegate, UISearchBarDelegate {
    
    // MARK: - Property
    var images: [ImageRecord] = []
    var storedImages: [ImageRecord] = []
    
    let pendingOperations = PendingOperations()
    
    // MARK: - IBOutlet
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchResultLabel: UILabel!
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        layout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setSearchStatus()
    }

    
    // MARK: - Save Photo Delegate
    func saveSelectedPhoto(to images: [ImageRecord]) {
        storedImages = images
        print("Photo Saved!!")
    }
    
    // MARK: - UISearchBar Delegate
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.view.endEditing(true)
        
        if let searchKeyword = searchBar.text {
            print(searchKeyword)
            let imageRequester = ImageRequester.init(searchKeyword)
            
            imageRequester.completionBlock = {
                self.images = imageRequester.images
                print("Image Requester!!!!!!!!")
                print(self.images)
                print("Image Count", self.images.count)
                
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }
            
            self.pendingOperations.queue.addOperation(imageRequester)
        }
    }
    
    // MARK: - CollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ResultCollectionViewCell.identifier, for: indexPath) as! ResultCollectionViewCell
        
        let result = images[indexPath.item]
        if let image = result.image {
            print("It happened...!")
            cell.imageView.image = image
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
    
    // MARK: - Private Method
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
                destination.images = storedImages
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

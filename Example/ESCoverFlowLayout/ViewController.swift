//
//  ViewController.swift
//  ESCoverFlowLayout
//
//  Created by serkansokmen on 02/26/2017.
//  Copyright (c) 2017 serkansokmen. All rights reserved.
//

import UIKit
import ESCoverFlowLayout

let cellReuseIdentifier = "Cell"

class ViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let layout = collectionView.collectionViewLayout as? ESCoverFlowLayout else { return }
        layout.scrollDirection = .horizontal
        
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: cellReuseIdentifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .clear
        collectionView.isPagingEnabled = false
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        guard let layout = self.collectionView.collectionViewLayout as? ESCoverFlowLayout else { return }
        let sideMargin = (self.collectionView.bounds.size.width - layout.itemSize.width) / 2.0
        
        layout.itemSize = CGSize(width: self.collectionView.bounds.size.width * 0.75,
                                 height: self.collectionView.bounds.size.height * 0.65)
        layout.maxCoverDegree = 22.5
        layout.coverDensity = -0.1 // 1/8
        layout.minCoverOpacity = 0.4
        layout.minCoverScale = 1.0
        layout.isSnapEnabled = true
        layout.sectionInset = UIEdgeInsets(top: 0, left: sideMargin, bottom: 0, right: sideMargin)
    }

}

// MARK: - Collection View Delegate
extension ViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 16
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // configure cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReuseIdentifier, for: indexPath)
        
        cell.contentView.layer.cornerRadius = 5.0
        cell.contentView.layer.borderColor = UIColor.black.cgColor
        cell.contentView.layer.borderWidth = 2.0
        cell.contentView.layer.backgroundColor = UIColor.white.cgColor
        
        return cell
    }
}

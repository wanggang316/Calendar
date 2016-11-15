//
//  CalendarView.swift
//  Calendar
//
//  Created by wanggang on 15/11/2016.
//  Copyright © 2016 GUM. All rights reserved.
//

import UIKit

public class CalendarView: UIView {
    
    // MARK: - Properties
    
    
    // MARK: - UI
    private let collectionView: UICollectionView = {
        
        var layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        let `self` = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        self.backgroundColor = UIColor.clear
        return self
    }()
    
    // MARK: - initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.groupTableViewBackground
        
        self.collectionView.dataSource = self
//        self.collectionView.delegate = self
        self.addSubview(self.collectionView)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


extension CalendarView: UICollectionViewDataSource {
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 30
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        
        cell.backgroundColor = UIColor.yellow
        return cell
    }
}


extension CalendarView: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    public func collectionView(_ collectionView: UICollectionView, shouldDeselectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("selected: \(indexPath)")
    }
}

extension CalendarView: UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 100)
    }
    
//    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
//        
//    }
//    
//    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
//        
//    }
}

//
//  CalendarView.swift
//  Calendar
//
//  Created by wanggang on 15/11/2016.
//  Copyright © 2016 GUM. All rights reserved.
//

import UIKit

open class CalendarView: UIView {
    
    // MARK: - Properties
    
    override open var frame: CGRect {
        didSet {
            self.layoutSubviews()
        }
    }
    
    ///
    open var contentInset: UIEdgeInsets?
    
    /// The line spacing
    open var minimumLineSpacing: CGFloat = 0.0 {
        didSet {
            let layout = self.collectionView.collectionViewLayout as? UICollectionViewFlowLayout
            layout?.minimumLineSpacing = minimumLineSpacing
            self.collectionView.collectionViewLayout = layout!
        }
    }
    
    /// The inner item spacing
    open var minimumInteritemSpacing: CGFloat = 0.0 {
         didSet {
            let layout = self.collectionView.collectionViewLayout as? UICollectionViewFlowLayout
            layout?.minimumInteritemSpacing = minimumInteritemSpacing
            self.collectionView.collectionViewLayout = layout!
        }
    }
    
    
    // MARK: - UI
    private let collectionView: UICollectionView = {
        var layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        let `self` = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        self.backgroundColor = UIColor.clear
        return self
    }()
    
    private let weekView: CalendarWeekView = CalendarWeekView()
    
    // MARK: - initializer
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.groupTableViewBackground
        
        self.collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.addSubview(self.collectionView)
        
        self.addSubview(self.weekView)
    }
    
    public convenience init() {
        self.init(frame: .zero)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - LayoutSubviews
    open override func layoutSubviews() {
        super.layoutSubviews()
        
        let weekViewHeight: CGFloat = 40.0
        let baseTopInset: CGFloat = min(64, self.collectionView.contentInset.top > 0 ? self.collectionView.contentInset.top : 0)

        if let contentInset = self.contentInset {
            let contentWidth = self.collectionView.frame.width - contentInset.left - contentInset.right
            let residue = contentWidth.truncatingRemainder(dividingBy: 7)
            
            var cellWidth = contentWidth / 7.0
            
            let top = baseTopInset + weekViewHeight + contentInset.top
            let bottom = contentInset.bottom
            
            var left: CGFloat = 0.0
            var right: CGFloat = 0.0
            
            if residue != 0 {
                var horizontalPadding: CGFloat = 0.0
                if residue > 7.0 / 2.0 {
                    horizontalPadding = contentInset.left - (7.0 - residue) / 2.0
                    cellWidth = (contentWidth + 7 - residue) / 7.0
                } else {
                    horizontalPadding = contentInset.left + (residue / 2.0)
                    cellWidth = (contentWidth - residue) / 7.0
                }
                
                left = horizontalPadding
                right = horizontalPadding
            }
            
            let inset = UIEdgeInsets(top: top, left: left, bottom: bottom, right: right)
            let indicator = UIEdgeInsets(top: top - contentInset.top, left: 0, bottom: 0, right: 0)
            
            
            self.collectionView.contentInset = inset
            self.collectionView.scrollIndicatorInsets = indicator
            
            let layout = self.collectionView.collectionViewLayout as? UICollectionViewFlowLayout
            layout?.itemSize = CGSize(width: cellWidth, height: cellWidth)
            self.collectionView.collectionViewLayout = layout!
        }
        
        
        self.weekView.frame = CGRect(x: 0, y: baseTopInset, width: self.frame.width, height: weekViewHeight)
        self.collectionView.frame = self.bounds

        
    }
    
    
}


extension CalendarView: UICollectionViewDataSource {
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 12
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
    /*
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (375 - 10) / 7, height: 60)
    }
    */
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return .zero
    }
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return .zero
    }
}

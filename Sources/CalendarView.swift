//
//  CalendarView.swift
//  Calendar
//
//  Created by wanggang on 15/11/2016.
//  Copyright © 2016 GUM. All rights reserved.
//

import UIKit

open class CalendarView: UIView {
    
    // MARK: - public properties
    
    override open var frame: CGRect {
        didSet {
            self.layoutSubviews()
        }
    }
    
    /// The calendar scroll view content inset
    open var contentInset: UIEdgeInsets = UIEdgeInsets.zero
    
    /// week view height
    open var weekViewHeight: CGFloat = 44.0
    
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
    
    /// The spacing from week view to date item
    open var minimumWeekAndDateItemSpacing: CGFloat = 0.0
    
    // MARK: - private properties
    fileprivate var itemSize: CGSize?
    
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
        
        /// default content inset
        var inset = UIEdgeInsets.zero
        
        let contentWidth = self.collectionView.frame.width - contentInset.left - contentInset.right - 6 * self.minimumInteritemSpacing
        let residue = contentWidth.truncatingRemainder(dividingBy: 7)
        
        var cellWidth = contentWidth / 7.0
        
        /// bottom
        inset.bottom = contentInset.bottom

        /// To calculate content inset left, right, and cellWidth
        if residue != 0 {
            var horizontalPadding: CGFloat = 0.0
            if residue > 7.0 / 2.0 {
                horizontalPadding = contentInset.left - (7.0 - residue) / 2.0
                cellWidth = (contentWidth + 7 - residue) / 7.0
            } else {
                horizontalPadding = contentInset.left + (residue / 2.0)
                cellWidth = (contentWidth - residue) / 7.0
            }
            /// left
            inset.left = horizontalPadding
            /// right
            inset.right = horizontalPadding
        }
        self.itemSize = CGSize(width: cellWidth, height: cellWidth)
        
        /// top
        inset.top = self.contentInset.top + self.weekViewHeight + self.minimumWeekAndDateItemSpacing
        
        self.collectionView.contentInset = inset
        
        /// indicator insets
        let indicatorInsets = UIEdgeInsets(top: self.contentInset.top + self.weekViewHeight, left: 0, bottom: 0, right: 0)
        self.collectionView.scrollIndicatorInsets = indicatorInsets
        
        /// set frames
        self.weekView.frame = CGRect(x: 0, y: self.contentInset.top, width: self.frame.width, height: weekViewHeight)
        self.collectionView.frame = self.bounds
        
        /// subview insets
        self.weekView.contentInset = UIEdgeInsets(top: 0, left: inset.left, bottom: 0, right: inset.right)
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
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return self.itemSize ?? CGSize(width: 50, height: 50)
    }
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return .zero
    }
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return .zero
    }
}

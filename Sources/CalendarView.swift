//
//  CalendarView.swift
//  Calendar
//
//  Created by wanggang on 15/11/2016.
//  Copyright © 2016 GUM. All rights reserved.
//

import UIKit

public typealias CalendarDateCell = UICollectionViewCell

open class CalendarView: UIView {
    
    // MARK: - public properties
    
    open var fromDate: Date = {
        let calendar = Date.gregorianCalendar
        let date = Date()
        var components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
        components.year = 2016
        components.month = 3
        components.day = 14
        return calendar.date(from: components)!
    }()
    open var toDate: Date = {
        let calendar = Date.gregorianCalendar
        let date = Date()
        var components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
        components.year = 2016
        components.month = 7
        components.day = 1
        return calendar.date(from: components)!
    }()
    
    override open var frame: CGRect {
        didSet {
            self.layoutSubviews()
        }
    }
    
    /// The calendar scroll view content inset
    open var contentInset: UIEdgeInsets = UIEdgeInsets.zero
    
    /// week view height
    open var weekViewHeight: CGFloat = 44.0
    
    /// The spacing from week view to date item
    open var minimumWeekAndDateItemSpacing: CGFloat = 0.0
    
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
    
    
    // MARK: - public functions
    
    /**
     Rigiste date cell with a identifier.
     
     - parameter cellClass: `CalendarDateCell` type
     - parameter identifier: unique identifier for cell
     */
    public func register(_ cellClass: Swift.AnyClass?, forCellWithReuseIdentifier identifier: String) {
        self.collectionView.register(cellClass, forCellWithReuseIdentifier: identifier)
    }
    
    /**
     Rigiste month header view  with a identifier.
     
     - parameter cellClass: `CalendarMonthHeaderView` type
     - parameter identifier: unique identifier for header view
     */
    public func register(monthHeader viewClass: Swift.AnyClass?, withReuseIdentifier identifier: String) {
        self.collectionView.register(viewClass, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: identifier)
    }
    
    /**
     Rigiste month footer view with a identifier.
     
     - parameter cellClass: `CalendarMonthHeaderView` type
     - parameter identifier: unique identifier for footer view
     */
    public func register(monthFooter viewClass: Swift.AnyClass?, withReuseIdentifier identifier: String) {
        self.collectionView.register(viewClass, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: identifier)
    }
    
    /** Discard the dataSource and delegate data and requery as necessary. */
    public func reloadData() {
        self.collectionView.reloadData()
    }
    
    /**
     Get date cell of the `date`, like `cellAt(indexPath....`, this method find a cell by `date`.
     
     - parameter date: date
     
     - returns: The corresponding date cell
     */
    public func cellAt(date: Date) -> CalendarDateCell? {
        return nil
    }
    
    /**
     Reload the assigned `dates`.
     
     - parameter dates: assigned dates, array of `Date`
     */
    public func reloadItems(at dates: [Date]) {
        
    }
    
    /**
     Reload the assigned `months`.
     
     - parameter months: assigned months, array of `Date`
     */
    public func reloadMonths(at months: [Date]) {
        
    }
    
    
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
        
        self.collectionView.register(SimpleDateCell.self, forCellWithReuseIdentifier: "cell")
        self.collectionView.register(CalendarMonthHeaderView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "headerView")
        self.collectionView.register(CalendarMonthFooterView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: "footerView")
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
        return Date.months(from: self.fromDate, to: self.toDate)
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let firstDateInSection = Date.firstDate(inSection: section, from: self.fromDate)
        if let firstDateInSection = firstDateInSection {
            let weekdayIndex = firstDateInSection.weekday - 1
            
            let lastDateOfMonth = firstDateInSection.lastDateOfMonth()
            let lastDateWeekdayIndex = lastDateOfMonth.weekday
            
            let count = weekdayIndex + Date.days(of: firstDateInSection) + 7 - lastDateWeekdayIndex
            return count
        }
        return 0
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! SimpleDateCell
        
        let date = Date.date(at: indexPath, from: self.fromDate)
        if let date = date {
            print("\(indexPath): \(date)")
        }
        cell.date = date
        cell.backgroundColor = UIColor.yellow
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let firstDateOfMonth = Date.firstDate(inSection: indexPath.section, from: self.fromDate)
        
        if kind == UICollectionElementKindSectionHeader {
            let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "headerView", for: indexPath) as! CalendarMonthHeaderView
            view.date = firstDateOfMonth
            return view
        } else {
            let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "footerView", for: indexPath) as! CalendarMonthFooterView
            return view
        }
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
        
        let date = Date.date(at: indexPath, from: self.fromDate)
        if let date = date {
            print("selected indexpath: \(indexPath), date: \(date)")
        }
    }
}

extension CalendarView: UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return self.itemSize ?? CGSize(width: 50, height: 50)
    }
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: 100, height: 40)
    }
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: 100, height: 40)
    }
}

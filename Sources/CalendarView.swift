//
//  CalendarView.swift
//  Calendar
//
//  Created by wanggang on 15/11/2016.
//  Copyright © 2016 GUM. All rights reserved.
//

import UIKit

public protocol CalendarDataSource: NSObjectProtocol {
    
    /**
     This method is used for configure the day cell with current `date`.
     Implementers can setup `date` to cell and custom appearance for cell by this method.
     
     - parameter calendarView: self
     - parameter cell: current reuse cell
     - parameter date: current date
     */
    func calendarView(_ calendarView: CalendarView, cell: CalendarDayCell, forDay date: Date?)
    
    /**
     If you registe a section header or footer, you should configure them by them two methods, calendar will provide current `year` and `month` for you.
     
     - parameter calendarView: self
     - parameter monthHeaderView or monthFooterView:  current reuse month header or footer view
     - parameter date: month is present by date, the date is the first date of the month.
     */
    func calendarView(_ calendarView: CalendarView, monthHeaderView: CalendarMonthHeaderView, forMonth date: Date?)
    func calendarView(_ calendarView: CalendarView, monthFooterView: CalendarMonthFooterView, forMonth date: Date?)
    
    /**
     This method is used for configure the cell of the week view with the `weekday`
     
     - parameter calendarView: self
     - parameter weekdayView: the cell contains the header weekday view, like monday
     - parameter weekday: weekday index, from 0~6, sunday is 0, saturday is 6
     */
    func calendarView(_ calendarView: CalendarView, weekdayView: UILabel, forWeekday weekday: Int)
}


public protocol CalendarDelegate: NSObjectProtocol {
    
    /**
     Return whether the date is selectable.
     
     - parameter calendarView: self
     - parameter date: the date will be select
     */
    func calendarView(_ calendarView: CalendarView, shouldSelectDate date: Date) -> Bool
    
    /**
     Correspond the selection event of the calendarView with current `date`.
     
     - parameter calendarView: self
     - parameter date: the selected date
     */
    func calendarView(_ calendarView: CalendarView, didSelectedDate date: Date, of cell: CalendarDayCell)
    
    /**
     ScrollView delegate methods
     */
    func scrollViewDidScroll(_ scrollView: UIScrollView) // any offset changes
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView)
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool)
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) // called on finger up as we are moving
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) // called when scroll view grinds to a halt
}


public extension CalendarDataSource {
    func calendarView(_ calendarView: CalendarView, cell: CalendarDayCell, forDay date: Date?) {}
    func calendarView(_ calendarView: CalendarView, monthHeaderView: CalendarMonthHeaderView, forMonth date: Date?) {}
    func calendarView(_ calendarView: CalendarView, monthFooterView: CalendarMonthFooterView, forMonth date: Date?) {}
    func calendarView(_ calendarView: CalendarView, weekdayView: UILabel, forWeekday weekday: Int) {}
}

public extension CalendarDelegate {
    func calendarView(_ calendarView: CalendarView, shouldSelectDate date: Date) -> Bool { return false }
    func calendarView(_ calendarView: CalendarView, didSelectedDate date: Date, of cell: CalendarDayCell) {}
    func scrollViewDidScroll(_ scrollView: UIScrollView) {}
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {}
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {}
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {}
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {}
}

public typealias CalendarDateCell = UICollectionViewCell

open class CalendarView: UIView {
    
    // MARK: - public properties
    
    open var fromDate: Date = {
        let calendar = Date.gregorianCalendar
        let date = Date()
        var components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
        components.year = 2016
        components.month = 9
        components.day = 14
        return calendar.date(from: components)!
    }()
    open var toDate: Date = {
        let calendar = Date.gregorianCalendar
        let date = Date()
        var components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
        components.year = 2017
        components.month = 3
        components.day = 1
        return calendar.date(from: components)!
    }()
    
    override open var frame: CGRect {
        didSet {
            self.layoutSubviews()
        }
    }
    
    weak open var dataSource: CalendarDataSource?
    
    //weak open var delegate: UITableViewDelegate?
    
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
    
    
    open func dequeueReusableCell(withIdentifier identifier: String, for date: Date) -> CalendarDayCell {
        let indexPath = Date.indexPath(forDate: date, from: self.fromDate)
        return self.collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for:indexPath!) as! CalendarDayCell
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
        return Date.numberOfItems(in: section, from: self.fromDate)
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CalendarDayCell
        cell.cellStyle = .default
        let date = Date.date(at: indexPath, from: self.fromDate)
        cell.date = date
        cell.backgroundColor = UIColor.yellow
        
        self.dataSource?.calendarView(self, cell: cell, forDay: date)
        
        return cell

        //if let date = date {
            //print("\(indexPath): \(date)")
            //cell.isGray = date.lt(self.fromDate, granularity: .day) || date.gt(self.toDate, granularity: .day)
        //}
    }
    
    public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let firstDateOfMonth = Date.firstDate(in: indexPath.section, from: self.fromDate)
        
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

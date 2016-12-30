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
    func calendarView(_ calendarView: CalendarView, cell: DayCell, forDay date: Date?)
    
    /**
     If you registe a section header or footer, you should configure them by them two methods, calendar will provide current `year` and `month` for you.
     
     - parameter calendarView: self
     - parameter monthHeaderView or monthFooterView:  current reuse month header or footer view
     - parameter date: month is present by date, the date is the first date of the month.
     */
    func calendarView(_ calendarView: CalendarView, monthHeaderView: MonthHeaderView, forMonth date: Date?)
    func calendarView(_ calendarView: CalendarView, monthFooterView: MonthFooterView, forMonth date: Date?)
    
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
    func calendarView(_ calendarView: CalendarView, shouldSelectDate date: Date?) -> Bool
    
    /**
     Correspond the selection event of the calendarView with current `date`.
     
     - parameter calendarView: self
     - parameter date: the selected date
     */
    func calendarView(_ calendarView: CalendarView, didSelectedDate date: Date?, of cell: DayCell)
    
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
    func calendarView(_ calendarView: CalendarView, cell: DayCell, forDay date: Date?) {}
    func calendarView(_ calendarView: CalendarView, monthHeaderView: MonthHeaderView, forMonth date: Date?) {}
    func calendarView(_ calendarView: CalendarView, monthFooterView: MonthFooterView, forMonth date: Date?) {}
    func calendarView(_ calendarView: CalendarView, weekdayView: UILabel, forWeekday weekday: Int) {}
}

public extension CalendarDelegate {
    func calendarView(_ calendarView: CalendarView, shouldSelectDate date: Date?) -> Bool { return true }
    func calendarView(_ calendarView: CalendarView, didSelectedDate date: Date?, of cell: DayCell) {}
    func scrollViewDidScroll(_ scrollView: UIScrollView) {}
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {}
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {}
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {}
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {}
}




/// Extention for consts
extension CalendarView {
    
    /// Reusable identifiers for calendar view, like cell, headerView, footerView
    struct Identifier {
        static let dayCell = "cell"
        static let monthHeaderView = "monthHeaderView"
        static let monthFooterView = "monthFooterView"
    }
}

open class CalendarView: UIView {
    
    // MARK: - public properties
    
    open var fromDate: Date = {
        let calendar = Date.gregorianCalendar
        let date = Date()
        var components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
        return calendar.date(from: components)!
    }()
    open var toDate: Date = {
        let calendar = Date.gregorianCalendar
        let date = Date()
        var components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
        components.year = components.year! + 1
        components.month = components.month! - 1
        return calendar.date(from: components)!
    }()
    
    override open var frame: CGRect {
        didSet {
            self.layoutSubviews()
        }
    }
    
    weak open var dataSource: CalendarDataSource?
    weak open var delegate: CalendarDelegate?
    
    //weak open var delegate: UITableViewDelegate?
    
    /// The calendar scroll view content inset
    open var contentInset: UIEdgeInsets = UIEdgeInsets.zero
    
    /// The calendar scroll view content offset
    open var contentOffset: CGPoint?
    
    /// week view height
    open var weekViewHeight: CGFloat = 44.0
    
    /// month header view height
    open var monthHeaderViewHeight: CGFloat = 44.0
    
    /// month footer view height 
    open var monthFooterViewHeight: CGFloat = 0.0
    
    /// cell's width / height
    open var cellAspectRatio: CGFloat = 1.0
    
    /// The spacing from week view to date item
    open var minimumWeekAndDateItemSpacing: CGFloat = 0.0
    
    /// The line spacing
    open var minimumLineSpacing: CGFloat = 1.0 {
        didSet {
            let layout = self.collectionView.collectionViewLayout as? UICollectionViewFlowLayout
            layout?.minimumLineSpacing = minimumLineSpacing
            self.collectionView.collectionViewLayout = layout!
        }
    }
    
    /// The inner item spacing
    open var minimumInteritemSpacing: CGFloat = 1.0 {
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
    public func register(_ cellClass: Swift.AnyClass?) {
        self.collectionView.register(cellClass, forCellWithReuseIdentifier: CalendarView.Identifier.dayCell)
    }
    
    /**
     Rigiste month header view  with a identifier.
     
     - parameter cellClass: `MonthHeaderView` type
     - parameter identifier: unique identifier for header view
     */
    public func register(monthHeader viewClass: Swift.AnyClass?) {
        self.collectionView.register(viewClass, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: CalendarView.Identifier.monthHeaderView)
    }
    
    /**
     Rigiste month footer view with a identifier.
     
     - parameter cellClass: `MonthFooterView` type
     - parameter identifier: unique identifier for footer view
     */
    public func register(monthFooter viewClass: Swift.AnyClass?) {
        self.collectionView.register(viewClass, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: CalendarView.Identifier.monthFooterView)
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
    public func cellAt(date: Date) -> DayCell? {
        guard let indexPath =  Date.indexPath(forDate: date, from: self.fromDate) else {
            return nil
        }
        return self.collectionView.cellForItem(at: indexPath) as? DayCell
    }
    
    /**
     Reload the assigned `dates`.
     
     - parameter dates: assigned dates, array of `Date`
     */
    public func reloadItems(at dates: [Date]) {
        var result: [IndexPath] = []
        for date in dates {
            if let indexPath = Date.indexPath(forDate: date, from: self.fromDate) {
                result.append(indexPath)
            }
        }
        self.collectionView.reloadItems(at: result)
    }
    
    /**
     Reload the assigned `months`.
     
     - parameter months: assigned months, array of `Date`
     */
    public func reloadMonths(at months: [Date]) {
        var result: IndexSet = IndexSet()
        for date in months {
            if let indexPath = Date.indexPath(forDate: date, from: self.fromDate) {
                result.insert(indexPath.section)
            }
        }
        self.collectionView.reloadSections(result)
    }
    
    
    // MARK: - private properties
    fileprivate var itemSize: CGSize?
    
    // MARK: - UI
    private let collectionView: UICollectionView = {
        var layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 1
        layout.minimumInteritemSpacing = 1
        let `self` = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        self.backgroundColor = UIColor.white
        return self
    }()
    
    public let weekView: WeekView = WeekView()
    
    // MARK: - initializers
    public convenience init(fromDate: Date, toDate: Date) {
        self.init(frame: .zero)
        self.fromDate = fromDate
        self.toDate = toDate
    }
    
    public convenience init() {
        self.init(frame: .zero)
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.groupTableViewBackground
        
        self.collectionView.register(DayCell.self, forCellWithReuseIdentifier: CalendarView.Identifier.dayCell)
        self.collectionView.register(MonthHeaderView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: CalendarView.Identifier.monthHeaderView)
        self.collectionView.register(MonthFooterView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: CalendarView.Identifier.monthFooterView)


        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.addSubview(self.collectionView)
        
        self.weekView.delegate = self
        self.addSubview(self.weekView)
    }

    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
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
        self.itemSize = CGSize(width: cellWidth, height: cellWidth / self.cellAspectRatio)
        
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CalendarView.Identifier.dayCell, for: indexPath) as! DayCell
        cell.style = .default
        let date = Date.date(at: indexPath, from: self.fromDate)
        cell.date = date
        
        self.dataSource?.calendarView(self, cell: cell, forDay: date)
        
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let firstDateOfMonth = Date.firstDate(in: indexPath.section, from: self.fromDate)
        
        if kind == UICollectionElementKindSectionHeader {
            let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: CalendarView.Identifier.monthHeaderView, for: indexPath) as! MonthHeaderView
            view.style = .default
            view.date = firstDateOfMonth
            self.dataSource?.calendarView(self, monthHeaderView: view, forMonth: firstDateOfMonth)
            return view
        } else {
            let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: CalendarView.Identifier.monthFooterView, for: indexPath) as! MonthFooterView
            self.dataSource?.calendarView(self, monthFooterView: view, forMonth: firstDateOfMonth)
            return view
        }
    }
}


extension CalendarView: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        let date = Date.date(at: indexPath, from: self.fromDate)
        return self.delegate?.calendarView(self, shouldSelectDate: date) ?? true
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let date = Date.date(at: indexPath, from: self.fromDate)
        if let date = date {
            print("selected indexpath: \(indexPath), date: \(date)")
        }
        if let cell = collectionView.cellForItem(at: indexPath) as? DayCell {
            self.delegate?.calendarView(self, didSelectedDate: date, of: cell)
        }
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.contentOffset = CGPoint(x: scrollView.contentOffset.x + self.contentInset.left, y: scrollView.contentOffset.y + self.contentInset.top)
        self.delegate?.scrollViewDidScroll(scrollView)
    }
    
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.delegate?.scrollViewWillBeginDragging(scrollView)
    }
    
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        self.delegate?.scrollViewDidEndDragging(scrollView, willDecelerate: decelerate)
    }
    
    public func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        self.delegate?.scrollViewWillBeginDragging(scrollView)
    }
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.delegate?.scrollViewDidEndDecelerating(scrollView)
    }
}

extension CalendarView: UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return self.itemSize ?? CGSize(width: 50, height: 50)
    }
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: self.monthHeaderViewHeight)
    }
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: self.monthFooterViewHeight)
    }
}


extension CalendarView: WeekViewDelegate {
    func weekView(_ weekView: WeekView, weekdayView: UILabel, forWeekday weekday: Int) {
        self.dataSource?.calendarView(self, weekdayView: weekdayView, forWeekday: weekday)
    }
}

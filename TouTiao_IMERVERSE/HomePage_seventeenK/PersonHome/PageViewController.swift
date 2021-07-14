//
//  PageViewController.swift
//  TouTiaoSK17.V2
//
//  Created by SeventeenK17 on 2021/6/26.
//

import UIKit
import MJRefresh

class PageViewController: UIViewController,UITableViewDelegate,UIScrollViewDelegate,PageBarDelegate {
    
    var hoverHeight: CGFloat = 0        //滑动到悬停的距离
    var tableConsetHeight: CGFloat = 0       //tableview下拉的距离
    var headView: UIView       //外界传入的可推动的HeaderView
    var hoverView: PageBar       //外界传入的悬停的View
    var subViewCount: UInt = 0   //列表视图个数
    var tableArray: [UITableView] = []
    var visibleTableArray: [UITableView] = []
    var currentIndex: Int = 0
    var needHeaderPan: Bool = true      //是否需要添加头部滑动
    var didScroll: ((_ scrollView:UIScrollView) ->())?
    
    lazy var mainScrollView: UIScrollView = {
        let tempScrollView = UIScrollView.init(frame: self.view.bounds)
        return tempScrollView
    }()
    
    lazy var mjHeader: MJRefreshNormalHeader = {
        let mjHeader = MJRefreshNormalHeader.init()
        mjHeader.refreshingBlock = {
            
        }
        return mjHeader
    }()
    
    lazy var panGes: UIPanGestureRecognizer = {
        let panGes = UIPanGestureRecognizer.init(target: self, action: #selector(panHeaderAction(pan:)))
        return panGes
    }()
    
    deinit {
        
    }
    
    required init(headView: UIView,hoverView: PageBar,subViewCount: UInt) {
        self.headView = headView
        self.hoverView = hoverView
        self.hoverHeight = headView.frame.height
        self.tableConsetHeight = headView.frame.height+hoverView.frame.height
        self.subViewCount = subViewCount
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainScrollView.contentSize = CGSize.init(width: UIScreen.main.bounds.size.width * CGFloat(subViewCount), height: 0)
        mainScrollView.showsVerticalScrollIndicator = false
        mainScrollView.showsHorizontalScrollIndicator = false
        mainScrollView.isPagingEnabled = true
        mainScrollView.bounces = false
        mainScrollView.delegate = self
        mainScrollView.contentInsetAdjustmentBehavior = .never
        self.view.addSubview(mainScrollView)
        
        hoverView.delegate = self
        
//        if #available(iOS 13.0, *) {
//            self.mainScrollView.contentInsetAdjustmentBehavior = .never
//        } else {
//            automaticallyAdjustsScrollViewInsets = false
//        }
                if #available(iOS 13.0, *) {
                    self.mainScrollView.automaticallyAdjustsScrollIndicatorInsets = false
                }
        self.didScroll = scrollViewDidScroll

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if needHeaderPan {
            headView.isUserInteractionEnabled = true
            headView.addGestureRecognizer(panGes)       //添加手势
        } else {
            headView.removeGestureRecognizer(panGes)        //移除手势
        }
    }
    
    func configTableView(subViews: [UITableView], selectIndex: Int) {
        self.tableArray = subViews
        self.currentIndex = selectIndex
        self.hoverView.selectedItemIndex = selectIndex
        setTableViewDetail(view: subViews[selectIndex])
        visibleTableArray.append(subViews[selectIndex])
    }
    
    func setRefreshHeader() {
        
    }
    
    @objc private func panHeaderAction(pan: UIPanGestureRecognizer) {
        
    }
    
    private func setTableViewDetail(view: UITableView) {
        visibleTableArray.append(view)
        self.mainScrollView.addSubview(view)
//        view.delegate = self
        if PageManager.shared.lastConsetY == 0 {
            PageManager.shared.lastConsetY = -tableConsetHeight
        }
        view.frame = CGRect.init(x: mainScrollView.frame.width * CGFloat(currentIndex), y: 0, width: mainScrollView.frame.width, height: mainScrollView.frame.height)
        view.contentInset = UIEdgeInsets.init(top: tableConsetHeight, left: 0, bottom: 44+UIApplication.shared.statusBarFrame.height, right: 0)
        view.setContentOffset(CGPoint.init(x: 0, y: PageManager.shared.lastConsetY), animated: false)
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == tableArray[currentIndex] {
            let consetY = scrollView.contentOffset.y
            let headerConsetY = -(tableConsetHeight+consetY)
            headView.frame.origin.y = headerConsetY
            hoverView.frame.origin.y = hoverHeight+headerConsetY
            
            if hoverView.frame.origin.y <= 0.0 {
                hoverView.frame.origin.y = 0.0
            }
            
            //记录上次ConsetY
            PageManager.shared.lastConsetY = consetY
            
            for item in self.visibleTableArray {
                if item != scrollView {
                    //其他tabelView的上滑不能超过hoverView(悬浮视图)的下方
                    if consetY > -hoverView.frame.height {
                        
                    } else {
                        item.setContentOffset(CGPoint.init(x: 0, y: consetY),animated: false)
                    }
                }
            }
        }
    }
    
    // MARK:scrollViewDelegate
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        if mainScrollView == scrollView {
            let consetX = scrollView.contentOffset.x
            let currentIndex: Int = Int(consetX / UIScreen.main.bounds.width)
            hoverView.selectedItemIndex = currentIndex
            self.currentIndex = currentIndex
            
            guard currentIndex < tableArray.count else {
                return
            }
            
            let tableView = tableArray[currentIndex]
            if tableView.superview == nil {
                setTableViewDetail(view: tableView)
            }
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if mainScrollView == scrollView {
            self.scrollViewDidEndScrollingAnimation(scrollView)
        }
    }
    
    func pageBar(bar: PageBar, willSelectItemAt index: Int) -> Bool {
        return true
    }
    
    func pageBar(bar: PageBar, didSelectedItemAt index: Int, isReload: Bool) {
        mainScrollView.setContentOffset(CGPoint.init(x: UIScreen.main.bounds.width * CGFloat(index), y: 0), animated: true)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

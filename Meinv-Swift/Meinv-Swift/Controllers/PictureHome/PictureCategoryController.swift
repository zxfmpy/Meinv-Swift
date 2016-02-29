//
//  PictureCategoryController.swift
//  Meinv-Swift
//
//  Created by Lorwy on 16/2/25.
//  Copyright © 2016年 Lorwy. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import Kanna
import JGProgressHUD
import SDWebImage
import SnapKit
import MJRefresh
import CHTCollectionViewWaterfallLayout

private let pictureHomeImageCellIdentifier = "pictureHomeImageCellIdentifier"
private let imageBaseUrl = "http://www.dbmeinv.com/dbgroup/rank.htm?pager_offset="
private let pageBaseUrl = "http://www.dbmeinv.com/dbgroup/show.htm?cid="

class PictureCategoryController: MNBaseController, TopMenuDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource, CHTCollectionViewDelegateWaterfallLayout {
    
    var collectionView: UICollectionView!
    var znMenuView:ZNTopMenuView!
    var photos = NSMutableOrderedSet()  //一个有序的可变集合
    var photosBig = NSMutableOrderedSet()
    
    var populatingPhotos = false   // 是否在获取图片
    var currentPage = 1
    var isGot = false // 是否已经获取到数据
    
    var currentType:PageType = .daxiong
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "豆瓣美女"
        
        initTopView()
        setupCollectionView()
        configureRefresh()
        getPageUrl()
        populatePhotos()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setToolbarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.toolbarHidden = true
    }
    
    func getPageUrl()-> String {
        return pageBaseUrl + currentType.rawValue + "&pager_offset=" + "\(currentPage)"
    }
    
    func initTopView() {
        //设置menu的高度和位置，在navigationbar下面
        let navBarHeight = self.navigationController?.navigationBar.frame.height ?? 0.0
        
        //设置menu的高度和位置，在navigationbar下面
        znMenuView = ZNTopMenuView(frame: CGRectMake(0, navBarHeight + topViewHeight - 10, kScreenSize.width, topViewHeight))
        self.view.addSubview(znMenuView)
        znMenuView.bgColor = UIColor.whiteColor()
        znMenuView.lineColor = UIColor.grayColor()
        znMenuView.delegate = self
        
        //设置显示的类别
        znMenuView.titles = ["大胸妹","小翘臀","黑丝袜","美腿控","有颜值","大杂烩"];
        
        //关闭scrolltotop,不然点击status bar不会返回第一页
        znMenuView.setScrollToTop(false)
    }
    
    func setupCollectionView() {
        let layout = CHTCollectionViewWaterfallLayout()
        layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10)
        
        self.collectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: layout)
        self.view.addSubview(self.collectionView)
        self.collectionView.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(self.znMenuView.snp_bottom)
            make.left.equalTo(self.view.snp_left)
            make.right.equalTo(self.view.snp_right)
            make.bottom.equalTo(self.view.snp_bottom)
        }
        self.collectionView.delegate = self;
        self.collectionView.dataSource = self;
        self.view.bringSubviewToFront(self.znMenuView)
        
        
        self.collectionView?.backgroundColor = UIColor.whiteColor()
        self.collectionView?.scrollsToTop = true
        self.collectionView?.snp_makeConstraints(closure: { (make) -> Void in
            make.edges.equalTo(self.view).inset(UIEdgeInsetsMake(0, 10, 0, 10))
        })
    
        self.collectionView!.registerClass(PictureHomeImageCell.self, forCellWithReuseIdentifier: pictureHomeImageCellIdentifier)
    }
    
    // MARK: - TopMenuDelegate 代理方法，点击触发
    func topMenuDidChangedToIndex(index: Int) {
        self.navigationItem.title = self.znMenuView.titles[index] as String
        currentType = PhotoUtil.selectTypeByNumber(index)
        
        photos.removeAllObjects()
        photosBig.removeAllObjects()
        //清楚所有图片，设置为第一页，刷新数据
        self.currentPage = 1
        self.collectionView?.reloadData()
        
        populatePhotos()
    }
    
    func configureRefresh() {
        self.collectionView?.mj_header = MJRefreshNormalHeader(refreshingBlock: { () -> Void in
            print("header")
            self.collectionView?.mj_header.endRefreshing()
        })
        self.collectionView?.mj_footer = MJRefreshAutoFooter(refreshingBlock: { () -> Void in
            print("footer")
            self.populatePhotos()
            self.collectionView?.mj_footer.endRefreshing()
        })
    }
    
    // 下拉刷新回掉函数
    func handleRefresh() {
        photos.removeAllObjects()
        self.currentPage = 1;
        self.collectionView?.reloadData()
        
    }
    
    //MARK - 网络获取信息
    func populatePhotos() {
        if populatingPhotos { //正在获取，则返回
            print("return back")
            return
        }
        
        // 标记正在获取，其他线程来则返回
        populatingPhotos = true
        let pageUrl = getPageUrl()
        Alamofire.request(.GET, pageUrl).responseString(completionHandler: { (request, response, result) -> Void in
            //
            let isSuccess = result.isSuccess
            let html = result.value
            let HUD = JGProgressHUD(style: JGProgressHUDStyle.Light)
            
            if isSuccess == true {
                //转菊花，开始解析
                HUD.textLabel.text = "靓图即将呈现"
                HUD.showInView(self.view,animated: true)
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0),{ () -> Void in
                    //用photos保存临时数据
                    var urls = [String]()
                    //用kanna解析html数据
                    if let doc = Kanna.HTML(html: html!, encoding: NSUTF8StringEncoding) {
                        CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingASCII)
                        let lastItem = self.photos.count
                        //解析imageurl
                        for node in doc.css("img") {
                            if self.checkImageUrl(node["src"]) {
                                urls.append(node["src"]!)
                                self.isGot = true
                            }
                        }
                        if self.isGot {
                            for item:String in urls {
                                let itemInfo:PhotoInfo = PhotoInfo.photo(item)
                                self.photos.addObject(itemInfo)
                            }
                            self.transformUrl(urls)
                        }
                        
                        let indexPaths = (lastItem..<self.photos.count).map({
                            NSIndexPath(forItem: $0, inSection: 0)
                        })
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            self.collectionView!.insertItemsAtIndexPaths(indexPaths)
                        })
                        if self.isGot {
                            self.currentPage++
                            self.isGot = false
                        }
                    }
                })
            }else {
                HUD.textLabel.text = "网络有问题，请检查网络"
                HUD.indicatorView = JGProgressHUDIndicatorView()
                HUD.showInView(self.view, animated: true)
                HUD.dismissAfterDelay(1.0, animated: true)
            }
            HUD.dismiss()
            self.populatingPhotos = false;
        })
    }
    
    // 检查image url，必须符合某种给定规则
    func checkImageUrl(imageUrl: String?) -> Bool {
        if imageUrl == nil {
            return false
        }
        return true
    }
    
    func transformUrl(urls: [String]) {
        for url in urls {
            let urlBig = url.stringByReplacingOccurrencesOfString("bmiddle", withString: "large")
            print(urlBig)
            photosBig.addObject(urlBig)
        }
    }
    
    //MARK: - UICollectionViewDelegateFlowLayout
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: self.view.frame.width, height: topViewHeight + 10)
    }
    
    //MARK: - collectionView Delegate
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.photos.count
    }
    
    // 点击查看大图
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        var browser:PhotoBrowserView
        
        browser = PhotoBrowserView.initWithPhotos(withUrlArray: self.photosBig.array)
        browser.sourceType = SourceType.REMOTE
        browser.index = indexPath.row
        browser.show()
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(pictureHomeImageCellIdentifier, forIndexPath: indexPath) as! PictureHomeImageCell
        let model: PhotoInfo = photos.objectAtIndex(indexPath.row) as! PhotoInfo;
        let imageUrl = NSURL(string: model.imageUrl)
        cell.imageView.image = nil
        cell.imageView.sd_setImageWithURL(imageUrl) { (image:UIImage?, error:NSError?, cacheType:SDImageCacheType, url:NSURL?) -> Void in
            if image != nil {
                if !CGSizeEqualToSize(model.imageSize, image!.size) {
                    model.imageSize = image!.size
                    collectionView.reloadItemsAtIndexPaths([indexPath])
                }
            }
        }
        return cell
    }
    
    // MARK: - CHTCollectionViewDelegateWaterfallLayout
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let model: PhotoInfo = photos.objectAtIndex(indexPath.row) as! PhotoInfo;
        if !CGSizeEqualToSize(model.imageSize, CGSizeZero) {
            return model.imageSize
        }
        return CGSizeMake(150, 150)
    }
}

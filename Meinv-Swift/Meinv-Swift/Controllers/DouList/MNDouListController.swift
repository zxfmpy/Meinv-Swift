//
//  MNDouListController.swift
//  Meinv-Swift
//
//  Created by Lorwy on 16/2/29.
//  Copyright © 2016年 Lorwy. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper
import JGProgressHUD


class MNDouListController: MNBaseController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var douListTableView: UITableView!
    var doulists = NSMutableOrderedSet()
    var parameters = [  "alt":"json",
                        "apikey":"0ab215a8b1977939201640fa14c66bab",
                        "count":"20",
                        "douban_udid":"716b70e03cbaa3582311b52ee5ffc3d81def117c",
                        "event_loc_id":"118318",
                        "latitude":"30.58823311638634",
                        "loc_id":"118318",
                        "longitude":"104.0535214038774",
                        "start":"0",
                        "udid":"c45ad87edbe8235ad5abf35e48dcb79eb590e63d",
                        "version":"3.5.0"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "精品豆列"
        self.getDouLists()
    }
    
    func getDouLists() {
        let HUD = JGProgressHUD(style: JGProgressHUDStyle.Light)
        HUD.showInView(self.view,animated: true)
        let url:String? = "https://frodo.douban.com/api/v2/user/81012634/following_doulists"
        Alamofire.request(Method.GET, url!, parameters: parameters, encoding: ParameterEncoding.URL, headers: ["User-Agent":"api-client/0.1.3 com.douban.frodo/3.5.0 iOS/9.2.1 iPhone7,2"]).responseObject { (doulist:MNDouListsResponse?, error:ErrorType?) -> Void in
            if error == nil {
                self.doulists.addObjectsFromArray(doulist!.doulists!)
                self.douListTableView?.reloadData()
            }else{
                HUD.textLabel.text = "网络有问题，请检查网络"
                HUD.indicatorView = JGProgressHUDIndicatorView()
                HUD.showInView(self.view, animated: true)
                HUD.dismissAfterDelay(1.0, animated: true)
            }
            HUD.dismiss()
        }
    }
    
    // MARK: - UITableViewDataSource
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return doulists.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: MNDouListCell = tableView.dequeueReusableCellWithIdentifier("MNDouListCellIdentifier", forIndexPath: indexPath) as! MNDouListCell
        cell.modelItem = doulists.objectAtIndex(indexPath.section) as? MNDouListItem
        cell.selectionStyle = .None
        return cell
    }
    
    // MARK: - UITableViewDelegate
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 1
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView(frame: CGRectZero)
    }
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "kToDouListItemVCSegue" {
            let cell = sender as! MNDouListCell
            segue.destinationViewController.navigationItem.title = cell.modelItem.title
        }
    }

}

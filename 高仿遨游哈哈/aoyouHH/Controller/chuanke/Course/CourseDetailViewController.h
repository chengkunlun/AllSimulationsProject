//
//  CourseDetailViewController.h
//  aoyouHH
//  课程详情页
//  Created by jinzelu on 15/5/21.
//  Copyright (c) 2015年 jinzelu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FocusModel.h"

@interface CourseDetailViewController : UIViewController

@property(nonatomic, strong) UITableView *tableView;

/**
 *  上一个界面传过来的参数
 */
@property(nonatomic, strong) FocusModel *focus;


@end

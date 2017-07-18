//
//  JokeDetailViewController.h
//  aoyouHH
//
//  Created by jinzelu on 15/4/24.
//  Copyright (c) 2015年 jinzelu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JokeModel.h"

@interface JokeDetailViewController : UIViewController

/**
 *  用于接收上一个界面传来的数据
 */
@property(nonatomic, strong) JokeModel *joke;

@property(nonatomic, strong) UITableView *tableView;

+(JokeDetailViewController *)shareManeger;

-(void)setData:(JokeModel *)joke;

@end

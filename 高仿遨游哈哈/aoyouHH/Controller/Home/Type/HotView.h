//
//  HotView.h
//  aoyouHH
//
//  Created by jinzelu on 15/4/21.
//  Copyright (c) 2015年 jinzelu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JokeModel.h"

//1.
@protocol HotViewDelegate <NSObject>

//@required
-(void)didSelectImage:(NSMutableArray *)imageArr currentIndex:(NSInteger)currentIndex;
-(void)didselectRowAtIndexPath:(NSIndexPath *)indexPath jokeData:(JokeModel *)joke;

@end

@interface HotView : UIView

//2.
@property(nonatomic, assign) id<HotViewDelegate> delegate;

@property(nonatomic, strong) UITableView *tableView;
/**
 *  图片大小类型，默认的时normal
 */
@property(nonatomic, strong) NSString *imgType;

@end

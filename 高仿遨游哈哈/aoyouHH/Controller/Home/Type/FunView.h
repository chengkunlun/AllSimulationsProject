//
//  FunView.h
//  aoyouHH
//
//  Created by jinzelu on 15/4/21.
//  Copyright (c) 2015年 jinzelu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JokeModel.h"

@protocol FunViewDelegate <NSObject>

//@required
-(void)didSelectImageFunView:(NSMutableArray *)imageArr currentIndex:(NSInteger)currentIndex;
-(void)didSelectRowAtIndexPathFunView:(NSIndexPath *)indexPath jokeData:(JokeModel *)joke;

@end

@interface FunView : UIView

@property(nonatomic, assign) id<FunViewDelegate> delegate;
@property(nonatomic, strong) UITableView *tableView;

@end

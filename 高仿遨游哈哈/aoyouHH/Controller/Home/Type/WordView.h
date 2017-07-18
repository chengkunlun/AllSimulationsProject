//
//  WordView.h
//  aoyouHH
//
//  Created by jinzelu on 15/4/21.
//  Copyright (c) 2015年 jinzelu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JokeModel.h"

@protocol WordViewDelegate <NSObject>

//@required
-(void)didSelectImageWordView:(NSMutableArray *)imageArr currentIndex:(NSInteger)currentIndex;
-(void)didSelectRowAtIndexPathWordView:(NSIndexPath *)indexPath jokeData:(JokeModel *)joke;

@end

@interface WordView : UIView


@property(nonatomic, assign) id<WordViewDelegate> delegate;
@property(nonatomic, strong) UITableView *tableView;

@end

//
//  NewView.h
//  aoyouHH
//
//  Created by jinzelu on 15/4/21.
//  Copyright (c) 2015年 jinzelu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JokeModel.h"

//1.
@protocol NewViewDelegate <NSObject>

//@required
-(void)didSelectImageNewView:(NSMutableArray *)imageArr currentIndex:(NSInteger)currentIndex;
-(void)didSelectRowAtIndexPathNewView:(NSIndexPath *)indexPath jokeData:(JokeModel *)joke;

@end

@interface NewView : UIView

@property(nonatomic, assign) id<NewViewDelegate> delegate;
@property(nonatomic, strong) UITableView *tableView;

@end

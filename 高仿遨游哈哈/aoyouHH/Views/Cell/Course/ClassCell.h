//
//  ClassCell.h
//  aoyouHH
//
//  Created by jinzelu on 15/5/21.
//  Copyright (c) 2015年 jinzelu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ClassModel.h"

@interface ClassCell : UITableViewCell

@property(nonatomic, strong) UIView *lineView;
@property(nonatomic, strong) UILabel *titleLable;
@property(nonatomic, strong) UILabel *timeLabel;


@property(nonatomic, strong) ClassModel *classModel;


@end

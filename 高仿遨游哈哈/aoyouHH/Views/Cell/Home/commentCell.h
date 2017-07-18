//
//  commentCell.h
//  aoyouHH
//
//  Created by jinzelu on 15/5/4.
//  Copyright (c) 2015年 jinzelu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface commentCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *userImg;

@property (strong, nonatomic) IBOutlet UILabel *userNameLable;

@property (strong, nonatomic) IBOutlet UILabel *timeLabel;

@property (strong, nonatomic) IBOutlet UILabel *commentLabel;



@end

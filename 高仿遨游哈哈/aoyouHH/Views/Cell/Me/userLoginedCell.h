//
//  userLoginedCell.h
//  aoyouHH
//
//  Created by jinzelu on 15/4/29.
//  Copyright (c) 2015年 jinzelu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface userLoginedCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *userImg;

@property (strong, nonatomic) IBOutlet UILabel *userNameLabel;

@property (strong, nonatomic) IBOutlet UILabel *levelLabel;
@property (strong, nonatomic) IBOutlet UILabel *scoreLabel;

@end

//
//  ReAttentionCell.h
//  aoyouHH
//
//  Created by jinzelu on 15/4/21.
//  Copyright (c) 2015年 jinzelu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReAttentionCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;

@property (strong, nonatomic) IBOutlet UILabel *numberLable;

@property (strong, nonatomic) IBOutlet UIButton *attentionBtn;

- (IBAction)OnAttentionBtn:(id)sender;

@end

//
//  commentCell.m
//  aoyouHH
//
//  Created by jinzelu on 15/5/4.
//  Copyright (c) 2015年 jinzelu. All rights reserved.
//

#import "commentCell.h"

@implementation commentCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //
        NSLog(@"initWithStyle");
    }
    return self;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

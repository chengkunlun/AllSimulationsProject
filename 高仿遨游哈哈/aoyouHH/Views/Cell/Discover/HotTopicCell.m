//
//  HotTopicCell.m
//  aoyouHH
//
//  Created by jinzelu on 15/4/24.
//  Copyright (c) 2015年 jinzelu. All rights reserved.
//

#import "HotTopicCell.h"

@implementation HotTopicCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //
        [self initViews];
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

-(void)initViews{
    //标题
    self.contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 10, 100, 20)];
    self.contentLabel.font = [UIFont systemFontOfSize:15];
    self.contentLabel.text = @"标题";
    [self addSubview:self.contentLabel];
    //图片
    self.hotImg = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.contentLabel.frame)+5, 10, 20, 20)];
    self.hotImg.image = [UIImage imageNamed:@"topic_hot_flag_img"];
    [self addSubview:self.hotImg];
    //数字
    self.numberLable = [[UILabel alloc] initWithFrame:CGRectMake(screen_width-78, 10, 70, 20)];
    self.numberLable.font = [UIFont systemFontOfSize:14];
    self.numberLable.textColor = [UIColor grayColor];
    self.numberLable.text = @"13123";
    self.numberLable.textAlignment = NSTextAlignmentRight;
    [self addSubview:self.numberLable];
}

-(void)setData:(TuijianAttModel *)tuijianArr{
    self.tuijianArr = tuijianArr;
    if ([self.tuijianArr.hot intValue] == 0) {
        //
        self.hotImg.hidden = YES;
    }else{
        self.hotImg.hidden = NO;
    }
    self.contentLabel.text = self.tuijianArr.content;
    self.numberLable.text = [NSString stringWithFormat:@"%@",self.tuijianArr.number];
    
    [self resizeHeight];
}

-(void)resizeHeight{
    CGSize contentSize = [self.tuijianArr.content sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(screen_width-16, 20) lineBreakMode:UILineBreakModeWordWrap];
    self.contentLabel.frame = CGRectMake(8, 10, contentSize.width, 20);
    self.hotImg.frame = CGRectMake(CGRectGetMaxX(self.contentLabel.frame)+5, 10, 20, 20);
}

@end

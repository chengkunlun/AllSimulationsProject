//
//  JokeCell.m
//  aoyouHH
//
//  Created by jinzelu on 15/4/23.
//  Copyright (c) 2015年 jinzelu. All rights reserved.
//

#import "JokeCell.h"
#import "UIImageView+WebCache.h"
#import "NetworkSingleton.h"

@interface JokeCell ()
{
    NSInteger _marginTop;
    CGFloat _picWidth;
    CGFloat _picHeight;
}

@end

@implementation JokeCell

//执行
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //
//        NSLog(@"1111");
        _marginTop = 5;
        self.joke = [[JokeModel alloc] init];
        if (self.imgType == nil) {
            self.imgType = @"normal";
        }else{
            self.imgType = @"big";
        }
        NSLog(@"图片类型：%@",self.imgType);
        [self initViews];
    }
    return self;
}
//不执行-(void)init;

-(void)initViews{
    self.backgroundColor = RGB(241, 241, 241);
    //背景
    self.backView = [[UIView alloc] initWithFrame:CGRectMake(0, _marginTop, screen_width, 150)];
    self.backView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.backView];
    //头像
    self.userImg = [[UIImageView alloc] initWithFrame:CGRectMake(8, _marginTop, 30, 30)];
    self.userImg.image = [UIImage imageNamed:@"content_avatar_img"];
    self.userImg.layer.cornerRadius = 5;
    self.userImg.layer.masksToBounds = YES;
    [self.backView addSubview:self.userImg];
    
    //用户名
    self.userNameLable = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.userImg.frame)+5, _marginTop, 150, 15)];
    self.userNameLable.font = [UIFont systemFontOfSize:12];
    self.userNameLable.text = @"用户名";
    [self.backView addSubview:self.userNameLable];
    //时间
    self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.userImg.frame)+5, CGRectGetMaxY(self.userNameLable.frame), 150, 15)];
    self.timeLabel.font = [UIFont systemFontOfSize:12];
    self.timeLabel.textColor = [UIColor grayColor];
    self.timeLabel.text = @"2015-04-23 14:47:27";
    [self.backView addSubview:self.timeLabel];
    //topic类型
    self.topicBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.topicBtn.frame = CGRectMake(screen_width-70, _marginTop*2, 65, 20);
    [self.topicBtn setTitle:@"类型" forState:UIControlStateNormal];
    [self.topicBtn setTitleColor:navigationBarColor forState:UIControlStateNormal];
    [self.topicBtn setBackgroundColor:RGB(155, 219, 167)];
    [self.topicBtn setFont:[UIFont systemFontOfSize:13]];
    self.topicBtn.layer.borderWidth = 1;
    self.topicBtn.layer.borderColor = [[UIColor colorWithRed:56/255.0 green:184/255.0 blue:80/255.0 alpha:1.0] CGColor];
    self.topicBtn.layer.cornerRadius = 10;
    [self.backView addSubview:self.topicBtn];
    //内容
    self.contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, CGRectGetMaxY(self.userImg.frame)+_marginTop, screen_width-8*2, 100)];
//    self.contentLabel.layer.borderWidth = 1;
    self.contentLabel.numberOfLines = 0;
    self.contentLabel.font = [UIFont systemFontOfSize:15];
    self.contentLabel.lineBreakMode = UILineBreakModeTailTruncation;
    [self.backView addSubview:self.contentLabel];
    //富文本内容
    self.contentRCLabel = [[RCLabel alloc] initWithFrame:CGRectMake(8, CGRectGetMaxY(self.userImg.frame)+_marginTop, screen_width-8*2, 100)];
//    self.contentRCLabel.lineBreakMode = NSLineBreakByTruncatingTail;
//    [self.backView addSubview:self.contentRCLabel];
    
    
    //图片
    self.picImg = [[UIImageView alloc] initWithFrame:CGRectMake(8, CGRectGetMaxY(self.contentLabel.frame)+_marginTop, 0, 0)];
    [self.backView addSubview:self.picImg];
    
    CGFloat picImgMaxY = CGRectGetMaxY(self.picImg.frame);
    //横线
    self.lineView = [[UIView alloc] initWithFrame:CGRectMake(0, picImgMaxY+_marginTop-0.5, screen_width, 0.5)];
    self.lineView.backgroundColor = RGB(241, 241, 241);
    [self.backView addSubview:self.lineView];
    //绿
    self.greenBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.greenBtn.frame = CGRectMake(0, picImgMaxY+_marginTop, screen_width/4, 25);
    [self.greenBtn setImage:[UIImage imageNamed:@"item_green_normal"] forState:UIControlStateNormal];
    [self.greenBtn setImage:[UIImage imageNamed:@"item_green_pressed"] forState:UIControlStateSelected];
    [self.greenBtn setImage:[UIImage imageNamed:@"item_green_disable"] forState:UIControlStateDisabled];
    [self.greenBtn setTitle:@"69" forState:UIControlStateNormal];
    [self.greenBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.greenBtn setFont:[UIFont systemFontOfSize:14]];
    [self.backView addSubview:self.greenBtn];
    //分割线
    self.vlineView1 = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.greenBtn.frame), CGRectGetMaxY(self.lineView.frame)+5, 0.5, 20)];
    self.vlineView1.backgroundColor = RGB(241, 241, 241);
    [self.backView addSubview:self.vlineView1];
    //红
    self.redBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.redBtn.frame = CGRectMake(screen_width/4, picImgMaxY+_marginTop, screen_width/4, 25);
    [self.redBtn setImage:[UIImage imageNamed:@"item_red_normal"] forState:UIControlStateNormal];
    [self.redBtn setImage:[UIImage imageNamed:@"item_red_pressed"] forState:UIControlStateSelected];
    [self.redBtn setImage:[UIImage imageNamed:@"item_red_disable"] forState:UIControlStateDisabled];
    [self.redBtn setTitle:@"69" forState:UIControlStateNormal];
    [self.redBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.redBtn setFont:[UIFont systemFontOfSize:14]];
    [self.backView addSubview:self.redBtn];
    //分割线
    self.vlineView2 = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.redBtn.frame), CGRectGetMaxY(self.lineView.frame)+5, 0.5, 20)];
    self.vlineView2.backgroundColor = RGB(241, 241, 241);
    [self.backView addSubview:self.vlineView2];
    //评论
    self.commentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.commentBtn.frame = CGRectMake(screen_width*2/4, picImgMaxY+_marginTop, screen_width/4, 25);
    [self.commentBtn setImage:[UIImage imageNamed:@"item_comment"] forState:UIControlStateNormal];
    [self.commentBtn setImage:[UIImage imageNamed:@"item_comment"] forState:UIControlStateSelected];
    [self.commentBtn setImage:[UIImage imageNamed:@"item_comment"] forState:UIControlStateDisabled];
    [self.backView addSubview:self.commentBtn];
    //分割线
    self.vlineView3 = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.commentBtn.frame), CGRectGetMaxY(self.lineView.frame)+5, 0.5, 20)];
    self.vlineView3.backgroundColor = RGB(241, 241, 241);
    [self.backView addSubview:self.vlineView3];
    //分享
    self.shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.shareBtn.frame = CGRectMake(screen_width*3/4, picImgMaxY+_marginTop, screen_width/4, 25);
    [self.shareBtn setImage:[UIImage imageNamed:@"share_btn_img"] forState:UIControlStateNormal];
    [self.shareBtn setImage:[UIImage imageNamed:@"share_btn_img"] forState:UIControlStateSelected];
    [self.shareBtn setImage:[UIImage imageNamed:@"share_btn_img"] forState:UIControlStateDisabled];
    [self.backView addSubview:self.shareBtn];
    
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setJokeData:(JokeModel *)joke{
    
    NSLog(@"2222图片类型：%@",self.imgType);
    self.joke = joke;
    self.userNameLable.text = joke.user_name;
    self.timeLabel.text = joke.time;
    [self.userImg sd_setImageWithURL:[NSURL URLWithString:self.joke.user_pic] placeholderImage:[UIImage imageNamed:@"content_avatar_img"]];
    NSString *contentStr = [self.joke.content stringByReplacingOccurrencesOfString:@"<br />" withString:@""];
//    NSString *contentStr = self.joke.content;
//    NSString *contentStyleStr = [NSString stringWithFormat:@"<font size=15 color='#3EAFAD'>测</font>%@",contentStr];
//    RTLabelComponentsStructure *componentesDS = [RCLabel extractTextStyle:contentStyleStr];
//    self.contentRCLabel.componentsAndPlainText = componentesDS;
    
    
    
//    self.contentLabel.text = [NSString stringWithFormat:@"<font size=15 color='#3EAFAD'>测试字体颜色</font>%@",contentStr];    
    self.contentLabel.text = [self.joke.content stringByReplacingOccurrencesOfString:@"<br />" withString:@""];
    if (self.joke.pic!=nil) {
//        NSString *urlStr = [NSString stringWithFormat:@"%@%@%@/%@", URL_IMAGE, joke.pic.path,self.imgType, joke.pic.name];
//        NSURL *url = [NSURL URLWithString:urlStr];
//        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
//        NSLog(@"width:%f,height:%f",image.size.width,image.size.height);
    }
    if ([self.joke.topic_content isEqualToString:@""]) {
        self.topicBtn.hidden = YES;
    }else{
        self.topicBtn.hidden = NO;
    }
    [self.topicBtn setTitle:self.joke.topic_content forState:UIControlStateNormal];
    [self.greenBtn setTitle:[NSString stringWithFormat:@"%@",self.joke.good] forState:UIControlStateNormal];
    [self.redBtn setTitle:[NSString stringWithFormat:@"%@",self.joke.bad] forState:UIControlStateNormal];

    
    [self resizeHeight];
}

-(void)resizeHeight{
//    self.joke.content
    CGSize contentSize = {0,0};
//    CGSize optimalSize = [self.contentRCLabel optimumSize];
//    CGFloat contentRCLabelHeight = 0;
    if(self.contentType == 0){//显示5行
        contentSize = [self.joke.content sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(screen_width-8*2, 100) lineBreakMode:UILineBreakModeTailTruncation];
//        if (optimalSize.height>100) {
//            self.contentRCLabel.frame = CGRectMake(8, CGRectGetMaxY(self.userImg.frame)+_marginTop, screen_width-8*2, 100);
//            contentRCLabelHeight = 100;
//        }else{
//            self.contentRCLabel.frame = CGRectMake(8, CGRectGetMaxY(self.userImg.frame)+_marginTop, screen_width-8*2, optimalSize.height);
//            contentRCLabelHeight = optimalSize.height;
//        }
    }else{//全部显示
        contentSize = [self.joke.content sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(screen_width-8*2, 1000) lineBreakMode:UILineBreakModeTailTruncation];
//        self.contentRCLabel.frame = CGRectMake(8, CGRectGetMaxY(self.userImg.frame)+_marginTop, screen_width-8*2, optimalSize.height);
//        contentRCLabelHeight = optimalSize.height;
    }
    
    self.contentLabel.frame = CGRectMake(8, CGRectGetMaxY(self.userImg.frame)+_marginTop, screen_width-8*2, contentSize.height);
    
    
    
    
    if (self.joke.pic!=nil) {
        NSString *urlStr = [NSString stringWithFormat:@"%@%@%@/%@", URL_IMAGE, self.joke.pic.path,self.imgType, self.joke.pic.name];
        NSLog(@"图片宽高：%d,%d",[self.joke.pic.width intValue],[self.joke.pic.height intValue]);
        NSURL *url = [NSURL URLWithString:urlStr];
//        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
        self.picImg.frame = CGRectMake(8, CGRectGetMaxY(self.contentLabel.frame)+_marginTop, self.joke.pic.imageWidth, self.joke.pic.imageHeight);
//        self.picImg.frame = CGRectMake(8, CGRectGetMaxY(self.contentLabel.frame)+_marginTop, image.size.width, image.size.height);
//        self.picImg.frame = CGRectMake(8, CGRectGetMaxY(self.contentRCLabel.frame)+_marginTop, image.size.width, image.size.height);
//        self.picImg.frame = CGRectMake(8, contentRCLabelHeight+_marginTop, image.size.width, image.size.height);
        [self.picImg sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"comment_empty_img"]];
    }else{
        self.picImg.frame = CGRectMake(8, CGRectGetMaxY(self.contentLabel.frame)+_marginTop, 0, 0);
//        self.picImg.frame = CGRectMake(8, CGRectGetMaxY(self.contentRCLabel.frame)+_marginTop, 0, 0);
//        self.picImg.frame = CGRectMake(8, contentRCLabelHeight+_marginTop, 0, 0);
    }
    CGFloat picImgMaxY = CGRectGetMaxY(self.picImg.frame);
    self.lineView.frame = CGRectMake(0, picImgMaxY+_marginTop-0.5, screen_width, 0.5);
    self.greenBtn.frame = CGRectMake(0, picImgMaxY+_marginTop, screen_width/4, 30);
    self.redBtn.frame = CGRectMake(screen_width/4, picImgMaxY+_marginTop, screen_width/4, 30);
    self.commentBtn.frame = CGRectMake(screen_width*2/4,picImgMaxY+_marginTop, screen_width/4, 30);
    self.shareBtn.frame = CGRectMake(screen_width*3/4, picImgMaxY+_marginTop, screen_width/4, 30);
    //分割线
    self.vlineView1.frame = CGRectMake(CGRectGetMaxX(self.greenBtn.frame)-1, CGRectGetMaxY(self.lineView.frame)+5, 1, 20);
    self.vlineView2.frame = CGRectMake(CGRectGetMaxX(self.redBtn.frame)-1, CGRectGetMaxY(self.lineView.frame)+5, 1, 20);
    self.vlineView3.frame = CGRectMake(CGRectGetMaxX(self.commentBtn.frame)-1, CGRectGetMaxY(self.lineView.frame)+5, 1, 20);
    
    self.backView.frame = CGRectMake(0, _marginTop, screen_width, CGRectGetMaxY(self.greenBtn.frame));
    
    self.cellHeight = CGRectGetMaxY(self.backView.frame);
}

-(void)layoutSubviews{
    NSLog(@"layoutSubviews");
}

@end

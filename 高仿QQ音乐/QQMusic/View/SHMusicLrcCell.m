
#import "SHMusicLrcCell.h"
@interface SHMusicLrcCell()
@end

@implementation SHMusicLrcCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
    }
    return self;
}
//自定义cell，设置label属性
- (void)setMessage:(SHLrcLine *)message{
    self.lrcLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.contentView.frame.size.width, self.contentView.frame.size.height)];
    self.lrcLabel.font = [UIFont systemFontOfSize:17];
    self.lrcLabel.text = message.words;
    self.lrcLabel.textColor = [UIColor purpleColor];
    self.lrcLabel.textAlignment = NSTextAlignmentCenter;
    self.lrcLabel.textColor = [UIColor lightTextColor];
    [self.contentView addSubview:self.lrcLabel];
}

- (void)settingCurrentTextColor{
    self.lrcLabel.textColor = [UIColor redColor];
    self.lrcLabel.font = [UIFont systemFontOfSize:25];
}
- (void)settingLastTextColor{
    self.lrcLabel.textColor = [UIColor lightTextColor];
    self.lrcLabel.font = [UIFont systemFontOfSize:17];
}

@end

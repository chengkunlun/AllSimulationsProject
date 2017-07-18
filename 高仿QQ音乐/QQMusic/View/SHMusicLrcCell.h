
#import <UIKit/UIKit.h>
#import "SHLrcLine.h"

@interface SHMusicLrcCell : UITableViewCell
/**
 * <#name#>
 */
@property(nonatomic,strong) SHLrcLine *message;

@property(nonatomic,strong) UILabel *lrcLabel;


- (void)settingCurrentTextColor;
- (void)settingLastTextColor;
@end

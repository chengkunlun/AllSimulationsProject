
#import <UIKit/UIKit.h>

@interface SHPlayingViewController : UIViewController
@property(nonatomic,strong) NSArray *musics;
@property(nonatomic,assign)NSInteger index;;
- (void)show:(NSIndexPath *)indexPath;
@end

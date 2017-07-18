

#import "SHOnLineMusciActivity.h"
#define mainFrame [UIScreen mainScreen].bounds
@implementation SHOnLineMusciActivity
+ (UIActivityIndicatorView *)createActivityOnLineMusicView{
    
    UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    CGFloat X = mainFrame.size.width/2;
    CGFloat Y = mainFrame.size.height/2;
    activityView.frame = CGRectMake(X, Y - 100, 10, 10);
    return activityView;
}
@end

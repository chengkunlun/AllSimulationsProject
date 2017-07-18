
#import <UIKit/UIKit.h>

@interface UIView (Rotate)
/**
 * 无限旋转当前视图
 * @param duration 旋转一圈所需要的时间(秒)
 */
- (void)rotate:(NSTimeInterval)duration repeatCount:(NSTimeInterval)repeatCount;

@end

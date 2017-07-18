
#import <Foundation/Foundation.h>

@interface SHLrcLine : NSObject
/**
 * 播放时间点
 */
@property(nonatomic,strong) NSString *time;
/**
 * 歌词内容
 */
@property(nonatomic,strong) NSString *words;
@end


#import <Foundation/Foundation.h>

@interface SHCurrentMusic : NSObject
@property(nonatomic,copy) NSString *name;
@property(nonatomic,copy) NSString *singer;
@property(nonatomic,copy) NSString *singericon;
@property(nonatomic,strong) NSURL *musicNameURL;
+ (instancetype)currentWithJSON:(NSDictionary *)json;
/**
 * 歌曲名字加后缀
 */
@property(nonatomic,copy) NSString *filename;
/**
 * 一瞬间.lrc
 */
@property(nonatomic,copy) NSString *lrcname;
/**
 * 歌曲图表名
 */
@property(nonatomic,copy) NSString *icon;
@end

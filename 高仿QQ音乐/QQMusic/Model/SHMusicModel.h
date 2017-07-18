
#import <Foundation/Foundation.h>
@class SHMusic;

@interface SHMusicModel : NSObject
/**
 * 歌曲名字
 */
@property(nonatomic,copy) NSString *name;
/**
 * 歌曲名字加后缀
 */
@property(nonatomic,copy) NSString *filename;
/**
 * 一瞬间.lrc
 */
@property(nonatomic,copy) NSString *lrcname;
/**
 * 演唱者
 */
@property(nonatomic,copy) NSString *singer;
/**
 * 演唱者图片
 */
@property(nonatomic,copy) NSString *singericon;
/**
 * 歌曲图表名
 */
@property(nonatomic,copy) NSString *icon;
@property(nonatomic) BOOL isLoveMusic;
@property(nonatomic,strong) NSURL *musicNameURL;

@end

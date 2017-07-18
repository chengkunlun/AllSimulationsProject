
#import <Foundation/Foundation.h>
#import "SHMusicModel.h"

@interface SHMusicTool : NSObject

+ (NSArray *)musics;

+ (SHMusicModel *)playingMusic;

+ (void)setPlayingMusic:(SHMusicModel *)playingMusic;

+ (SHMusicModel *)previousMusic;

+ (SHMusicModel *)nextMusic;

@end

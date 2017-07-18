
#import "SHMusicTool.h"

static NSArray *_musics;

static SHMusicModel *_playingMusic;

@implementation SHMusicTool
+ (NSArray *)musics{
    if (!_musics) {
        _musics = [self demoMusicInfo];
    }
    return _musics;
}


+ (SHMusicModel *)playingMusic{
    return _playingMusic;
}

+ (void)setPlayingMusic:(SHMusicModel *)playingMusic{
    if (!playingMusic || ![[self musics]containsObject:playingMusic]) return;
    if (_playingMusic == playingMusic) {
        _playingMusic = playingMusic;
    }
}

+ (SHMusicModel *)previousMusic{
    NSInteger previousIndex = 0;
    if (_playingMusic) {
        NSInteger playerIndex = [[self musics] indexOfObject:_playingMusic];
        previousIndex = playerIndex - 1;
        if (previousIndex < 0) {
            previousIndex = [self musics].count - 1;
        }
    }
    return [self musics][previousIndex];
}

+ (SHMusicModel *)nextMusic{
    NSInteger nextIndex = 0;
    if (_playingMusic) {
        NSInteger playerIndex = [[self musics] indexOfObject:_playingMusic];
        nextIndex = playerIndex + 1;
        if (nextIndex >= [self musics].count) {
            nextIndex = 0;
        }
    }
    return [self musics][nextIndex];
}

+ (NSArray *)demoMusicInfo{
    NSString *string = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *fullPath = [string stringByAppendingPathComponent:@"Musics.plist"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:fullPath]) {
        fullPath = [[NSBundle mainBundle] pathForResource:@"Musics.plist" ofType:nil];
    }
    NSArray *dictArray = [NSArray arrayWithContentsOfFile:fullPath];
    NSMutableArray *models = [NSMutableArray array];
    for (NSDictionary *dict in dictArray) {
        SHMusicModel *message = [[SHMusicModel alloc] init];
        message.name = dict[@"name"];
        message.filename = dict[@"filename"];
        message.lrcname = dict[@"lrcname"];
        message.singer = dict[@"singer"];
        message.singericon = dict[@"singerIcon"];
        message.icon = dict[@"icon"];
        message.isLoveMusic = [dict[@"isLoveMusic"] boolValue];
        [models addObject:message];
    }
    dictArray = [models copy];
    return dictArray;
}

@end


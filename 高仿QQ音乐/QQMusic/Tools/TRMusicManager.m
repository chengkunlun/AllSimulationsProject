#import "TRMusicManager.h"

static NSMutableDictionary *_musicPlayers;

@implementation TRMusicManager

+ (void)initialize
{
    _musicPlayers = [[NSMutableDictionary alloc]init];
}
/*
+ (NSMutableDictionary *)musicPlayers
{
    if (!_musicPlayers) {
        _musicPlayers = [[NSMutableDictionary alloc]init];
    }
    return _musicPlayers;
}
 */
+ (AVAudioPlayer *)playMusic:(NSString *)filename
{
    if (!filename)return nil;
    AVAudioPlayer *player = _musicPlayers[filename];
    if (!player) {
        NSURL *url = [[NSBundle mainBundle]URLForResource:filename withExtension:@"mp3"];
        player = [[AVAudioPlayer alloc]initWithContentsOfURL:url error:nil];
        if (![player prepareToPlay]) return nil;
        _musicPlayers[filename] = player;
    }
    if (!player.isPlaying) {
        [player play];
    }
    return player;
}

+ (void)pauseMusic:(NSString *)filename
{
    if (!filename) return;
    AVAudioPlayer *player = _musicPlayers[filename];
    if (player.isPlaying) {
        [player pause];
    }
}

+ (void)stopMusic:(NSString *)filename
{
    if(!filename) return;
    AVAudioPlayer *player = _musicPlayers[filename];
    [player stop];
    [_musicPlayers removeObjectForKey:filename];
}
@end


#import <Foundation/Foundation.h>
@import AVFoundation;

@interface TRMusicManager : NSObject
/**
 * 播放音乐
 * @param filename 音乐文件名
 * @return 播放是是否成功
 */
+ (AVAudioPlayer *)playMusic:(NSString *)filename;
/**
 * 播放音乐
 * @param filename 音乐文件名
 */
+ (void)pauseMusic:(NSString *)filename;
/**
 * 播放音乐
 * @param filename 音乐文件名
 */
+ (void)stopMusic:(NSString *)filename;

@end





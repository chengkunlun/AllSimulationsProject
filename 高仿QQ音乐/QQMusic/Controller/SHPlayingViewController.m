
#import "SHPlayingViewController.h"
#import "SHMusicTool.h"
#import "TRMusicManager.h"
#import "UIImage+Circle.h"
#import "UIView+Extension.h"
#import "UIView+Rotate.h"
#import "SHLrcsView.h"
#import "DOUAudioStreamer.h"
#import "SHCurrentMusic.h"
#import "SHAudioFile.h"
#import "SHCopPlistToDocument.h"

@interface SHPlayingViewController ()<AVAudioPlayerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *singerImageView;
@property(strong,nonatomic) SHMusicModel *music;
@property (weak, nonatomic) IBOutlet UIButton *playButton;
@property (weak, nonatomic) IBOutlet UIButton *loveButton;
@property (weak, nonatomic) IBOutlet UIView *animationView;
@property (weak, nonatomic) IBOutlet UIView *progressView;
@property (weak, nonatomic) IBOutlet UIView *currentProgressView;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *currentTime;
@property (weak, nonatomic) IBOutlet UILabel *totalTime;
@property(strong,nonatomic) UIVisualEffectView *effectView;
@property(strong,nonatomic) NSTimer *currentTimer;
@property(strong,nonatomic) AVAudioPlayer *player;
@property (weak, nonatomic) IBOutlet UIView *progressIndicator;
@property (weak, nonatomic) IBOutlet SHLrcsView *lrcView;
@property (weak, nonatomic) IBOutlet UIButton *hiddenLrcButton;
@property(strong,nonatomic) DOUAudioStreamer *doubanPlayer;
@property(strong,nonatomic) CADisplayLink *lrcTimer;
@property(strong,nonatomic) SHCurrentMusic *onLineMusic;
@property(strong,nonatomic) CABasicAnimation *opacityAnimation;
@property(strong,nonatomic) CABasicAnimation *scaleAnimation;
@end

@implementation SHPlayingViewController
- (SHMusicModel *)music{
    _music = self.musics[self.index];
    return _music;
}
- (SHCurrentMusic *)onLineMusic{
    _onLineMusic = self.musics[self.index];
    return _onLineMusic;
}
- (UIVisualEffectView *)effectView{
    if (!_effectView) {
        _effectView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
        _effectView.frame = self.view.frame;
        _effectView.alpha = 0.8;
    }
    return _effectView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.currentProgressView.frame = CGRectZero;
    self.progressIndicator.layer.cornerRadius = 10;
    self.currentTime.text = [NSString stringWithFormat:@"00:00"];
}

- (void)viewDidLayoutSubviews{
    self.progressIndicator.frame = CGRectMake(self.progressView.frame.origin.x, self.progressView.frame.origin.y - 10, 20, 20);
    //计算进度到达的百分比
    float progressValue = 0;
    if (self.player.duration > 0) {
        progressValue = self.player.currentTime/self.player.duration;
    }
    CGRect frame = self.progressIndicator.frame;
    frame.origin.x = self.progressView.frame.size.width * progressValue + self.progressIndicator.frame.origin.x;
    self.progressIndicator.frame = frame;

    frame = self.currentProgressView.frame;
    frame.size.width = self.progressIndicator.frame.origin.x - self.progressView.frame.origin.x;
    self.currentProgressView.frame = frame;
}

- (void)show:(NSIndexPath *)indexPath{
    UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
    self.view.frame = window.bounds;
    [window addSubview:self.view];
    //增加玻璃效果
    [self.view insertSubview:self.effectView atIndex:1];
    
    CGRect endFrame = self.view.frame;
    CGRect startFrame = endFrame;
    startFrame.origin.y = startFrame.size.height;
    self.view.frame = startFrame;
    
    [UIView animateWithDuration:0.5 animations:^{
        self.view.frame = endFrame;
    }];
    
    if (indexPath.section == 1 && indexPath.row == 1) {
        [self startPlayMusicOnLine];
    }else{
        [self startPlayMusic];
    }
}

- (void)startPlayMusic{
    self.name.text = self.music.name;
    if (self.music) {
        [TRMusicManager stopMusic:self.music.name];
    }
    self.player = [TRMusicManager playMusic:self.music.name];
    self.playButton.selected = YES;
    self.loveButton.selected = self.music.isLoveMusic;
    self.totalTime.text = [self stringByTimer:self.player.duration];
    [self addPalyingTimer];
    [self addLrcTimer];
    [self settingImage];
    self.lrcView.lrcname = self.music.lrcname;
    self.player.delegate = self;
}
- (void)startPlayMusicOnLine{
    SHCurrentMusic *music = self.musics[self.index];
    SHAudioFile *audioFile = [[SHAudioFile alloc] init];
    audioFile.audioFileURL = music.musicNameURL;
    self.doubanPlayer = [DOUAudioStreamer streamerWithAudioFile:audioFile];
//    self.totalTime.text = [self stringByTimer:self.doubanPlayer.duration];
    [self addPalyingTimer];
    [self.doubanPlayer play];
}


#pragma mark - 喜欢歌曲按钮初始状态及设置点击事件
- (void)loveButtonBegainStateAndClearLrcname{
    self.lrcView.lrcname = nil;
    self.loveButton.selected = NO;
}
- (IBAction)loveMusic:(UIButton *)sender {
    self.loveButton.selected = !self.loveButton.selected;
    NSString *plistPath = [SHCopPlistToDocument copyPlistFromBoundsPlistName:@"Musics.plist"];
    NSMutableArray *plistMusics = [NSMutableArray arrayWithContentsOfFile:plistPath];
    for (NSMutableDictionary *dict in plistMusics) {
        if ([self.music.name isEqualToString:dict[@"name"]]) {
            self.music.isLoveMusic = !self.music.isLoveMusic;
            NSNumber *loveMusic = [[NSNumber alloc] initWithBool:self.music.isLoveMusic];
            [dict setValue:loveMusic forKey:@"isLoveMusic"];
            [plistMusics writeToFile:plistPath atomically:YES];
        }
    }
}

#pragma mark - 播放上一首、下一首、暂停、停止、返回
- (IBAction)previous:(id)sender {
    [self settingAnimationView];
    [self loveButtonBegainStateAndClearLrcname];
    [self stop:sender];
    self.index --;
    if (self.index < 0) {
        self.index = self.musics.count-1;
    }
    [self startPlayMusic];
    [self startPlayMusicOnLine];
}

- (IBAction)next:(id)sender {
    [self settingAnimationView];
    [self loveButtonBegainStateAndClearLrcname];
    [self stop:sender];
    self.index++;
    if (self.index>= self.musics.count) {
        self.index = 0;
    }
    [self startPlayMusic];
    [self startPlayMusicOnLine];
}
- (IBAction)pause:(id)sender {
    if (self.player.playing) {
        self.playButton.selected = NO;
        [TRMusicManager pauseMusic:self.music.name];
        [self.doubanPlayer pause];
    }else{
        self.playButton.selected = YES;
        [TRMusicManager playMusic:self.music.name];
        [self startPlayMusicOnLine];
    }
}
- (void)stop:(id)sender{
    [TRMusicManager stopMusic:self.music.name];
    [self.doubanPlayer stop];
}
- (IBAction)back {
    self.lrcView.lrcname = nil;
    CGRect startFrame = self.view.frame;
    CGRect endFrame = startFrame;
    endFrame.origin.y = startFrame.size.height;
    self.view.frame = startFrame;
    [UIView animateWithDuration:0.5 animations:^{
        self.view.frame = endFrame;
    }];
    [self stop:self.music.name];
}

#pragma mark - 动画设置
- (void)settingAnimationView{
    self.opacityAnimation = (CABasicAnimation *)[Animation returnAnimationAccordingToString:@"opacity" fromValue:@1.0 toValue:@0.0 duration:1.0];
    [self.animationView.layer addAnimation:self.opacityAnimation forKey:nil];
    
    NSValue *fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
    NSValue *toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.0, 0.0, 1)];
    self.scaleAnimation = (CABasicAnimation *)[Animation returnAnimationAccordingToString:@"transform" fromValue:fromValue toValue:toValue duration:1.0];
    [self.animationView.layer addAnimation:self.scaleAnimation forKey:nil];
    
    [self.animationView rotate:0.5 repeatCount:2];
}
/**
 * 设置图片
 */
- (void)settingImage{
    UIImage *image = [UIImage imageNamed:self.music.icon];
    image = [UIImage scaleToSize:image size:self.singerImageView.frame.size];
    self.singerImageView.image = [UIImage circleImageWithImage:image borderWidth:10 borderColor:[UIColor lightGrayColor]];
    self.singerImageView.alpha = 0.6;
    [self.singerImageView rotate:6.0 repeatCount:2147483647];
}
#pragma mark - NSTimer
- (void)addPalyingTimer{
    [self removeCurrentTimer];
    self.currentTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateCurrentTime) userInfo:nil repeats:YES];
}
- (void)removeCurrentTimer{
    [self.currentTimer invalidate];
    self.currentTimer = nil;
}
- (void)updateCurrentTime{
    [self.view setNeedsLayout];
    if (self.index == 0) {
        self.currentTime.text = [self stringByTimer:self.player.currentTime];
    }else{
        self.currentTime.text = [self stringByTimer:self.doubanPlayer.currentTime];
    }
}
#pragma mark - CADisplayLink
- (void)addLrcTimer{
    [self removeLrcTimer];
    [self updateLrc];
    self.lrcTimer = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateLrc)];
    [self.lrcTimer addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
}
- (void)removeLrcTimer{
    [self.lrcTimer invalidate];
    self.lrcTimer = nil;
}
- (void)updateLrc{
    self.lrcView.currentTime = self.player.currentTime;
}
- (NSString *)stringByTimer:(NSTimeInterval)time{
    int min = time / 60;
    int sec = (int)time % 60;
    NSString *returnCurrentTime = [NSString stringWithFormat:@"%02d:%02d",min,sec];
    return returnCurrentTime;
}
- (IBAction)progressIndicatorPan:(UIPanGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateBegan) {
        [self removeCurrentTimer];
    }else if (sender.state == UIGestureRecognizerStateChanged){
        CGRect frame = self.progressIndicator.frame;
        if (self.progressIndicator.frame.origin.x >= self.progressView.frame.origin.x && self.progressIndicator.frame.origin.x <= self.progressView.frame.origin.x + self.progressView.frame.size.width) {
            CGPoint translation = [sender translationInView:self.progressView];
            frame.origin.x += translation.x;
            self.progressIndicator.frame = frame;
            [sender setTranslation:CGPointZero inView:self.progressView];

            frame = self.currentProgressView.frame;
            frame.size.width = self.progressIndicator.frame.origin.x - self.progressView.frame.origin.x;
            self.currentProgressView.frame = frame;
            
            self.player.currentTime = self.currentProgressView.frame.size.width/self.progressView.frame.size.width * self.player.duration;
            self.doubanPlayer.currentTime = self.currentProgressView.frame.size.width/self.progressView.frame.size.width * self.player.duration;
        }
    }else{
        [self addPalyingTimer];
    }
}
#pragma mark - AVAudioPlayerDelegate
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    [self next:nil];
}

#pragma mark - 歌曲播放被打断以及恢复
- (void)audioPlayerBeginInterruption:(AVAudioPlayer *)player{
    [self pause:self.playButton];
}
- (void)audioPlayerEndInterruption:(AVAudioPlayer *)player{
    [self pause:self.playButton];
}
- (IBAction)showLrc:(id)sender {
    self.lrcView.hidden = !self.lrcView.hidden;
    if (self.lrcView.hidden) {
        [self.hiddenLrcButton setTitle:@"显示歌词" forState:UIControlStateNormal];
    }else{
        [self.hiddenLrcButton setTitle:@"隐藏歌词" forState:UIControlStateNormal];
    }
}

@end
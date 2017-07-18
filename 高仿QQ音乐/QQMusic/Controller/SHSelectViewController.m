
#import "SHSelectViewController.h"
#import "SHSelectImageModel.h"
#import "UIView+Extension.h"

#define padding 60
#define smallPadding 10
#define mainScreenFrame [UIScreen mainScreen].bounds
#define imageViewH (mainScreenFrame.size.height - padding)/3.0

@interface SHSelectViewController ()<UIScrollViewDelegate>
@property(nonatomic,strong)NSArray *views;
@property(nonatomic,strong)NSMutableArray *musics;
@property(nonatomic,strong)UIScrollView *scrollView;
@property(nonatomic,strong)UIPageControl *pageControl;
@property(nonatomic,strong)UIScrollView *titleScrollView;
@property(nonatomic,strong)UIPageControl *titlePageControl;
@property(nonatomic,strong)NSTimer *timer;
@property(nonatomic,strong)NSArray *contentImages;
@end

@implementation SHSelectViewController
- (NSArray *)views{
    if (!_views) {
        _views = @[@" ",@" "];
    }
    return _views;
}
- (NSMutableArray *)musics{
    if (!_musics) {
        _musics = [[SHSelectImageModel demoSelectImages] mutableCopy];
    }
    return _musics;
}
- (NSArray *)contentImages{
    if (!_contentImages) {
        _contentImages = [SHSelectImageModel demoContentImages];
    }
    return _contentImages;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
}

- (void)createUI{
    self.scrollView = [ScrollView returnScrollView:self.views frame:self.view.frame];
    self.scrollView.delegate = self;
    [self.view addSubview:self.scrollView];
    
    CGRect pageControlFrame = CGRectMake(0, CGRectGetMaxY(self.scrollView.frame) - padding, self.view.width, smallPadding);
    self.pageControl = [PageControl returnPageControl:self.views frame:pageControlFrame];
    [self.view addSubview:self.pageControl];
    
    CGRect titleFrame = CGRectMake(0, 0, self.view.width, imageViewH);
    self.titleScrollView = [ScrollView returnScrollView:self.musics frame:titleFrame];
    self.titleScrollView.delegate = self;
    CGRect frame = titleFrame;
    frame.origin.x = self.view.width;
    [self.titleScrollView scrollRectToVisible:frame animated:NO];
    
    [self.scrollView addSubview:self.titleScrollView];
    
    [self.musics removeObjectAtIndex:0];
    [self.musics removeObjectAtIndex:self.musics.count - 1];
    CGRect titlePageControlFrame = CGRectMake(0, CGRectGetMaxY(self.titleScrollView.frame) - smallPadding * 2, self.view.width, smallPadding);
    self.titlePageControl = [PageControl returnPageControl:self.musics frame:titlePageControlFrame];
    [self.scrollView addSubview:self.titlePageControl];
    
    for (int i = 0; i<self.contentImages.count; i++) {
        UIImage *image = [UIImage imageNamed:self.contentImages[i]];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        CGRect frame = CGRectZero;
        frame.size.width = self.view.width / 2.0;
        frame.size.height = imageViewH;
        if (i<4) {
            if (i % 2 == 0) {
                frame.origin.x = 0;
            }else{
                frame.origin.x = self.view.width / 2.0;
            }
            frame.origin.y = imageViewH * (i /2 + 1);
        }else{
            if (i % 2 == 0) {
                frame.origin.x = self.view.width;
            }else{
                frame.origin.x = self.view.width * 1.5;
            }
            frame.origin.y = imageViewH * ((i - 4)/2);
        }
        imageView.frame = frame;
        [self.scrollView addSubview:imageView];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat index = scrollView.contentOffset.x / self.view.frame.size.width;
    if (scrollView == self.scrollView) {
        self.pageControl.currentPage = index;
    }else{
        self.titlePageControl.currentPage = index - 1;
        CGRect frame = CGRectMake(0, 0, self.view.width, self.view.height);
        if (index - 1 == self.musics.count) {
            frame.origin.x = self.view.width;
            [scrollView scrollRectToVisible:frame animated:NO];
        }else if (index == 0){
            frame.origin.x = self.view.width * self.musics.count;
            [scrollView scrollRectToVisible:frame animated:NO];
        }
    }
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self addTimer];
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
    [self removeTimer];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self addTimer];
}
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self removeTimer];
}

- (void)addTimer{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(updateScrollImageTimer) userInfo:nil repeats:YES];
}
- (void)removeTimer{
    [self.timer invalidate];
}
static CGFloat x = 0;
- (void)updateScrollImageTimer{
    x += self.view.width;
    self.titleScrollView.contentOffset = CGPointMake(x, 0);
    if (x == self.musics.count*self.view.width) {
        x = 0;
    }
}
@end

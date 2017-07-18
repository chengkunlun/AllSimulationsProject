#import "WelcomeViewController.h"
#import "WelcomeImageModel.h"
#import "MainViewController.h"

@interface WelcomeViewController ()<UIScrollViewDelegate>
@property(nonatomic,strong) NSArray *images;
@property(nonatomic,strong) UIScrollView *scrollView;
@property(nonatomic,strong) UIPageControl *pageControl;
@end

@implementation WelcomeViewController
- (NSArray *)images{
    if (!_images) {
        _images = [WelcomeImageModel demoWelcomeImages];
    }
    return _images;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self createWelcomeUI];
    
    NSString *doucumentsPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSLog(@"%@",doucumentsPath);
}
- (void)createWelcomeUI{
    CGRect frame = [UIScreen mainScreen].bounds;
    self.scrollView = [ScrollView returnScrollView:self.images frame:frame];
    [self.view addSubview:self.scrollView];
    self.scrollView.delegate = self;

    CGRect pageFrame = CGRectMake(0, frame.size.height - 60, frame.size.width, 30);
    self.pageControl = [PageControl returnPageControl:self.images frame:pageFrame];
    [self.view addSubview:self.pageControl];
    
    [self addButton];
}

- (void)addButton{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button = [ScrollView createButton:button location:self.images];
    [button addTarget:self action:@selector(gotoNextView) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:button];
}
#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    NSInteger index = scrollView.contentOffset.x / self.scrollView.width;
    self.pageControl.currentPage = index;
}
#pragma mark - 实现按钮事件
- (void)gotoNextView{
    MainViewController *mainVC = [self.storyboard instantiateViewControllerWithIdentifier:@"mainMusic"];
//    MainViewController *mainVC = [[MainViewController alloc] init];
    [self presentViewController:mainVC animated:YES completion:nil];
}
@end



#import "MainViewController.h"
#import "MyMusicViewController.h"

#define bottomLayoutGuideLength 69
@interface MainViewController ()
@property(nonatomic,strong) UIImageView *tabBarView;
@property(nonatomic,strong) NSArray *normalImageNames;
@property(nonatomic,strong) NSArray *selectedImageNames;
@property(nonatomic,strong) NSArray *buttonTitles;
@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.tabBar.hidden = YES;
    self.view.backgroundColor = [UIColor whiteColor];
//    NSLog(@"%.2f",self.bottomLayoutGuide.length);
    /*
    CGFloat tabBarViewY = self.view.height - bottomLayoutGuideLength;
    self.tabBarView = [[UIImageView alloc] initWithFrame:CGRectMake(0, tabBarViewY, self.view.width, bottomLayoutGuideLength)];
    self.tabBarView.userInteractionEnabled = YES;
    self.tabBarView.backgroundColor = [UIColor lightTextColor];
    [self.view addSubview:self.tabBarView];
    
    for (int i = 0; i<4; i++) {
        self.button = [SHCustomTabBar createButtonWithNormalName:self.normalImageNames[i] selectName:self.selectedImageNames[i] title:self.buttonTitles[i] frame:self.tabBarView.frame index:i];
        [self.button addTarget:self action:@selector(changeViewController:) forControlEvents:UIControlEventTouchDown];
        [self.view addSubview:self.button];
    }
     */
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end


#import "SHSingInViewController.h"
#import "SHSingInModel.h"
#import "SHRegisterViewController.h"
#import "MyMusicViewController.h"

#define topLayoutGuideLength  64
#define padding 10

@interface SHSingInViewController ()
@property(nonatomic,strong) UITextField *accountTextField;
@property(nonatomic,strong) UITextField *passwordTextField;
@property(nonatomic,strong) UILabel *alertLabel;
@property(nonatomic,strong) NSArray *singInfos;
@end

@implementation SHSingInViewController
- (MyMusicViewController *)myMusicVC{
    if (!_myMusicVC) {
        _myMusicVC = [[MyMusicViewController alloc] init];
    }
    return _myMusicVC;
}
- (NSArray *)singInfos{
    if (!_singInfos) {
        _singInfos = [NSArray array];
    }
    return _singInfos;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"登陆界面";
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"登陆" style:UIBarButtonItemStyleDone target:self action:@selector(longinView)];
    [self createUI];
}
- (void)createUI{
    UIImage *image = [UIImage imageNamed:@"login_bg"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.frame = CGRectMake(0, topLayoutGuideLength, self.view.width, 160);
    [self.view addSubview:imageView];
    UITextField *accountTextField = [[UITextField alloc] init];
    self.accountTextField = accountTextField;
    CGRect frame = CGRectZero;
    frame.origin.y = CGRectGetMaxY(imageView.frame);
    frame.size.width = self.view.width;
    frame.size.height = 44;
    accountTextField.frame = frame;
    accountTextField.placeholder = @" 账号:";
    accountTextField.borderStyle = UITextBorderStyleLine;
    accountTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.view addSubview:accountTextField];
    
    UITextField *passwordTextField = [[UITextField alloc] init];
    self.passwordTextField = passwordTextField;
    frame.origin.y = CGRectGetMaxY(accountTextField.frame);
    frame.size.height = 44;
    passwordTextField.frame = frame;
    passwordTextField.placeholder = @" 密码:";
    passwordTextField.borderStyle = UITextBorderStyleLine;
    passwordTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.view addSubview:passwordTextField];
    
    UILabel *alertLabel = [[UILabel alloc] init];
    self.alertLabel = alertLabel;
    frame.origin.y = CGRectGetMaxY(passwordTextField.frame);
    alertLabel.frame = frame;
    alertLabel.textAlignment = NSTextAlignmentCenter;
    alertLabel.textColor = [UIColor redColor];
    alertLabel.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:alertLabel];
    
    UIButton *registerButton = [UIButton buttonWithType:UIButtonTypeSystem];
    frame.origin.y = CGRectGetMaxY(passwordTextField.frame) + padding;
    frame.size.width = 50;
    frame.size.height = 35;
    frame.origin.x = self.view.width - frame.size.width;
    registerButton.frame = frame;
    [registerButton setTitle:@"注册" forState:UIControlStateNormal];
    [registerButton addTarget:self action:@selector(registerView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:registerButton];
    
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
/*****************account*******Chenjie****************************/
   /**************password******123456**************************/
      /***********account*******Shanghai*********************/
         /********password******123123********************/
- (void)longinView{
    NSInteger count = 0;
    self.alertLabel.text = nil;
    [self.view endEditing:YES];
    self.singInfos = [self getDateFromJSON];
    for (SHSingInModel *model in self.singInfos) {
        count ++;
        if ([self.accountTextField.text isEqualToString:model.account] && [self.passwordTextField.text isEqualToString:model.password]) {
            NSLog(@"登陆成功");
            self.myMusicVC.account = self.accountTextField.text;
            self.myMusicVC.isSingInSuccess = YES;
            [self.navigationController popToRootViewControllerAnimated:YES];
            return;
        }else if ([self.accountTextField.text isEqualToString:@""] || [self.passwordTextField.text isEqualToString:@""]){
            if (count == self.singInfos.count) {
                self.alertLabel.text = @"请输入用户名或密码";
            }
        }else{
            if (count == self.singInfos.count) {
                self.alertLabel.text = @"输入用户名或密码错误";
            }
        }
    }
}
- (NSArray *)getDateFromJSON{
//    NSString *plistString = [[NSBundle mainBundle] pathForResource:@"SingIn.plist" ofType:nil];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *plistString = paths[0];
//    NSLog(@"%@",plistString);
    NSArray *array = [NSArray arrayWithContentsOfFile:[plistString stringByAppendingPathComponent:@"SingIn.plist"]];
    NSMutableArray *muArray = [NSMutableArray array];
    for (NSDictionary *dict in array) {
        SHSingInModel *singIn = [SHSingInModel dateWithJSON:dict];
        [muArray addObject:singIn];
    }
    return [muArray copy];
}
- (void)registerView{
    SHRegisterViewController *registerVC = [[SHRegisterViewController alloc] init];
    [self.navigationController pushViewController:registerVC animated:YES];
}


@end

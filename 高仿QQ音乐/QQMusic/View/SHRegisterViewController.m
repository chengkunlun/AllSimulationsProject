
#import "SHRegisterViewController.h"
#import "SHSingInViewController.h"
#import "SHCopPlistToDocument.h"

#define mainFrame [UIScreen mainScreen].bounds
//验证码button
#define verificationButtonW 80
#define topLayoutGuideLength  64
#define imageViewH 40
#define padding 4
#define textFieldH 36

@interface SHRegisterViewController ()<UIAlertViewDelegate>
@property(nonatomic,strong) NSArray *registerModels;
@property(nonatomic,strong) NSArray *registerImages;
@property(nonatomic,strong) NSMutableArray *textFields;
@property(nonatomic,strong) NSMutableArray *accounts;
@end

@implementation SHRegisterViewController
- (NSArray *)registerModels{
    if (!_registerModels) {
        _registerModels = @[@"手机号",@"验证码",@"密码"];
    }
    return _registerModels;
}
- (NSArray *)registerImages{
    if (_registerImages) {
        _registerImages = nil;
    }
    return _registerImages;
}
- (NSMutableArray *)textFields{
    if (!_textFields) {
        _textFields = [NSMutableArray array];
    }
    return _textFields;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"注册界面";
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"<返回/取消" style:UIBarButtonItemStylePlain target:self action:@selector(lastView)];
    self.view.backgroundColor = [UIColor whiteColor];
    [self createUI];
}
- (void)createUI{
    for (int i = 0; i<self.registerModels.count; i++) {
        UIImage *image = [UIImage imageNamed:self.registerImages[i]];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        imageView.frame = CGRectMake(padding, topLayoutGuideLength + imageViewH * i + padding, textFieldH, textFieldH);
        imageView.backgroundColor = [UIColor greenColor];
        [self.view addSubview:imageView];
        
        UITextField *textField = [[UITextField alloc] init];
        textField.frame = CGRectMake(CGRectGetMaxX(imageView.frame) + padding, topLayoutGuideLength + imageViewH * i + padding, mainFrame.size.width - verificationButtonW - imageViewH - padding , textFieldH);
        textField.backgroundColor = [UIColor clearColor];
        textField.placeholder = self.registerModels[i];
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
//        textField.backgroundColor = [UIColor lightGrayColor];
        [self.textFields addObject:textField];
        [self.view addSubview:textField];
    }
    UIButton *verificationButton = [UIButton buttonWithType:UIButtonTypeSystem];
    verificationButton.frame = CGRectMake(mainFrame.size.width - verificationButtonW, topLayoutGuideLength + padding, verificationButtonW, textFieldH);
    [verificationButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    [verificationButton addTarget:self action:@selector(getVerification) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:verificationButton];
    
    UIButton *registerButton = [UIButton buttonWithType:UIButtonTypeSystem];
    registerButton.frame = CGRectMake(padding, CGRectGetMaxY(verificationButton.frame) + imageViewH * 3, mainFrame.size.width - padding * 2, imageViewH);
    [registerButton setTitle:@"注册" forState:UIControlStateNormal];
    registerButton.backgroundColor = [UIColor orangeColor];
    [registerButton setTintColor:[UIColor whiteColor]];
    [registerButton addTarget:self action:@selector(registerAccount) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:registerButton];
}
- (void)getVerification{
    UITextField *textField = self.textFields[0];
    if (![textField.text isEqualToString:@""]) {
        NSInteger random = arc4random()%1000000;
        UITextField *verTextField = self.textFields[1];
        if (random > 100000) {
            verTextField.text = [NSString stringWithFormat:@"%ld",random];
        }
    }else{
        textField = self.textFields[0];
        textField.placeholder = @"请输入手机号";
    }
}
- (void)registerAccount{
    NSInteger count = 0;
    for (UITextField *textField in self.textFields) {
        UITextField *firstTextField = self.textFields[0];
        count ++;
        if ([textField.text isEqualToString:@""]) {
            textField.placeholder = @"请输入数据";
            textField.font = [UIFont systemFontOfSize:16];
            return;
        }
        if (![textField.text isEqualToString:@""] && count == self.textFields.count){
            NSString *plistPath = [SHCopPlistToDocument copyPlistFromBoundsPlistName:@"SingIn.plist"];
            self.accounts = [NSMutableArray arrayWithContentsOfFile:plistPath];
            NSMutableDictionary *dictPlist = [[NSMutableDictionary alloc] init];
            [dictPlist setObject:firstTextField.text forKey:@"account"];
            [dictPlist setObject:textField.text forKey:@"password"];
            [self.accounts addObject:dictPlist];
            [self.accounts writeToFile:plistPath atomically:YES];
            [self createAlertControl];
        }
    }
}
- (void)createAlertControl{
    /*
    UIAlertController *alertController = [[UIAlertController alloc] init];
    UIAlertAction *alertAction = [[UIAlertAction alloc] init];
     */
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"注册成功" message:@"欢迎使用QQ音乐播放器" delegate:self cancelButtonTitle:@"返回" otherButtonTitles:@"登陆", nil];
    [alertView show];
    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        SHSingInViewController *singInVC = [[SHSingInViewController alloc] init];
        [self.navigationController pushViewController:singInVC animated:YES];
    }
}

- (void)lastView{
    SHSingInViewController *singInVC = [[SHSingInViewController alloc] init];
    [self.navigationController pushViewController:singInVC animated:YES];
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
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

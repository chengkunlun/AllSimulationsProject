
#import "SHMoreViewController.h"
#import "SHSingInViewController.h"
#import "SHMoreViewCell.h"

#define cellW [UIScreen mainScreen].bounds.size.width
#define cellH 44
#define padding 10

@interface SHMoreViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong) UITableView *tableView;
@property(nonatomic,strong) UIView *headView;
@end

@implementation SHMoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设置";
    [self createUI];
}
- (void)createUI{
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.headView.frame), cellW, self.view.height) style:UITableViewStyleGrouped];
    self.tableView = tableView;
    tableView.dataSource = self;
    //tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    tableView.delegate = self;
    [self.view addSubview:tableView];
    [self.tableView registerNib:[UINib nibWithNibName:@"SHMoreViewCell" bundle:nil] forCellReuseIdentifier:@"moreCell"];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 44;
    }return 0;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, cellW, cellH)];
        headView.backgroundColor = [UIColor lightGrayColor];
        [self.view addSubview:headView];
        UIButton *button1 = [UIButton buttonWithType:UIButtonTypeSystem];
        [button1 setTitle:@"听歌识曲" forState:UIControlStateNormal];
        [headView addSubview:button1];
        UIButton *button2 = [UIButton buttonWithType:UIButtonTypeSystem];
        [button2 setTitle:@"笛音传歌" forState:UIControlStateNormal];
        [headView addSubview:button2];
        
        //    self.view.translatesAutoresizingMaskIntoConstraints = NO;
        button1.translatesAutoresizingMaskIntoConstraints = NO;
        button2.translatesAutoresizingMaskIntoConstraints = NO;
        
        NSDictionary *metrics = @{@"left":@50,@"space":@80,@"top":@10,@"right":@50};
        NSDictionary *dict = NSDictionaryOfVariableBindings(button1,button2);
        NSString *hVFL = @"|-left-[button1]-space-[button2(button1)]-right-|";
        NSArray *cs = [NSLayoutConstraint constraintsWithVisualFormat:hVFL options:NSLayoutFormatAlignAllCenterY metrics:metrics views:dict];
        [headView addConstraints:cs];
        
        NSString *vVFL = @"V:|-top-[button1]-|";
        NSArray *cs2 = [NSLayoutConstraint constraintsWithVisualFormat:vVFL options:0 metrics:metrics views:dict];
        [headView addConstraints:cs2];
        return headView;
    }return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 3) {
        return 44;
    }
    return 0;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section == 3) {
        UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, cellW, cellH)];
        footView.backgroundColor = [UIColor orangeColor];
        
        UIButton *cancleButton = [UIButton buttonWithType:UIButtonTypeSystem];
        cancleButton.frame = CGRectMake(padding, 0, cellW - padding*2, cellH);
        [cancleButton setTitle:@"取消登陆" forState:UIControlStateNormal];
        [cancleButton addTarget:self action:@selector(cancleEvent) forControlEvents:UIControlEventTouchUpInside];
        [footView addSubview:cancleButton];
        return footView;
    }
    return nil;
}
- (void)cancleEvent{
    NSLog(@"取消登陆TODO...");
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }else if (section == 1){
        return 3;
    }else if (section == 2){
        return 1;
    }else{
        return 3;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SHMoreViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"moreCell"];
    if (indexPath.section == 0) {
        cell.titileLabel.text = @"登陆QQ音乐";
    }else if (indexPath.section == 1 && indexPath.row == 0){
        cell.titileLabel.text = @"偏好设置";
    }else if (indexPath.section == 1 && indexPath.row == 1){
        cell.titileLabel.text = @"TPlay";
    }else if (indexPath.section == 1 && indexPath.row == 2){
        cell.titileLabel.text = @"定时关闭";
        UISwitch *switchView = [[UISwitch alloc] init];
        switchView.on = NO;
        [cell.switchView addSubview:switchView];
    }else if (indexPath.section == 2){
        cell.titileLabel.text = @"更多精彩应用";
    }else if (indexPath.section == 3 && indexPath.row == 0){
        cell.titileLabel.text = @"TMusic专属流量包";
    }else if (indexPath.section == 3 && indexPath.row == 1){
        cell.titileLabel.text = @"邀请好友";
    }else{
        cell.titileLabel.text = @"给软件评分";
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0 && indexPath.row == 0) {
        SHSingInViewController *singInVC = [[SHSingInViewController alloc] init];
        [self.navigationController pushViewController:singInVC animated:YES];
    }
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

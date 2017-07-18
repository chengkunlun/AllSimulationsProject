//
//  MeViewController.m
//  aoyouHH
//
//  Created by jinzelu on 15/4/21.
//  Copyright (c) 2015年 jinzelu. All rights reserved.
//

#import "MeViewController.h"
#import "NetworkSingleton.h"
#import "userLoginedCell.h"
#import "UserSingleton.h"
#import "UIImageView+WebCache.h"
#import "VedioDetailViewController.h"
#import "HHConfig.h"
#import "CourseViewController.h"

#import <MediaPlayer/MPMediaQuery.h>
#import <iAd/iAd.h>

@interface MeViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate,ADBannerViewDelegate>
{
    NSMutableArray *_dataSource;
    ADBannerView *_adView;//广告视图
}
@end

@implementation MeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self initData];
    [self addMyTableView];
//    [self addLoginBtn];
    [self addMyiAD];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)addMyiAD{
    _adView = [[ADBannerView alloc] initWithFrame:CGRectZero];
    //指定大小
    _adView.currentContentSizeIdentifier = ADBannerContentSizeIdentifierPortrait;
    _adView.delegate = self;
    _adView.frame = CGRectOffset(_adView.frame, 0, screen_height-_adView.frame.size.height-50);
    [self.view addSubview:_adView];
}

-(void)addMyTableView{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, screen_width, screen_height-49) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"userLoginedCell" bundle:nil] forCellReuseIdentifier:@"userLoginedCell"];
    [self.view addSubview:self.tableView];
}

-(void)initData{
    _dataSource = [[NSMutableArray alloc] init];
    NSMutableDictionary *dic1 = [[NSMutableDictionary alloc] init];
    [dic1 setObject:@"我发布的笑话" forKey:@"title"];
    [dic1 setObject:@"my_publish_joke_img" forKey:@"pic"];
    [_dataSource addObject:dic1];
    NSMutableDictionary *dic2 = [[NSMutableDictionary alloc] init];
    [dic2 setObject:@"我发布的评论->穿越到高仿百度传课APP" forKey:@"title"];
    [dic2 setObject:@"my_publish_comment_img" forKey:@"pic"];
    [_dataSource addObject:dic2];
    NSMutableDictionary *dic3 = [[NSMutableDictionary alloc] init];
    [dic3 setObject:@"我的收藏" forKey:@"title"];
    [dic3 setObject:@"my_favoriate_img" forKey:@"pic"];
    [_dataSource addObject:dic3];
}

-(void)addLoginBtn{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(70, 70, 100, 40);
    btn.backgroundColor = navigationBarColor;
    [btn addTarget:self action:@selector(OnLogin) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn2.frame = CGRectMake(180, 70, 100, 40);
    btn2.backgroundColor = navigationBarColor;
    [btn2 addTarget:self action:@selector(OnLoginOut) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn2];
}

-(void)OnLogin{
    NSString *r = @"user_info";
    NSString *login_info = @"010000005EBBA600A79E395527D21A574FAFAE4E80AA21C4C50B125F75E290A38461662144239A7A";
//    NSString *login_info = @"010000005EBBA600A79E395527D21A574FAFAE4E80AA21";
    NSDictionary *dic = @{
                          @"r":r,
                          @"login_info":login_info
                          };
    [[NetworkSingleton sharedManager] userLogin:dic successBlock:^(id responseBody){
        [self.tableView reloadData];
    } failureBlock:^(NSString *error){
        NSLog(@"%@",error);
    }];
}
-(void)OnLoginOut{
    [[UserSingleton sharedManager] setUser:nil];
    [self.tableView reloadData];
}


- (void) QueryAllMusic
{
    MPMediaQuery *everything = [[MPMediaQuery alloc] init];
    NSLog(@"Logging items from a generic query...");
    NSArray *itemsFromGenericQuery = [everything items];
    NSLog(@"count = %lu", (unsigned long)itemsFromGenericQuery.count);
    for (MPMediaItem *song in itemsFromGenericQuery)
    {
        NSString *songTitle = [song valueForProperty: MPMediaItemPropertyTitle];
        NSString *songArtist = [song valueForProperty:MPMediaItemPropertyArtist];
        NSLog (@"Title:%@, Aritist:%@", songTitle, songArtist);
    }
}



#pragma mark - UITableViewDataSource
//组数
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if([[UserSingleton sharedManager] hasLogin]){
        return 4;
    }else{
        return 3;
    }
}
//每组行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }else if(section == 1){
        return 3;
    }else{
        return 1;
    }
}
//cell
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {//用户信息
        if([[UserSingleton sharedManager] hasLogin]){
            userLoginedCell *cell = (userLoginedCell *)[tableView dequeueReusableCellWithIdentifier:@"userLoginedCell"];
            UserModel *user = [UserSingleton sharedManager].user;
            [cell.userImg sd_setImageWithURL:[NSURL URLWithString:user.avatar] placeholderImage:[UIImage imageNamed:@"logout_img"]];
            cell.userNameLabel.text = user.name;
            cell.levelLabel.text = [NSString stringWithFormat:@"等级%@",user.level];
            cell.scoreLabel.text = [NSString stringWithFormat:@"哈分%@",user.score];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }else{
            static NSString *MeCellIndentifier1 = @"cell1";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MeCellIndentifier1];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MeCellIndentifier1];
                //图片
                UIImageView *userDefaultImg = [[UIImageView alloc] initWithFrame:CGRectMake(8, 5, 50, 50)];
                [userDefaultImg setImage:[UIImage imageNamed:@"logout_img"]];
                [cell addSubview:userDefaultImg];
                //button
                UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                loginBtn.frame = CGRectMake(60, 15, 80, 30);
                loginBtn.backgroundColor = navigationBarColor;
                [loginBtn setFont:[UIFont systemFontOfSize:14]];
                [loginBtn setTitle:@"登陆/注册" forState:UIControlStateNormal];
                [loginBtn addTarget:self action:@selector(OnLogin) forControlEvents:UIControlEventTouchUpInside];
                [cell addSubview:loginBtn];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
    }else if(indexPath.section == 1){
        static NSString *MeCellIndentifier2 = @"cell2";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MeCellIndentifier2];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MeCellIndentifier2];
        }
        NSString *pic = [_dataSource[indexPath.row] objectForKey:@"pic"];
        cell.imageView.image = [UIImage imageNamed:pic];
        cell.textLabel.text = [_dataSource[indexPath.row] objectForKey:@"title"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else if(indexPath.section == 2){//设置
        static NSString *MeCellIndentifier3 = @"cell3";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MeCellIndentifier3];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MeCellIndentifier3];
        }
        
        cell.imageView.image = [UIImage imageNamed:@"setting_img"];
        cell.textLabel.text = @"设置";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else if(indexPath.section == 3){//退出
        static NSString *MeCellIndentifier4 = @"cell4";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MeCellIndentifier4];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MeCellIndentifier4];
            UILabel *quitLabel = [[UILabel alloc] initWithFrame:CGRectMake(screen_width/2-40, 5, 80, 30)];
            quitLabel.text = @"退出登陆";
            quitLabel.textAlignment = NSTextAlignmentCenter;
            quitLabel.font = [UIFont systemFontOfSize:16];
            [cell addSubview:quitLabel];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else{
        return nil;
    }
}

#pragma mark - UITableViewDelegate
//行高
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 60;
    }else{
        return 40;
    }
}
//header
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    if (section == 0) {
        return 10;
//    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 3) {
        UIAlertView *alertVC = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确定退出？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alertVC.tag = 10;
        alertVC.delegate = self;
        [alertVC show];
    }else if (indexPath.section == 1){
        if (indexPath.row == 0) {
            VedioDetailViewController *vedioVC = [[VedioDetailViewController alloc] init];
            NSString *fileUrl = @"http://v.chuanke.com/vedio/1/08/65/10865711ff6997a671e6622352385208.mp4";
            NSLog(@"fileUrl:%@",fileUrl);
            vedioVC.FileUrl = fileUrl;
            [self.navigationController pushViewController:vedioVC animated:YES];
        }else if (indexPath.row == 1){
            CourseViewController *courseVC = [[CourseViewController alloc] init];
            [self.navigationController pushViewController:courseVC animated:YES];
        }else{
//            [self QueryAllMusic];
            NSURL *url = [NSURL URLWithString:@"openchuankekkiphone:"];
            BOOL isInstalled = [[UIApplication sharedApplication] openURL:url];
            if (isInstalled) {

            }else{
                //土豆    https://appsto.re/cn/c8oMx.i
                //找教练  https://appsto.re/cn/kRb26.i
                //百度传课 https://appsto.re/cn/78XAL.i
//                NSURL *url1 = [NSURL URLWithString:@"https://appsto.re/cn/c8oMx.i"];
//                NSURL *url1 = [NSURL URLWithString:@"https://appsto.re/cn/kRb26.i"];
                NSURL *url1 = [NSURL URLWithString:@"https://appsto.re/cn/78XAL.i"];
                [[UIApplication sharedApplication] openURL:url1];
                NSLog(@"没安装");
            }
            
        }
    }
}

#pragma mark - UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 10) {
        if (buttonIndex == 0) {
            //取消
        }else{
            //确定退出
            [self OnLoginOut];
        }
    }
}

#pragma mark - ADBannerViewDelegate
//广告读取失败
-(void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error{
    NSLog(@"didFailToReceiveAdWithError");
//    _adView.frame = CGRectOffset(_adView.frame, 0, screen_height);
}
//成功读取广告
-(void)bannerViewDidLoadAd:(ADBannerView *)banner{
    NSLog(@"bannerViewDidLoadAd");
//    _adView.frame = CGRectOffset(_adView.frame, 0, screen_height-_adView.frame.size.height-50);
}
//用户点击广告，返回bool指定广告是否打开
-(BOOL)bannerViewActionShouldBegin:(ADBannerView *)banner willLeaveApplication:(BOOL)willLeave{
    NSLog(@"bannerViewActionShouldBegin");
    return YES;
}
-(void)bannerViewActionDidFinish:(ADBannerView *)banner{
    NSLog(@"bannerViewActionDidFinish");
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

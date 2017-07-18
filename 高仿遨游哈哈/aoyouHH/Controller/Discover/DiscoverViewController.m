//
//  DiscoverViewController.m
//  aoyouHH
//
//  Created by jinzelu on 15/4/21.
//  Copyright (c) 2015年 jinzelu. All rights reserved.
//

#import "DiscoverViewController.h"
#import "HHConfig.h"
#import "TuijianAttModel.h"
#import "NetworkSingleton.h"
#import "HotTopicCell.h"
#import "MJRefresh.h"
#import "JokeViewController.h"

@interface DiscoverViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *_dataSources;//tableview的数据源
    NSMutableArray *_dataArr1;
    NSMutableArray *_dataArr2;
    NSMutableArray *_dataArr3;
    
    NSInteger _currentPage;
}

@end

@implementation DiscoverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self initData];
    [self addMyTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//初始化私有变量
-(void)initData{
    _currentPage = 1;
    _dataSources = [[NSMutableArray alloc] init];
    _dataArr1 = [[NSMutableArray alloc] init];
    _dataArr2 = [[NSMutableArray alloc] init];
    _dataArr3 = [[NSMutableArray alloc] init];
    
    NSMutableDictionary *dic1 = [[NSMutableDictionary alloc] init];
    [dic1 setValue:@"24小时最哈" forKey:@"title"];
    [dic1 setValue:@"clock_img" forKey:@"pic"];
    NSMutableDictionary *dic2 = [[NSMutableDictionary alloc] init];
    [dic2 setValue:@"一周最哈" forKey:@"title"];
    [dic2 setValue:@"week_joke_img" forKey:@"pic"];
    NSMutableDictionary *dic3 = [[NSMutableDictionary alloc] init];
    [dic3 setValue:@"热门评论" forKey:@"title"];
    [dic3 setValue:@"hot_comment_img" forKey:@"pic"];
    NSMutableDictionary *dic4 = [[NSMutableDictionary alloc] init];
    [dic4 setValue:@"活动专区" forKey:@"title"];
    [dic4 setValue:@"activity_area_img" forKey:@"pic"];
    
    [_dataArr1 addObject:dic1];
    [_dataArr1 addObject:dic2];
    [_dataArr1 addObject:dic3];
    [_dataArr1 addObject:dic4];
    
    _dataArr2 = [HHConfig sharedManager].hotTopicArr;
    
}

-(void)addMyTableView{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, screen_width, screen_height-49) style:UITableViewStyleGrouped];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
    [self setupRefresh];
    [self loadFirstPageData];
}

-(void)loadFirstPageData{
    _currentPage = 1;
    [self loadData:_currentPage];
}

-(void)loadData:(NSInteger)Page{
    
    NSString *r = @"topic";
    NSString *login_info = @"010000005EBBA6009CE535551C1917574FAFAE4E8BF03B02E6AD6D074AD69809B5AD76DFB9B12D28";
    NSString *page = [NSString stringWithFormat:@"%ld",(long)Page];
    NSString *type = @"update";
    NSDictionary *dic = @{@"r":r,
                          @"login_info":login_info,
                          @"page":page,
                          @"type":type};
    [[NetworkSingleton sharedManager] getTuijianAttResult:dic successBlock:^(id responseBody){
        NSLog(@"热门话题成功");
        for (TuijianAttModel *tuijian in responseBody) {
            [_dataArr3 addObject:tuijian];
        }
        [self.tableView reloadData];
        [self performSelectorOnMainThread:@selector(reloadTable) withObject:nil waitUntilDone:YES];
        
    } failureBlock:^(NSString *error){
        NSLog(@"%@",error);
    }];
}

/**
 *  集成刷新控件
 */
-(void)setupRefresh{
    //1.下拉刷新
    //    [self.tableView addHeaderWithTarget:self action:@selector(headerRefreshing)];
//    [self.tableView addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(headerRefreshing)];
    //2.进入程序后自动刷新
    [self.tableView.header beginRefreshing];
    
    //3.上拉加载更多(进入刷新状态就会调用self的footerRefreshing)
    //    [self.tableView addFooterWithTarget:self action:@selector(footerRefreshing)];
    [self.tableView addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(footerRefreshing)];
    
    //设置文字(也可不设置,默认的文字在MJRefreshConst中修改))
    [self.tableView.header setTitle:@"下拉刷新" forState:MJRefreshHeaderStateIdle];
    [self.tableView.header setTitle:@"松开刷新" forState:MJRefreshHeaderStatePulling];
    [self.tableView.header setTitle:@"刷新中" forState:MJRefreshHeaderStateRefreshing];
    
    [self.tableView.footer setTitle:@"点击或上拉加载更多" forState:MJRefreshFooterStateIdle];
    [self.tableView.footer setTitle:@"加载中..." forState:MJRefreshFooterStateRefreshing];
    [self.tableView.footer setTitle:@"没有更多" forState:MJRefreshFooterStateNoMoreData];
}
#pragma mark 开始进入刷新状态
-(void)headerRefreshing{
    [self loadFirstPageData];
}
#pragma mark 下拉刷新
-(void)footerRefreshing{
    _currentPage++;
    [self loadData:_currentPage];
}
#pragma mark 刷新tableview
-(void)reloadTable{
    //    [self.tableView reloadData];
    [self.tableView.header endRefreshing];
    [self.tableView.footer endRefreshing];
}







#pragma mark - UITableViewDataSource
//组数
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}
//每组的行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 4;
    }else if(section == 1){
        return 4;
    }else{
        return _dataArr3.count;
    }
}
//cell
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        static NSString *disCellIndentifier1 = @"disCell1";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:disCellIndentifier1];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:disCellIndentifier1];
        }
        //赋值
        cell.textLabel.text = [[_dataArr1 objectAtIndex:indexPath.row] objectForKey:@"title"];
        NSString *imgStr = [[_dataArr1 objectAtIndex:indexPath.row] objectForKey:@"pic"];
        cell.imageView.image = [UIImage imageNamed:imgStr];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }else if(indexPath.section == 1){
        static NSString *disCellIndentifier2 = @"disCell2";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:disCellIndentifier2];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:disCellIndentifier2];
        }
        //赋值
//        TuijianAttModel *tuijianModel = [[TuijianAttModel alloc] init];
        if (_dataArr2.count>0) {
            TuijianAttModel *tuijianModel = _dataArr2[indexPath.row];
            cell.textLabel.text = tuijianModel.content;
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",tuijianModel.number];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }else{
        static NSString *disCellIndentifier3 = @"disCell3";
        HotTopicCell *cell = (HotTopicCell *)[tableView dequeueReusableCellWithIdentifier:disCellIndentifier3];
        if (cell == nil) {
            cell = [[HotTopicCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:disCellIndentifier3];
        }
        if (_dataArr3.count>0) {
//            TuijianAttModel *tuijianModel = [[TuijianAttModel alloc] init];
            TuijianAttModel *tuijianModel = _dataArr3[indexPath.row];
            [cell setData:tuijianModel];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }
}
#pragma mark - UITableViewDelegate
//行高
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}
//组标题高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 10;
    }else{
        return 15;
    }
}
//标题
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return nil;
    }else if(section == 1){
        return @"推荐话题";
    }else{
        return @"热门话题";
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    JokeViewController *jokeVC = [[JokeViewController alloc] init];
    if (indexPath.section == 0) {
        jokeVC.title = [_dataArr1[indexPath.row] objectForKey:@"title"];
    }else if (indexPath.section == 1){
        jokeVC.title = ((TuijianAttModel *)(_dataArr2[indexPath.row])).content;
    }else{
        jokeVC.title = ((TuijianAttModel *)(_dataArr2[indexPath.row])).content;
    }
    [self.navigationController pushViewController:jokeVC animated:YES];
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

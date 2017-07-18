//
//  AttentionView.m
//  aoyouHH
//
//  Created by jinzelu on 15/4/21.
//  Copyright (c) 2015年 jinzelu. All rights reserved.
//

#import "AttentionView.h"
#import "ReAttentionCell.h"
#import "NetworkSingleton.h"
#import "TuijianAttModel.h"
#import "MJRefresh.h"
#import "CustomCell.h"
#import "HHConfig.h"

@interface AttentionView ()<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *_dataSource;//tableview的数据源
    NSMutableArray *_tuiJianArr;//推荐关注数组
    NSMutableArray *_attentionArr;//关注的数组
    NSInteger _page;
}

@end


NSString *const AttentionCellIndentifier1 = @"tuijianCell";
NSString *const AttentionCellIndentifier2 = @"myAttentionCell";


@implementation AttentionView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        //
        self.backgroundColor = RGB(248, 248, 248);
        _page = 0;
        [self addMyTableView];
    }
    return self;
}

-(void)initData{
    _dataSource = [[NSMutableArray alloc] init];
    _tuiJianArr = [[NSMutableArray alloc] init];
    _attentionArr = [[NSMutableArray alloc] init];

    [_dataSource addObject:_tuiJianArr];
    [_dataSource addObject:_attentionArr];
    
}


-(void)addMyTableView{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, screen_width, screen_height-64-49) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"ReAttentionCell" bundle:nil] forCellReuseIdentifier:AttentionCellIndentifier1];
    [self.tableView registerNib:[UINib nibWithNibName:@"CustomCell" bundle:nil] forCellReuseIdentifier:AttentionCellIndentifier2];
    [self addSubview:self.tableView];
    [self setupRefresh];
    
}

-(void)loadFirstPageData{
    [self initData];
    _page = 1;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self loadData:_page];
    });    
//    [self performSelectorOnMainThread:@selector(reloadTable) withObject:nil waitUntilDone:YES];
}

-(void)loadData:(NSInteger)Page{
    NSString *r = @"topic";
    NSString *login_info = @"010000005EBBA6009CE535551C1917574FAFAE4E8BF03B02E6AD6D074AD69809B5AD76DFB9B12D28";
    NSString *page = [NSString stringWithFormat:@"%ld",(long)Page];
    NSString *type = @"recommend";
    NSDictionary *dic = @{@"r":r,
                          @"login_info":login_info,
                          @"page":page,
                          @"type":type};
    [[NetworkSingleton sharedManager] getTuijianAttResult:dic successBlock:^(id responseBody){
        
        NSLog(@"推荐关注成功");
        NSMutableArray *arr = [[NSMutableArray alloc] initWithArray:responseBody];
        _tuiJianArr = responseBody;
        [HHConfig sharedManager].hotTopicArr = _tuiJianArr;
        [self.tableView reloadData];
        [self performSelectorOnMainThread:@selector(reloadTable) withObject:nil waitUntilDone:YES];
    } failureBlock:^(NSString *error){
        [self performSelectorOnMainThread:@selector(reloadTable) withObject:nil waitUntilDone:YES];
        NSLog(error);
    }];
}

/**
 *  集成刷新控件
 */
-(void)setupRefresh{
    //1.下拉刷新
//    [self.tableView addHeaderWithTarget:self action:@selector(headerRefreshing)];
    [self.tableView addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(headerRefreshing)];
    //2.进入程序后自动刷新
//    [self.tableView headerBeginRefreshing];
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
    _page++;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self loadData:_page];
    });
}
#pragma mark 下拉刷新
-(void)footerRefreshing{
    [self.tableView.footer noticeNoMoreData];
//    [self.tableView.footer endRefreshing];
//    [self.tableView.footer resetNoMoreData];
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
    return 2;
}
//每组的行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        if (_tuiJianArr.count>0) {
            return 4;
        }else{
            return 0;
        }
    }else{
        if (_attentionArr.count == 0) {
            return 1;
        }else{
            return _attentionArr.count;
        }
    }
}

//cell
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        ReAttentionCell *cell = (ReAttentionCell *)[tableView dequeueReusableCellWithIdentifier:AttentionCellIndentifier1];
        //赋值
        
//        TuijianAttModel *tuijianModel = [[TuijianAttModel alloc] init];
        if (_tuiJianArr.count>0) {
            TuijianAttModel *tuijianModel = _tuiJianArr[indexPath.row];
            
            
            cell.titleLabel.text = tuijianModel.content;
            NSString *numStr = [NSString stringWithFormat:@"%@",tuijianModel.number];
            cell.numberLable.text = [NSString stringWithFormat:@"帖子数：%@",numStr];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        return cell;
        
    }else{
        CustomCell *cell = (CustomCell *)[tableView dequeueReusableCellWithIdentifier:AttentionCellIndentifier2];
        
        //赋值
        cell.MsgLabel.text = @"还没有关注任何话题，关注一个吧";
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
    
}

#pragma mark - UITableViewDelegate
//
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return @"推荐关注";
    }else{
        return @"我的关注";
    }
}
//行高
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        return 100;
    }
    return 60;
}
//
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 30;
    }else{
        return 10;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}





/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

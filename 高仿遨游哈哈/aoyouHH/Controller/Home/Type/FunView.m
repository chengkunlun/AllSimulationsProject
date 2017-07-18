//
//  FunView.m
//  aoyouHH
//
//  Created by jinzelu on 15/4/21.
//  Copyright (c) 2015年 jinzelu. All rights reserved.
//

#import "FunView.h"
#import "MJRefresh.h"
#import "JokeModel.h"
#import "JokeCell.h"
#import "NetworkSingleton.h"

@interface FunView ()<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *_dataSources;
    NSInteger _currentPage;
    
    NSInteger _marginTop;
}

@end

NSString *const FunCellIndentifier = @"JokeCell";

@implementation FunView


-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self initData];
        [self addMyTableView];
    }
    return self;
}

-(void)initData{
    _dataSources = [[NSMutableArray alloc] init];
    _currentPage = 1;
    _marginTop = 5;
}

-(void)addMyTableView{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, screen_width, screen_height-64-49)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = RGB(241, 241, 241);
    [self.tableView registerClass:[JokeCell class] forCellReuseIdentifier:FunCellIndentifier];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self addSubview:self.tableView];
    [self setupRefresh];
}


-(void)loadFirstPageData{
    _currentPage = 1;
    [_dataSources removeAllObjects];
    [self getHotestData:_currentPage];
}

-(void)getHotestData:(NSInteger)currentPage{
    NSString *r = @"joke_list";
    NSString *drive_info = @"61f8612436df7ac7f0142a2de879846475f80000";
    NSString *page = [NSString stringWithFormat:@"%ld",currentPage];
    NSString *offset = @"10";
    NSString *type = @"pic";
    NSDictionary *dic = @{
                          @"r":r,
                          @"drive_info":drive_info,
                          @"page":page,
                          @"offset":offset,
                          @"type":type
                          };
    [[NetworkSingleton sharedManager] getHotestResule:dic successBlock:^(id responseBody){
        NSLog(@"趣图成功");
        for (JokeModel *joke in responseBody) {
            [_dataSources addObject:joke];
        }
        [self.tableView reloadData];
        [self performSelectorOnMainThread:@selector(reloadTable) withObject:nil waitUntilDone:YES];
    } failureBlock:^(NSString *error){
        NSLog(error);
        [self performSelectorOnMainThread:@selector(reloadTable) withObject:nil waitUntilDone:YES];
    }];
}

-(void)OnTapPicImg:(UITapGestureRecognizer *)sender{
    NSInteger tag = sender.view.tag;
    JokeModel *joke = _dataSources[tag-6000];
    NSMutableArray *imgArray = [[NSMutableArray alloc] init];
    NSString *urlStr = [NSString stringWithFormat:@"%@%@big/%@", URL_IMAGE, joke.pic.path, joke.pic.name];
    [imgArray addObject:urlStr];
    [self.delegate didSelectImageFunView:imgArray currentIndex:0];
    
    //    JZAlbumViewController *jzAlbumVC = [[JZAlbumViewController alloc] init];
    //    jzAlbumVC.imgArr = imgArray;
    //    jzAlbumVC.currentIndex = 1;
    //    [self presentModalViewController:jzAlbumVC animated:YES];
}


#pragma mark 集成刷新控件
-(void)setupRefresh{
    //1.下拉刷新
    [self.tableView addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(headerRefreshing)];
    //2.进入程序后自动刷新
    //    [self.tableView.header beginRefreshing];
    
    //3.上拉加载更多(进入刷新状态就会调用self的footerRefreshing)
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
    [self getHotestData:_currentPage];
    //    [self.tableView.footer noticeNoMoreData];
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
//行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataSources.count;
}
//cell
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    JokeCell *cell = (JokeCell *)[tableView dequeueReusableCellWithIdentifier:FunCellIndentifier];
    if (_dataSources.count>0) {
        //
        JokeModel *joke = _dataSources[indexPath.row];
        [cell setJokeData:joke];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(OnTapPicImg:)];
    [cell.picImg addGestureRecognizer:tap];
    cell.picImg.userInteractionEnabled = YES;//不能少了这句
    cell.picImg.tag = 6000+indexPath.row;
    
    return cell;
}

#pragma mark - UITableViewDelegate
//行高
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height = 0;
    height=_marginTop + height + _marginTop + 30 + _marginTop;
    if (_dataSources.count>0) {
        JokeModel *joke = _dataSources[indexPath.row];
        NSLog(@"趣图：joke.height:%f",joke.height);
        return joke.height;
        
        
        CGSize contentSize = [joke.content sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(screen_width-8*2, 100) lineBreakMode:UILineBreakModeTailTruncation];
        height =height + contentSize.height;
        
        if (joke.pic!=nil) {
            //
            NSString *urlStr = [NSString stringWithFormat:@"%@%@normal/%@", URL_IMAGE, joke.pic.path, joke.pic.name];
            NSURL *url = [NSURL URLWithString:urlStr];
            UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
            height = height + _marginTop + image.size.height;
        }else{
            height = height +_marginTop;
        }
        height = height +_marginTop+30;
        //        NSLog(@"222222height:%f",height);
        return height + _marginTop;
    }else{
        return 160;
    }
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    JokeModel *joke = [[JokeModel alloc] init];
    JokeModel *joke = (JokeModel *)_dataSources[indexPath.row];
    [self.delegate didSelectRowAtIndexPathFunView:indexPath jokeData:joke];
}











/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

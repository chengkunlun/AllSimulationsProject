//
//  JokeDetailViewController.m
//  aoyouHH
//
//  Created by jinzelu on 15/4/24.
//  Copyright (c) 2015年 jinzelu. All rights reserved.
//

#import "JokeDetailViewController.h"
#import "NetworkSingleton.h"
#import "JokeCell.h"
#import "CustomCell.h"
#import "JZAlbumViewController.h"
#import "commentCell.h"
#import "CommentModel.h"
#import "UIImageView+WebCache.h"
#import "MJRefresh.h"

@interface JokeDetailViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UIView *_backView;
    JokeModel *_jokeData;//joke数据
    NSMutableArray *_commentArray;//评论数据
    CGFloat _marginTop;
    NSInteger _contenType;
    
    NSInteger _currentPage;
}
@end

NSString *const jokeDetailCellIndentifier1 = @"jokeCell";
NSString *const jokeDetailCellIndentifier2 = @"customCell";
NSString *const jokeDetailCellIndentifier3 = @"commentCell";

@implementation JokeDetailViewController

+(JokeDetailViewController *)shareManeger{
    static JokeDetailViewController *sharedJokeDetailVC = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedJokeDetailVC = [[self alloc] init];
    });
    return sharedJokeDetailVC;
}

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        //
        NSLog(@"JokeDetailViewController===initWithNibName");
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController setNavigationBarHidden:NO];
    }
    return self;
}

-(id)init{
    self = [super init];
    if (self) {
        //
        _jokeData = self.joke;
        NSLog(@"JokeDetailViewController===init");
    }
    return self;
}

-(void)setData:(JokeModel *)joke{
    self.joke = joke;
    [self.tableView reloadData];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = RGB(241, 241, 241);
    NSLog(@"viewdidload");
    [self initData];
    [self addJokeViews];
//    [self loadJokeData];
    
    //获取评论
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        //加载数据
        [self loadFirstPage];
        dispatch_async(dispatch_get_main_queue(), ^{
            
        });
    });
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)addJokeViews{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, screen_width, screen_height) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[JokeCell class] forCellReuseIdentifier:jokeDetailCellIndentifier1];
    [self.tableView registerNib:[UINib nibWithNibName:@"CustomCell" bundle:nil] forCellReuseIdentifier:jokeDetailCellIndentifier2];
    [self.tableView registerNib:[UINib nibWithNibName:@"commentCell" bundle:nil] forCellReuseIdentifier:jokeDetailCellIndentifier3];
    [self.view addSubview:self.tableView];
    [self setupRefresh];
}

-(void)initData{
    _jokeData = [[NSMutableArray alloc] init];
    _commentArray = [[NSMutableArray alloc] init];
    _jokeData = self.joke;//接收上一个界面传来的数据
    _marginTop = 5.0;
    _contenType = 1;
}

-(void)loadJokeData{
    NSString *r = @"joke_one";
    NSString *drive_info = DRIVE_INFO;
    NSString *login_info = LOGIN_INFO_NO;
    NSString *jid = [NSString stringWithFormat:@"%@",self.joke.id];
    NSDictionary *dic = @{
                          @"r":r,
                          @"drive_info":drive_info,
                          @"login_info":login_info,
                          @"jid":jid
                          };
    [[NetworkSingleton sharedManager] getOneJokeResule:dic successBlock:^(id responbody){
        NSLog(@"joke详情成功");
    } failureBlock:^(NSString *error){
        NSLog(@"%@",error);
    }];
}

-(void)loadFirstPage{
    _currentPage = 1;
    [_commentArray removeAllObjects];
    [self loadCommentData:_currentPage];
}

-(void)loadCommentData:(NSInteger)pageIndex{
    NSString *r = @"comment_list";
    NSString *drive_info = @"61f8612436df7ac7f0142a2de879846475f80000";
    NSString *login_info = @"010000005EBBA600A79E395527D21A574FAFAE4E80AA21C4C50B125F75E290A38461662144239A7A";
    NSString *order = @"time";
    NSString *jid = [NSString stringWithFormat:@"%@",self.joke.id];
    NSString *page = [NSString stringWithFormat:@"%ld",pageIndex];
    NSString *offset = @"20";
    NSDictionary *dic = @{
                          @"r":r,
                          @"drive_info":drive_info,
                          @"login_info":login_info,
                          @"order":order,
                          @"jid":jid,
                          @"page":page,
                          @"offset":offset};
    [[NetworkSingleton sharedManager] getCommentResult:dic successBlock:^(id responbody){
        NSLog(@"获取评论成功");
        if (((NSMutableArray *)responbody).count == 0) {
            [self.tableView.footer noticeNoMoreData];
        }
        for (CommentModel *comment in responbody) {
            [_commentArray addObject:comment];
        }
        [self.tableView reloadData];
        [self performSelectorOnMainThread:@selector(reloadTable) withObject:nil waitUntilDone:YES];
        if (((NSMutableArray *)responbody).count == 0) {
            [self.tableView.footer noticeNoMoreData];
        }
    } failureBlock:^(NSString *error){
        NSLog(@"%@",error);
        [self performSelectorOnMainThread:@selector(reloadTable) withObject:nil waitUntilDone:YES];
    }];
}

//图片点击事件
-(void)OnTapPicImg:(UITapGestureRecognizer *)sender{
    NSMutableArray *imgArray = [[NSMutableArray alloc] init];
    NSString *urlStr = [NSString stringWithFormat:@"%@%@big/%@", URL_IMAGE, _jokeData.pic.path, _jokeData.pic.name];
    [imgArray addObject:urlStr];
    
    JZAlbumViewController *jzAlbumVC = [[JZAlbumViewController alloc] init];
    jzAlbumVC.imgArr = imgArray;
    jzAlbumVC.currentIndex = 0;
    [self presentViewController:jzAlbumVC animated:YES completion:nil];
    
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
    [self loadFirstPage];
}
#pragma mark 下拉刷新
-(void)footerRefreshing{
    _currentPage++;
    [self loadCommentData:_currentPage];
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
//行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }else{
        if (_commentArray.count == 0) {
            return 1;
        }else{
            return _commentArray.count;
        }
    }
}
//cell
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        NSLog(@"详情cell");
        JokeCell *cell = (JokeCell *)[tableView dequeueReusableCellWithIdentifier:jokeDetailCellIndentifier1];
        if (_jokeData!=nil) {
            dispatch_async(dispatch_get_main_queue(), ^{
                cell.contentType = _contenType;
                [cell setJokeData:_jokeData];
            });
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UITapGestureRecognizer *singletap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(OnTapPicImg:)];
        [cell.picImg addGestureRecognizer:singletap];
        cell.picImg.userInteractionEnabled = YES;
        
        return cell;
    }else{
        if (_commentArray.count == 0) {
            CustomCell *cell = (CustomCell *)[tableView dequeueReusableCellWithIdentifier:jokeDetailCellIndentifier2];
            //赋值
            cell.MsgLabel.text = @"快快来抢沙发";
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }else{
            commentCell *cell = (commentCell *)[tableView dequeueReusableCellWithIdentifier:jokeDetailCellIndentifier3];
            //赋值
//            CommentModel *comment = [[CommentModel alloc] init];
            CommentModel *comment = _commentArray[indexPath.row];
            cell.userNameLable.text = comment.user_name;
            cell.commentLabel.text = [comment.content stringByReplacingOccurrencesOfString:@"<br />" withString:@""];
            [cell.userImg sd_setImageWithURL:[NSURL URLWithString:comment.user_pic] placeholderImage:[UIImage imageNamed:@"comment_avatar_img"]];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        
    }
}

#pragma mark - UITableViewDelegate
//行高
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        CGFloat height = 0;
        height=_marginTop + height + _marginTop + 30 + _marginTop;
//        if (_jokeData!=nil) {
            JokeModel *joke = _jokeData;
        
        return joke.MaxHeight;
        
        CGSize contentSize = {0,0};
        
        if (_contenType == 0) {
            contentSize = [joke.content sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(screen_width-8*2, 100) lineBreakMode:UILineBreakModeTailTruncation];
        }else{
            contentSize = [joke.content sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(screen_width-8*2, 1000) lineBreakMode:UILineBreakModeTailTruncation];
        }
        
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
        CGFloat height = 0.0;
        height = _marginTop + 15;
        
        if (_commentArray.count>0) {
            CGSize contentSize = {0,0};
            contentSize = [((CommentModel *)_commentArray[indexPath.row]).content sizeWithFont:[UIFont systemFontOfSize:13] constrainedToSize:CGSizeMake(screen_width-16, 1000) lineBreakMode:UILineBreakModeWordWrap];
            height = height + contentSize.height + _marginTop;
            
            return height + _marginTop;
        }else{
            return 100;
        }
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 10;
    }else{
        return 10.0f;
    }
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

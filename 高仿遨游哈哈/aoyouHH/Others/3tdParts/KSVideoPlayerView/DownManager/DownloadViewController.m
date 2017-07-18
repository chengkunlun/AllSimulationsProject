//
//  DownloadViewController.m


#import "DownloadViewController.h"
#import "FilesDownManage.h"
#import "VedioView.h"
#import "VedioDetailViewController.h"
#define OPENFINISHLISTVIEW

@interface DownloadViewController ()<VedioCellDelegate>
@property (retain, nonatomic) IBOutlet UIView *moveLine;

@end

@implementation DownloadViewController

@synthesize downloadingTable;
@synthesize finishedTable;
@synthesize downingList;
@synthesize finishedList;



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [downingList release];
    [finishedList release];
    [_downBackV release];
    [downloadingTable release];
    [finishedTable release];
    [_editbtn release];
    [clearallbtn release];
    [backbtn release];
    [_diskInfoLab release];
    [_bandwithLab release];
    [_noLoadsInfo release];

    [_downloadingViewBtn release];
    [_finieshedViewBtn release];
    [super dealloc];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [[BaiduMobStat defaultStat] pageviewStartWithName:self.navigationItem.title];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[BaiduMobStat defaultStat] pageviewEndWithName:self.navigationItem.title];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

//- (BOOL)hidesBottomBarWhenPushed {
//    return [self.navigationController.visibleViewController isEqual:self];
//}


- (void)initView{
//    [[self navigationController] setNavigationBarHidden:NO animated:YES];
    [self getLeftMemuButton];
    self.title = @"我的下载";
    self.view.backgroundColor = changeColor( k_color_view_bg,RGB(31, 46, 60));
    
   
   

}

- (void)StopActionNot
{
    [self ReloadDownLoadingTable];
}

#pragma mark left
- (void)left
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark 加载导航栏左侧菜单按钮
- (void)getLeftMemuButton
{
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame = CGRectMake(10, 0, 12.5, 20.5);
    [leftButton setImage:[UIImage imageNamed:@"真题词汇_背单词__0011_Back-icon"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(left) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
}


- (IBAction)goDownloadingView:(UIButton *)sender {
    downloadingTable.hidden = NO;
    finishedTable.hidden =YES;
    clearallbtn.hidden = YES;
    self.finieshedViewBtn.selected = NO;
    self.downloadingViewBtn.selected = YES;
    [self.downloadingTable reloadData];
    [UIView animateWithDuration:0.5 animations:^{
        self.moveLine.frame = CGRectMake(0, self.moveLine.frame.origin.y, self.moveLine.frame.size.width, self.moveLine.frame.size.height);
    }];
}

- (IBAction)goFinishedView:(UIButton *)sender {
    downloadingTable.hidden = YES;
    finishedTable.hidden =NO;
    clearallbtn.hidden = NO;
    self.finieshedViewBtn.selected =YES;
    self.downloadingViewBtn.selected = NO;
    [self.finishedTable reloadData];
    self.noLoadsInfo.hidden = YES;
    [UIView animateWithDuration:0.5 animations:^{
        self.moveLine.frame = CGRectMake(screen_width / 2, self.moveLine.frame.origin.y, self.moveLine.frame.size.width, self.moveLine.frame.size.height);
    }];
}

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)showFinished
{
    [self startFlipAnimation:0];
    self.navigationItem.rightBarButtonItem= [self makeCustomRightBarButItem:@"下载中" action:@selector(showDowning)];
}

-(void)showDowning
{
    [self startFlipAnimation:1];
    self.navigationItem.rightBarButtonItem=[self makeCustomRightBarButItem:@"已下载" action:@selector(showFinished)];
}


-(void)startFlipAnimation:(NSInteger)type
{   
    CGContextRef context=UIGraphicsGetCurrentContext();
    [UIView beginAnimations:nil context:context];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:1.0f];
    UIView *lastView=[self.view viewWithTag:103];
    
    if(type==0)
    {
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:lastView cache:YES];
    }
    else
    {
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:lastView cache:YES];
    }
    
    UITableView *frontTableView=(UITableView *)[lastView viewWithTag:101];
    UITableView *backTableView=(UITableView *)[lastView viewWithTag:102];
    NSInteger frontIndex=[lastView.subviews indexOfObject:frontTableView];
    NSInteger backIndex=[lastView.subviews indexOfObject:backTableView];
    [lastView exchangeSubviewAtIndex:frontIndex withSubviewAtIndex:backIndex];
    [UIView commitAnimations];
}


-(IBAction)enterEdit:(UIButton*)sender
{
    sender.selected = !sender.selected;
    if (!sender.selected) {
        [self.downloadingTable setEditing:NO animated:YES];
        [self.finishedTable setEditing:NO animated:YES];
        backbtn.hidden = NO;
        clearallbtn.hidden = YES;
        
    }else{
    [self.downloadingTable setEditing:YES animated:YES];
    [self.finishedTable setEditing:YES animated:YES];
        backbtn.hidden = YES;
        clearallbtn.hidden = NO;
    }
}

-(IBAction)clearlist:(UIButton *)sender{
    if ([self.finishedList count]==0)
        return;
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"删除已完成列表的所有内容，将不会删除对应的文件，确认删除吗?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
    [alert show];
    [alert release];
    return;
}
-(void)clearAction{
    if (!self.downloadingTable.hidden) {
        if ([self.downingList count]>0) {
            FilesDownManage *filedownmanage = [FilesDownManage sharedFilesDownManage];
            [filedownmanage clearAllRquests];
            [self.downingList removeAllObjects];
            [self.downloadingTable reloadData];
        }
    }else if (!self.finishedTable.hidden){
        if ([self.finishedList count]>0) {
            FilesDownManage *filedownmanage = [FilesDownManage sharedFilesDownManage];
            [filedownmanage clearAllFinished];
            [self.finishedList removeAllObjects];
            [self.finishedTable reloadData];
        }
    }
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==1) {
        [self clearAction];
    }
}
#pragma mark - View lifecycle

-(void)viewWillAppear:(BOOL)animated
{
    FilesDownManage *filedownmanage = [FilesDownManage sharedFilesDownManage];
    [filedownmanage startLoad];
    self.downingList=filedownmanage.downinglist;
    [self.downloadingTable reloadData];
    
    self.finishedList=filedownmanage.finishedlist;
    [self.finishedTable reloadData];

}
-(void)viewWillDisappear:(BOOL)animated{
    FilesDownManage *filedownmanage = [FilesDownManage sharedFilesDownManage];
    [filedownmanage saveFinishedFile];
}
- (void)viewDidLoad
{
    self.title = @"我的下载";
    [super viewDidLoad];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(StopActionNot) name:@"StopActionNot" object:nil];
    self.downBackV.backgroundColor = changeColor(RGB(249, 249, 249) ,RGB(53, 74, 94));
    self.downloadingTable.backgroundColor = changeColor( k_color_view_bg,RGB(31, 46, 60));
    self.finishedTable.backgroundColor = changeColor( k_color_view_bg,RGB(31, 46, 60));
    
    [FilesDownManage sharedFilesDownManageWithBasepath:@"DownLoad" TargetPathArr:[NSArray arrayWithObject:@"DownLoad/video"]];
 
     version =[[[UIDevice currentDevice] systemVersion] floatValue];
    
    [FilesDownManage sharedFilesDownManage].downloadDelegate = self;

    downloadingTable.hidden = NO;
    finishedTable.hidden =YES;
    self.finieshedViewBtn.selected = NO;
    self.downloadingViewBtn.selected = YES;
    clearallbtn.hidden = YES;
    self.diskInfoLab.text = [CommonHelper getDiskSpaceInfo];
   
    [self initView];
}

- (void)viewDidUnload
{
    [self setDownloadingViewBtn:nil];
    [self setFinieshedViewBtn:nil];
    
    [self setEditbtn:nil];
    [clearallbtn release];
    clearallbtn = nil;
    [backbtn release];
    backbtn = nil;
    [self setDiskInfoLab:nil];
    [self setBandwithLab:nil];
    [self setNoLoadsInfo:nil];
   
    self.downloadingTable=nil;
    self.finishedTable=nil;
     [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
-(UIBarButtonItem*)makeCustomRightBarButItem:(NSString *)titlestr action:(SEL)action{
    CGRect frame_1= CGRectMake(0, 0, 45, 27);
//    UIImage* image= [UIImage imageNamed:@"顶部按钮背景.png"];
    UIButton* showfinishbtn= [[UIButton alloc] initWithFrame:frame_1];
    showfinishbtn.backgroundColor = navigationBarBackColor;
//    [showfinishbtn setBackgroundImage:image forState:UIControlStateNormal];
    [showfinishbtn setTitle:titlestr forState:UIControlStateNormal];
    [showfinishbtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    showfinishbtn.titleLabel.font=[UIFont systemFontOfSize:14];
    [showfinishbtn addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem* showFinishedBarButtonItem= [[[UIBarButtonItem alloc] initWithCustomView:showfinishbtn]autorelease];
    [showfinishbtn release];
    return showFinishedBarButtonItem;
}

#pragma mark ---UITableView Delegate---
//-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//    if(tableView==self.downloadingTable)
//    {
//        return [self.downingList count]>0?[self.downingList count]:1;
//    }
//    return 1;
//}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView==self.downloadingTable)
    {
        if (self.downingList.count==0) {
            if (self.downloadingTable.hidden) {
                self.noLoadsInfo.hidden = YES;
            }else
                self.noLoadsInfo.hidden = NO;
            return 0;
        }else
            self.noLoadsInfo.hidden = YES;
        NSInteger rows = (self.downingList.count + kProductPerRow - 1) / kProductPerRow;
        return rows;
    }
    else
    {
        NSInteger rows = (self.finishedList.count + kProductPerRow - 1) / kProductPerRow;
        return rows;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView==self.downloadingTable)//正在下载的文件列表
    {
        static  NSString *ID = @"MyCell";
        LALTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if (!cell) {
            cell = [[LALTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
            cell.type = 3;
//            [cell setDelegate:self];
        }
        ASIHTTPRequest *theRequest=[self.downingList objectAtIndex:indexPath.row];
        if (theRequest==nil) {
            return cell=Nil;
        }
        cell.backgroundColor = changeColor( k_color_view_bg,RGB(31, 46, 60));
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        NSUInteger loc = indexPath.row * kProductPerRow;
        NSUInteger len = kProductPerRow;
        if (loc + len > downingList.count) {
            len = downingList.count - loc;
        }
        NSRange range = NSMakeRange(loc, len);
        NSArray *array = [self.downingList subarrayWithRange:range];
        [cell resetButttonWithDownFileArray:array];
        [cell setCellRow:indexPath.row];
        [cell setCellDeleteBalock:^{
            ASIHTTPRequest *theRequest=[self.downingList objectAtIndex:indexPath.row];
            [[FilesDownManage sharedFilesDownManage] deleteRequest:theRequest];
            [self.downloadingTable reloadData];
        }];
        return cell;
    }

    else if(tableView==self.finishedTable)//已完成下载的列表
    {
        static  NSString *ID = @"MyCell";
        LALTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if (!cell) {
            cell = [[LALTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
            cell.type = 2;
            [cell setDelegate:self];
        }
        cell.backgroundColor = changeColor( k_color_view_bg,RGB(31, 46, 60));
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        NSUInteger loc = indexPath.row * kProductPerRow;
        NSUInteger len = kProductPerRow;
        if (loc + len > finishedList.count) {
            len = finishedList.count - loc;
        }
        NSRange range = NSMakeRange(loc, len);
        NSArray *array = [finishedList subarrayWithRange:range];
        [cell resetButttonWithFileArray:array];
        [cell setCellRow:indexPath.row];
        [cell setCellDeleteBalock:^{
            FileModel *selectFile=[self.finishedList objectAtIndex:indexPath.row];
            [[FilesDownManage sharedFilesDownManage]  deleteFinishFile:selectFile];
            [self.finishedTable reloadData];
        }];
        [cell setCellStopBalock:^{
        }];
        return cell;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 170;
}

- (void)VedioCell:(LALTableViewCell *)VedioCell didSelectedAtIndex:(NSInteger)index
{
    VedioDetailViewController *vedioDetaioVC = [[VedioDetailViewController alloc] initWithNibName:@"VedioDetailViewController" bundle:nil];
    FileModel *fileModel = [self.finishedList objectAtIndex:index];
    vedioDetaioVC.teacherName = fileModel.teacherName;
    vedioDetaioVC.teacherJS = fileModel.teacherJS;
    vedioDetaioVC.videoName = [fileModel.fileName stringByReplacingOccurrencesOfString:@".mp4" withString:@""];
    vedioDetaioVC.videoTime = fileModel.vedioTime;
    vedioDetaioVC.creatTime = fileModel.creatTime;
    vedioDetaioVC.imageURL = fileModel.imageUrl;
    vedioDetaioVC.bgImageString = fileModel.bgImageString;
    [MAAFConfig sharedInstance].videoId = fileModel.videoID;
    [self presentViewController:vedioDetaioVC animated:YES completion:nil];
}

-(void)updateCellOnMainThread:(FileModel *)fileInfo
{
    NSArray* cellArr = [self.downloadingTable visibleCells];
    for(int i = 0;i<cellArr.count;i++)
    {
        
            LALTableViewCell *cell=cellArr[i];
                NSString *currentsize;
                   currentsize = fileInfo.fileReceivedSize;
                NSString *totalsize = [CommonHelper getFileSizeString:fileInfo.fileSize];
                cell.fileCurrentSize.text=[CommonHelper getFileSizeString:currentsize];
                cell.fileSize.text = [NSString stringWithFormat:@"%@",totalsize];
                MyLog(@"%@*******",totalsize);
                [cell.progress1 setProgress:[CommonHelper getProgress:[fileInfo.fileSize floatValue] currentSize:[currentsize floatValue]]];
                MyLog(@"%f^^^^^^",cell.progress1 .progress);
                cell.progress = [totalsize floatValue];
                cell.progress2 = [fileInfo.fileReceivedSize floatValue];
//                [cell setProcessBalock:^(VedioView *vedioView) {
//                    vedioView.progressView.progress = [fileInfo.fileReceivedSize floatValue]/[totalsize floatValue];
//                }];
        VedioView  *vedioView = cell.videoViewArray[i];
        float M = [totalsize floatValue]*1000000;
        float Z = [fileInfo.fileReceivedSize floatValue];
        vedioView.progressView.progress = Z/M;
        MyLog(@"!!!!!!!!!!!!!!!!!!!!!!!!!!!%f",[fileInfo.fileReceivedSize floatValue]);
        MyLog(@"!!!!!!!!!!!!!!!!!!!!!!!!!!!%f",[totalsize floatValue]*1000000);
        MyLog(@"!!!!!!!!!!!!!!!!!!!!!!!!!!!%f",Z/M);
        i++;
        }
}

#pragma mark --- updateUI delegate ---
-(void)startDownload:(ASIHTTPRequest *)request;
{
    NSLog(@"-------开始下载!");
}

-(void)updateCellProgress:(ASIHTTPRequest *)request;
{
    FileModel *fileInfo=[request.userInfo objectForKey:@"File"];
    [self performSelectorOnMainThread:@selector(updateCellOnMainThread:) withObject:fileInfo waitUntilDone:YES];
}

-(void)finishedDownload:(ASIHTTPRequest *)request;
{

    [self.downloadingTable reloadData];
     self.bandwithLab.text = @"0.00K/S";

    [self.finishedTable reloadData];

}
- (void)deleteFinishedFile:(FileModel *)selectFile
{
    self.finishedList = [FilesDownManage sharedFilesDownManage].finishedlist;
    [self.finishedTable reloadData];
}
-(void)ReloadDownLoadingTable
{
    self.downingList =[FilesDownManage sharedFilesDownManage].downinglist;
    [self.downloadingTable reloadData];
}


@end

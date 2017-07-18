//
//  CourseDetailViewController.m
//  aoyouHH
//
//  Created by jinzelu on 15/5/21.
//  Copyright (c) 2015年 jinzelu. All rights reserved.
//

#import "CourseDetailViewController.h"
#import "ClassCell.h"
#import "NetworkSingleton.h"
#import "MJExtension.h"

#import "CourseDetailModel.h"
#import "StepModel.h"
#import "ClassModel.h"
#import "VideoModel.h"
#import "VedioDetailViewController.h"

@interface CourseDetailViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *_dataSourceArr;
    NSMutableArray *_typeArr;
}
@end

NSString *const CourseDetCellIndentifier1 = @"titleClassCell";//章
NSString *const CourseDetCellIndentifier2 = @"classCell";//节

@implementation CourseDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"课程详情";
    _dataSourceArr = [[NSMutableArray alloc ]init];
    _typeArr = [[NSMutableArray alloc] init];
    
    [self initTableView];
    [self getCourseDetail];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initTableView{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, screen_width, screen_height) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    [self.tableView registerClass:[ClassCell class] forCellReuseIdentifier:CourseDetCellIndentifier2];
    
}

-(void)getCourseDetail{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_async(queue, ^{
        //加载数据
//        [self requestData];
        dispatch_async(dispatch_get_main_queue(), ^{
            //更新UI
            [self requestData];
            NSLog(@"更新UI");
        });
    });
}

-(void)requestData{
    NSString *sid = self.focus.SID;
    NSString *courseid = self.focus.CourseID;
    NSString *version = @"2.4.1.2";
    NSString *uid = @"5942916";
//    NSString *url = @"http://pop.client.chuanke.com/?mod=course&act=info&do=getClassList&sid=1562432&courseid=116310&version=2.4.1.2&uid=5942916";
    NSString *url = [NSString stringWithFormat:@"%@?mod=course&act=info&do=getClassList&sid=%@&courseid=%@&version=%@&uid=%@",URL_CHUANKE,sid,courseid,version,uid];
    [[NetworkSingleton sharedManager] getCourseDetailResult:nil url:url successBlock:^(id responseBody){
        NSLog(@"课程详情成功");
        CourseDetailModel *courseDetail = [CourseDetailModel objectWithKeyValues:responseBody];
        NSMutableArray *stepArray = [[NSMutableArray alloc] init];
        for (int i = 0; i < courseDetail.StepList.count; i++) {
            StepModel *step = [StepModel objectWithKeyValues:courseDetail.StepList[i]];
            [stepArray addObject:step];
            [_typeArr addObject:@"1"];
            for (int j = 0; j < step.ClassList.count; j++) {
                ClassModel *class = [ClassModel objectWithKeyValues:step.ClassList[j]];
                [stepArray addObject:class];
                [_typeArr addObject:@"2"];
            }
        }
        [_dataSourceArr addObjectsFromArray:stepArray];
        [self.tableView reloadData];
        NSLog(@"...");
    } failureBlock:^(NSString *error){
        NSLog(@"课程详情失败");
    }];
    
}

#pragma mark - UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSLog(@"count:%lu",(unsigned long)_dataSourceArr.count);
    return _dataSourceArr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([[_typeArr objectAtIndex:indexPath.row] isEqualToString:@"1"]) {
        return 40;
    }else{
        return 50;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([[_dataSourceArr objectAtIndex:indexPath.row] isKindOfClass:[StepModel class]]) {
        //章
        NSLog(@"章");
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CourseDetCellIndentifier1];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CourseDetCellIndentifier1];
            UIView *topLineView = [[UIView alloc] initWithFrame:CGRectMake(5, 0, screen_width-5, 0.5)];
            topLineView.backgroundColor = RGB(200, 199, 204);
            [cell.contentView addSubview:topLineView];
            
            UIView *bottomLineView = [[UIView alloc] initWithFrame:CGRectMake(5, 39.5, screen_width-5, 0.5)];
            bottomLineView.backgroundColor = RGB(200, 199, 204);
            [cell.contentView addSubview:bottomLineView];
        }
        //赋值
        cell.textLabel.text = ((StepModel *)[_dataSourceArr objectAtIndex:indexPath.row]).StepName;
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else{
        NSLog(@"节");
        ClassCell *cell = [tableView dequeueReusableCellWithIdentifier:CourseDetCellIndentifier2];
        ClassModel *classM = (ClassModel *)[_dataSourceArr objectAtIndex:indexPath.row];
        cell.titleLable.text = [NSString stringWithFormat:@"第%@节：%@", classM.ClassIndex,classM.ClassName];
        int length = [classM.VideoTimeLength intValue];
        cell.timeLabel.text = [NSString stringWithFormat:@"课程时长：%d分钟",length/60];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}
#pragma mark - UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([[_dataSourceArr objectAtIndex:indexPath.row] isKindOfClass:[ClassModel class]]) {
        VedioDetailViewController *videoVC = [[VedioDetailViewController alloc] init];
        ClassModel *classM = (ClassModel *)[_dataSourceArr objectAtIndex:indexPath.row];
        videoVC.FileUrl =[VideoModel objectWithKeyValues:classM.VideoUrl[0]].FileURL;
        NSLog(@"fileUrl:%@",videoVC.FileUrl);
        
        [self.navigationController pushViewController:videoVC animated:YES];
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

//
//  AlbumViewController.m
//  HXCJ
//
//  Created by ibokan on 13-4-30.
//  Copyright (c) 2013年 ibokan. All rights reserved.
//
#define KSCREEN_HIGHT [UIScreen mainScreen].bounds.size.height
#define KSCREEN_WIDTH [UIScreen mainScreen].bounds.size.width


#import "AlbumViewController.h"

#import "UIImageView+WebCache.h"
@interface AlbumViewController ()<UIGestureRecognizerDelegate>
{
    CGFloat lastScale;
    
    UIImageView *imageG;
}

@end

@implementation AlbumViewController


//右边返回按钮
-(void)returnBackl
{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    lastScale = 1.0;
    
    //edgesForExtendedLayout是一个类型为UIExtendedEdge的属性，指定边缘要延伸的方向。因为iOS7鼓励全屏布局，它的默认值很自然地是UIRectEdgeAll，四周边缘均延伸，就是说，如果即使视图中上有navigationBar，下有tabBar，那么视图仍会延伸覆盖到四周的区域。
    
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 7)
    {
        [self.navigationController.navigationBar  setBackgroundImage:[UIImage imageNamed:@"navgation.png"] forBarMetrics:UIBarMetricsDefault];
        if ([UIScreen mainScreen].bounds.size.height >500)
        {
            self.edgesForExtendedLayout = UIRectEdgeNone;//不自动延展
            //ios7 iphone5
            
            
        }
        else
        {
            self.edgesForExtendedLayout = UIRectEdgeNone;
            //ios 7 iphone 4
        }
    }
    else
    {
        [self.navigationController.navigationBar  setBackgroundImage:[UIImage imageNamed:@"navgation_4s.png"] forBarMetrics:UIBarMetricsDefault];
        if ([UIScreen mainScreen].bounds.size.height <500)
        {
            // ios 6 iphone4
            
            
        }
        else
        {
            //ios 6 iphone5
        }
    }
    
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],UITextAttributeTextColor,[UIFont systemFontOfSize:20],UITextAttributeFont, nil]];
    
    
    //左1上角按钮
    UIImage *imager1=[UIImage imageNamed:@"return.png"];
    UIButton *backButtonr1=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 22, 22)];
    [backButtonr1 setImage:imager1 forState:UIControlStateNormal];
    [backButtonr1 addTarget:self action:@selector(returnBackl) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barback=[[UIBarButtonItem alloc]initWithCustomView:backButtonr1];
    self.navigationItem.leftBarButtonItem=barback;
    
    
    self.navigationItem.title=@"图片群";
    
//    self.navigationController.navigationBarHidden = YES;
    
    self.view.backgroundColor=[UIColor blackColor];
    
    
    //定义一个滚动视图
    self.preScrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, KSCREEN_WIDTH, [UIScreen mainScreen].bounds.size.height)];
    self.preScrollView.pagingEnabled=YES;//可以翻页
    self.preScrollView.userInteractionEnabled=YES;//用户可交互
    self.preScrollView.showsHorizontalScrollIndicator = NO;
    self.preScrollView.contentSize=CGSizeMake((self.imgs.count)*KSCREEN_WIDTH, KSCREEN_HIGHT);//滚动的内容尺寸
    self.preScrollView.delegate=self;
    
    
    //    float width = CGRectGetWidth(self.preScrollView.frame);
    //    float height = CGRectGetHeight(self.preScrollView.frame);
    
    float width = self.view.frame.size.width;
    float height = self.view.frame.size.height;
    
    
    
    for (int i=0; i<self.imgs.count; i++) {
        id path=[self.imgs objectAtIndex:i];
        UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(width*i, 0, width, height)];
        imageView.tag = i+6000;
        imageView.contentMode=UIViewContentModeScaleAspectFit;
        imageView.userInteractionEnabled = YES;
        if ([path isKindOfClass:[NSString class]]) {
            [imageView sd_setImageWithURL:[NSURL URLWithString:path]placeholderImage:[UIImage imageNamed:@"zhanweitu.png"]];
            
        }else if([path isKindOfClass:[UIImage class]]){
            [imageView setImage:[self.imgs objectAtIndex:i]];
            
        }else{
            [imageView setImage:[UIImage imageNamed:@"zhanweitu.png"]];
            
        }
        
        
        // 点击手势
        UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGes:)];
        tapGes.numberOfTapsRequired = 1;
        tapGes.numberOfTouchesRequired = 1;
        
        // 放大手势
        UIPinchGestureRecognizer *pinGes = [[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(pinGes:)];
        pinGes.delegate = self;
        
        [imageView addGestureRecognizer:pinGes];
        
        [self.preScrollView addGestureRecognizer:tapGes];
        [self.preScrollView addSubview:imageView];
    }
    
    self.preScrollView.contentOffset = CGPointMake(width * (self.imageTag - 6000), 0);
    
    //定义一个label，显示第几张图片
    self.slidingLabel=[[UILabel alloc]initWithFrame:CGRectMake(40, [UIScreen mainScreen].bounds.size.height-64-45, 60, 40)];
    self.slidingLabel.backgroundColor = [UIColor clearColor];
    self.slidingLabel.font=[UIFont systemFontOfSize:18];
    self.slidingLabel.textColor = [UIColor whiteColor];
    
    // 显示数组里面图片有多少张
    
    self.slidingLabel.text = [NSString stringWithFormat:@"%d/%d", self.imageTag-6000 + 1,self.imgs.count];
    
    
    //注意scrollView和label的加载顺序
    [self.view addSubview:self.preScrollView];
    [self.view addSubview:self.slidingLabel];
    
}



#pragma mark --
-(void)tapGes:(UIPinchGestureRecognizer *)tap
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)pinGes:(UIPinchGestureRecognizer *)sender
{
    if ([sender state] == UIGestureRecognizerStateBegan) {
        lastScale = 1.0;
    }
    CGFloat scale = 1.0 - (lastScale - [sender scale]);
    
    lastScale = [sender scale];
    
    CATransform3D newTransform = CATransform3DScale(sender.view.layer.transform, scale, scale, 1);
    
    sender.view.layer.transform = newTransform;
    
    
    
    if ([sender state] == UIGestureRecognizerStateEnded) {
        
        // sender.view.layer.tr
    }
    
    //    self.preScrollView.contentSize=CGSizeMake((self.imgs.count)*KSCREEN_WIDTH, KSCREEN_HIGHT + 200);//滚动的内容尺寸
    
    
}







- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error
  contextInfo:(void *)contextInfo
{
    // Was there an error?
    if (error != NULL)
    {
        // Show error message...
        
        //alert
        UIAlertView* alert = [[UIAlertView alloc]
                              initWithTitle:@"提示"
                              message:@"此图片保存失败"
                              delegate:nil
                              cancelButtonTitle:@"确定"
                              otherButtonTitles:nil
                              ];
        [alert show];
        
        
    }
    else  // No errors
    {
        // Show message image successfully saved
        
        //alert
        UIAlertView* alert = [[UIAlertView alloc]
                              initWithTitle:@"提示"
                              message:@"此图片已经保存到相册，请到相册进行查看"
                              delegate:nil
                              cancelButtonTitle:@"确定"
                              otherButtonTitles:nil
                              ];
        [alert show];
        
    }
}

#pragma mark -- UIScrollView delegate foution
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    //    lastScale = 1.0;
    
    
    
    
    float width = CGRectGetWidth(self.preScrollView.frame);
    int i = scrollView.contentOffset.x / width + 1;
    self.slidingLabel.text = [NSString stringWithFormat:@"%d/%d",i,self.imgs.count];
    
    
    // DOTO:解决图片放大后问题
    int j = 0 ;
    
    for ( UIImageView *imgView in [scrollView subviews] ) {
        imgView.frame = CGRectMake(KSCREEN_WIDTH * j, 0, KSCREEN_WIDTH, KSCREEN_HIGHT);
        
        j++;
    }
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

//
//  PlayViewController.h
//  WordAndVocabulary
//
//  Created by 杨兴义 on 15/4/3.
//  Copyright (c) 2015年 Tom. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LALTableViewCell.h"
#import "DownloadDelegate.h"
#import "KSVideoPlayerView.h"
#import "FileModel.h"

@interface PlayViewController : UIViewController<playerViewDelegate>

@property (nonatomic,strong) FileModel *fileModel;

@end

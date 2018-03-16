//
//  FullViewController.m
//  02-远程视频播放(AVPlayer)
//
//  Created by apple on 15/12/18.
//  Copyright (c) 2015年 xiaomage. All rights reserved.
//

#import "FullViewController.h"

@interface FullViewController ()

@end

@implementation FullViewController

//控制器支持的方向：左边与右边
- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscape;
}
//是否支持方向旋转
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return YES;
}

@end

//
//  LyricView.h
//  QQMuisic
//
//  Created by 祁子栋 on 2018/3/15.
//  Copyright © 2018年 祁子栋. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LyricLabel.h"

@interface LyricView : UIScrollView

/** 歌词名 */
@property (nonatomic, copy) NSString *lrcName;

/** 当前歌词播放进度 */
@property (nonatomic, assign) NSTimeInterval currentTime;

/** 主界面歌词的Lable */
@property (nonatomic, weak) LyricLabel *lrcLabel;

@end

//
//  LyricLabel.m
//  QQMuisic
//
//  Created by 祁子栋 on 2018/3/15.
//  Copyright © 2018年 祁子栋. All rights reserved.
//
/**** 歌词的label ***/

#import "LyricLabel.h"

@implementation LyricLabel
- (void)setProgress:(CGFloat)progress
{
    _progress = progress;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    CGRect fillRect = CGRectMake(0, 0, self.bounds.size.width * self.progress, self.bounds.size.height);
    [[UIColor greenColor] set];
    //    UIRectFill(fillRect);
    UIRectFillUsingBlendMode(fillRect, kCGBlendModeSourceIn);
}

@end

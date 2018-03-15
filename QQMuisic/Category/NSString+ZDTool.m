//
//  NSString+ZDTool.m
//  QQMuisic
//
//  Created by 祁子栋 on 2018/3/14.
//  Copyright © 2018年 祁子栋. All rights reserved.
//

#import "NSString+ZDTool.h"

@implementation NSString (ZDTool)

///将获取的时间间隔（长整型）变为格式字符串
+(NSString *)stringWithTime:(NSTimeInterval)time {
    NSInteger min = time / 60;
    //    NSInteger sec = (int)time % 60;  //会有一点延迟
    NSInteger sec = (int)round(time) % 60;
    return [NSString stringWithFormat:@"%.2ld:%.02ld", min, sec];
}
@end

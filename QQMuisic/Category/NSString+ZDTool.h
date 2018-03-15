//
//  NSString+ZDTool.h
//  QQMuisic
//
//  Created by 祁子栋 on 2018/3/14.
//  Copyright © 2018年 祁子栋. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (ZDTool)

///将获取的时间间隔（长整型）变为格式字符串
+(NSString *)stringWithTime:(NSTimeInterval)time;
@end

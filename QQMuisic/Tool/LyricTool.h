//
//  LyricTool.h
//  QQMuisic
//
//  Created by 祁子栋 on 2018/3/15.
//  Copyright © 2018年 祁子栋. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LyricTool : NSObject

///根据歌词文件名获取歌词模型数组
+(NSArray *)lyricToolWithName: (NSString *)name;
@end

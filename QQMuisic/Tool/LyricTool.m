//
//  LyricTool.m
//  QQMuisic
//
//  Created by 祁子栋 on 2018/3/15.
//  Copyright © 2018年 祁子栋. All rights reserved.
//

#import "LyricTool.h"
#import "LyricLine.h"

@implementation LyricTool

+(NSArray *)lyricToolWithName:(NSString *)name {
    //获取路径
    NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:nil];
    //获取歌词
    NSString *lyricString = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    //转化成歌词模型数组
    NSArray *lyricArray = [lyricString componentsSeparatedByString:@"\n"];
    NSMutableArray *tempArray = [NSMutableArray array];
    for (NSString *lyricLineStr in lyricArray) {
        //过滤不需要的字符
        if ([lyricLineStr hasPrefix:@"[ti:"] || [lyricLineStr hasPrefix:@"[ar:"] || [lyricLineStr hasPrefix:@"[al:"] || ![lyricLineStr hasPrefix:@"["]) {
            continue;
        }
        //解析成歌词对象
        LyricLine *lyricLine = [LyricLine initWithLyricLine:lyricLineStr];
        [tempArray addObject:lyricLine];
        
    }
    
    return tempArray;
}
@end

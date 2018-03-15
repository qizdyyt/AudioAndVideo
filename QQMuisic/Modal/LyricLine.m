//
//  LyricLine.m
//  QQMuisic
//
//  Created by 祁子栋 on 2018/3/15.
//  Copyright © 2018年 祁子栋. All rights reserved.
//

#import "LyricLine.h"

@implementation LyricLine

-(instancetype)initWithLyricLineStr:(NSString *)lyricLineStr {
    if (self == [super init]) {
        // [01:02.38]想你时你在天边
        NSArray *lrcArray = [lyricLineStr componentsSeparatedByString:@"]"];
        self.text = lrcArray[1];
        self.time = [self timeWithString:[lrcArray[0] substringFromIndex:1]];
    }
    return self;
}

+(instancetype)initWithLyricLine:(NSString *)lyricLineStr {
    return [[self alloc] initWithLyricLineStr:lyricLineStr];
}

- (NSTimeInterval)timeWithString:(NSString *)timeString
{
    // 01:02.38
    NSInteger min = [[timeString componentsSeparatedByString:@":"][0] integerValue];
    NSInteger sec = [[timeString substringWithRange:NSMakeRange(3, 2)] integerValue];
    NSInteger hs = [[timeString componentsSeparatedByString:@"."][1] integerValue];
    return min * 60 + sec + hs * 0.01;
}

@end

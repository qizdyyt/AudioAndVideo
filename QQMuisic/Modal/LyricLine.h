//
//  LyricLine.h
//  QQMuisic
//
//  Created by 祁子栋 on 2018/3/15.
//  Copyright © 2018年 祁子栋. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LyricLine : NSObject

@property(nonatomic, copy) NSString *text;
@property(nonatomic, assign) NSTimeInterval time;

+(instancetype)initWithLyricLine:(NSString *)lyricLineStr;

-(instancetype)initWithLyricLineStr:(NSString *)lyricLineStr;
@end

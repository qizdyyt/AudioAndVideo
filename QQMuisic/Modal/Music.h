//
//  Music.h
//  QQMuisic
//
//  Created by 祁子栋 on 2018/3/14.
//  Copyright © 2018年 祁子栋. All rights reserved.
//
/*** 歌曲对象 ***/
#import <Foundation/Foundation.h>

@interface Music : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString* filename;
@property (nonatomic, copy) NSString* lrcname;
@property (nonatomic, copy) NSString* singer;
@property (nonatomic, copy) NSString* singerIcon;
@property (nonatomic, copy) NSString* icon;

@end

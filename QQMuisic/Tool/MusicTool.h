//
//  MusicTool.h
//  QQMuisic
//
//  Created by 祁子栋 on 2018/3/14.
//  Copyright © 2018年 祁子栋. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Music.h"
@interface MusicTool : NSObject
///所有的音乐
+(NSArray*)allMusic;

///获取当前播放音乐
+(Music *)playingMusic;

///设置默认的音乐
+(void)setupPlayingMusic: (Music *)playingMusic;

///返回上一首音乐
+(Music *)previousMusic;
///返回下一首音乐
+(Music *)nextMusic;


@end

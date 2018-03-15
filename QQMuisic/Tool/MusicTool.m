//
//  MusicTool.m
//  QQMuisic
//
//  Created by 祁子栋 on 2018/3/14.
//  Copyright © 2018年 祁子栋. All rights reserved.
//

#import "MusicTool.h"
#import "Music.h"
#import "MJExtension.h"

@implementation MusicTool

static NSArray *_musics;
static Music *_playingMusic;

+ (void)initialize
{
    if (self == [MusicTool class]) {
        _musics = [Music objectArrayWithFilename:@"Musics.plist"];
        _playingMusic = _musics[0];
    }
}

+(NSArray *)allMusic {
    
    return _musics;
}

+(Music *)playingMusic {
    return _playingMusic;
}

+(void)setupPlayingMusic:(Music *)playingMusic {
    _playingMusic = playingMusic;
}

+(Music *)previousMusic {
    //获取当前音乐的下标
    NSInteger currentIndex = [_musics indexOfObject:_playingMusic];
    //获取上一首音乐下标
    NSInteger preIndex = --currentIndex;
    Music *preMusic = nil;
    if (preIndex < 0) {
        preIndex = _musics.count - 1;
    }
    preMusic = _musics[preIndex];
    return preMusic;
}

+(Music *)nextMusic {
    //获取当前音乐的下标
    NSInteger currentIndex = [_musics indexOfObject:_playingMusic];
    //获取上一首音乐下标
    NSInteger nextIndex = ++currentIndex;
    Music *nextMusic = nil;
    if (nextIndex >= _musics.count) {
        nextIndex = 0;
    }
    nextMusic = _musics[nextIndex];
    return nextMusic;
}


@end

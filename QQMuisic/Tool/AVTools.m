//
//  AVTools.m
//  QQMuisic
//
//  Created by 祁子栋 on 2018/3/14.
//  Copyright © 2018年 祁子栋. All rights reserved.
//

#import "AVTools.h"
#import <AVFoundation/AVFoundation.h>

@implementation AVTools

static NSMutableDictionary *_soundIDS;
static NSMutableDictionary *_players;

+ (void)initialize
{
    if (self == [AVTools class]) {
        _soundIDS = [NSMutableDictionary dictionary];
        _players = [NSMutableDictionary dictionary];
    }
}

+(void)playSoundWithSoundName:(NSString *)soundName {
    //1.创建soundID
    SystemSoundID soundID = 0;
    //2.从字典中取出soundID
    soundID = [_soundIDS[soundName] unsignedIntValue];
    //3.判断soundID是否为0
    if (soundID == 0) {
        //3.1如果为0，生成soundID
        CFURLRef url = (__bridge CFURLRef)([[NSBundle mainBundle] URLForResource:soundName withExtension:nil]);
        if (url == nil) {
            return;
        }
        AudioServicesCreateSystemSoundID(url, &soundID);
        //3.2并将SoundID保存到字典中
        [_soundIDS setObject:@(soundID) forKey:soundName];
    }
    //4.播放音效
    AudioServicesPlaySystemSound(soundID);
}

+(AVAudioPlayer *)playMusicWithName:(NSString *)musicName {
    
    AVAudioPlayer *player = nil;
    
    player = _players[musicName];
    
    if (player == nil) {
        
        NSURL *musicUrl = [[NSBundle mainBundle] URLForResource:musicName withExtension:nil];
        if (musicUrl == nil) {
            return nil;
        }
        
        player = [[AVAudioPlayer alloc] initWithContentsOfURL:musicUrl error:nil];
        
        [_players setObject:player forKey:musicName];
        
        [player prepareToPlay];
    }
    
    [player play];
    return player;
}

+(void)pauseMusicWithName:(NSString *)musicName {
    AVAudioPlayer *player = _players[musicName];
    if (player) {
        [player pause];
    }
}

+(void)stopMusicWithName:(NSString *)musicName {
    AVAudioPlayer *player = _players[musicName];
    if (player) {
        [player stop];
        [_players removeObjectForKey:musicName];
        player = nil;
    }
}
@end

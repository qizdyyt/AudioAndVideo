//
//  AVTools.h
//  QQMuisic
//
//  Created by 祁子栋 on 2018/3/14.
//  Copyright © 2018年 祁子栋. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface AVTools : NSObject
///播放本地音效方法
+(void)playSoundWithSoundName:(NSString *)soundName;

///播放音乐方法
+(AVAudioPlayer *)playMusicWithName: (NSString*)musicName;
///暂停播放音乐
+(void)pauseMusicWithName: (NSString *)musicName;
///停止播放音乐
+(void)stopMusicWithName: (NSString*)musicName;
@end

//
//  AppDelegate.m
//  QQMuisic
//
//  Created by 祁子栋 on 2018/3/14.
//  Copyright © 2018年 祁子栋. All rights reserved.
//

#import "AppDelegate.h"
#import <AVFoundation/AVFoundation.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    //1、获取音频会话
    AVAudioSession *session = [AVAudioSession sharedInstance];
    
    //2、设置为后台类型
    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
    
    //3、激活会话
    [session setActive:YES error:nil];
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"iconViewAnimate"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"iconViewAnimate"] ) return;
    
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"XMGIconViewNotification" object:nil];
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end

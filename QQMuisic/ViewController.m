//
//  ViewController.m
//  QQMuisic
//
//  Created by 祁子栋 on 2018/3/14.
//  Copyright © 2018年 祁子栋. All rights reserved.
//

#import "ViewController.h"
#import "AVTools.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [AVTools playMusicWithName:@"339744.mp3"];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

//
//  ViewController.m
//  QQMuisic
//
//  Created by 祁子栋 on 2018/3/14.
//  Copyright © 2018年 祁子栋. All rights reserved.
//

#import "ViewController.h"
#import "AVTools.h"
#import "MusicTool.h"
#import "NSString+ZDTool.h"
#import "CALayer+PauseAimate.h"
#import "LyricView.h"
#import "LyricLabel.h"
#import <MediaPlayer/MediaPlayer.h>

#define ZDColor(r,g,b,a)[UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

@interface ViewController ()<UIScrollViewDelegate>
//歌手背景图片
@property (weak, nonatomic) IBOutlet UIImageView *BGImage;
//进度条
@property (weak, nonatomic) IBOutlet UISlider *progressSlider;
//歌手图片
@property (weak, nonatomic) IBOutlet UIImageView *singerImage;
//歌词label
@property (weak, nonatomic) IBOutlet LyricLabel *lyricLabel;
//歌名Label
@property (weak, nonatomic) IBOutlet UILabel *musicNameLabel;
//歌手Label
@property (weak, nonatomic) IBOutlet UILabel *singerNameLabel;
//当前播放时间
@property (weak, nonatomic) IBOutlet UILabel *currentTimeLabel;
//总共播放时间
@property (weak, nonatomic) IBOutlet UILabel *totalTimeLabel;
@property (weak, nonatomic) IBOutlet LyricView *lyricView;


//更新进度条时间timer
@property (nonatomic, strong) NSTimer *progressTimer;
//更新歌词进度timer
@property (nonatomic, strong) CADisplayLink *lyricTimer;
//当前播放器
@property (nonatomic, strong) AVAudioPlayer *currentPlayer;

- (IBAction)sliderTouchDown;
- (IBAction)sliderValueChanged:(id)sender;
- (IBAction)sliderUpInside:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *lastButton;
@property (weak, nonatomic) IBOutlet UIButton *playButton;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;


- (IBAction)lastButtonPressed:(id)sender;
- (IBAction)playButtonPressed:(id)sender;
- (IBAction)nextButtonPressed:(id)sender;



@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    //设置毛玻璃效果
    [self setupBlurView];
    //替换进度条滑块的图片PS:这里不小心给Thumb滑块设置了tintcolor，会导致点击滑块放大，很丑
    [self.progressSlider setThumbImage:[UIImage imageNamed:@"player_slider_playback_thumb"] forState:UIControlStateNormal];
    //给滑动条添加点击tap手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sliderTaped:)];
    [self.progressSlider addGestureRecognizer:tap];
    
    //通过主界面的歌词Label初始化歌词View中持有的Label，修改哪里则这里也就改了
    self.lyricView.lrcLabel = self.lyricLabel;
    //开始播放音乐
    [self startPlayingMusic];
    //设置歌词view contentsize
    self.lyricView.contentSize = CGSizeMake(self.view.bounds.size.width * 2, 0);

    // 接受通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addSingerImageAnimate) name:@"XMGIconViewNotification" object:nil];
}


-(void)startPlayingMusic {
    //获取当前播放音乐
    Music *playingMusic = [MusicTool playingMusic];
    //设置界面信息
    self.BGImage.image = [UIImage imageNamed:playingMusic.icon];
    self.singerImage.image = [UIImage imageNamed:playingMusic.icon];
    self.musicNameLabel.text = playingMusic.name;
    self.singerNameLabel.text = playingMusic.singer;
    //播放音乐
    self.currentPlayer = [AVTools playMusicWithName:playingMusic.filename];
    self.currentTimeLabel.text = [NSString stringWithTime:self.currentPlayer.currentTime];
    self.totalTimeLabel.text = [NSString stringWithTime:self.currentPlayer.duration];
    //设置播放按钮
    self.playButton.selected = self.currentPlayer.isPlaying;
    //开启进度条定时器，首先移除一下定时器，可能之前播放歌曲已经有了一个
    [self removeProgressTimer];
    [self addProgressTimer];
    //歌词的
    [self removeLyricTimer];
    [self addLyricTimer];
    
    //添加头像旋转动画
    [self addSingerImageAnimate];
    
    //设置锁屏时用的总时长
    self.lyricView.duration = self.currentPlayer.duration;
    //添加歌词
    self.lyricView.lrcName = playingMusic.lrcname;
    
    //添加锁屏信息
    

//    [self setupLockScreenInfo];
}


-(void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    //添加圆角,这里可以加载控制器子控件的真实frame
    self.singerImage.layer.cornerRadius = self.singerImage.frame.size.width / 2;
    self.singerImage.layer.masksToBounds = true;
    self.singerImage.layer.borderWidth = 8;
    self.singerImage.layer.borderColor = ZDColor(36, 36, 36, 1.0).CGColor;
}

-(void)setupBlurView {
    UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height)];
    [self.BGImage addSubview:toolBar];
    toolBar.barStyle = UIBarStyleBlack;
    
}

#pragma mark - 进度条timer处理
-(void)addProgressTimer {
    [self updateProgress];
    self.progressTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateProgress) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.progressTimer forMode:NSRunLoopCommonModes];
}

-(void)removeProgressTimer {
    [self.progressTimer invalidate];
    self.progressTimer = nil;
}

-(void)updateProgress {
    //更新当前播放时间
    self.currentTimeLabel.text = [NSString stringWithTime:self.currentPlayer.currentTime];
    //更新滑动条
    self.progressSlider.value = self.currentPlayer.currentTime / self.currentPlayer.duration;
}

#pragma mark - 歌词进度timer处理
-(void)addLyricTimer {
    self.lyricTimer = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateLyricInfo)];
    [self.lyricTimer addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
}

-(void)removeLyricTimer{
    [self.lyricTimer invalidate];
    self.lyricTimer = nil;
}
#pragma mark - 更新歌词进度
- (void)updateLyricInfo{
    self.lyricView.currentTime = self.currentPlayer.currentTime;
}

#pragma mark - slider事件处理
- (IBAction)sliderTouchDown {
    //移除定时器，让滑动条不要动
    [self removeProgressTimer];
}

- (IBAction)sliderValueChanged:(id)sender {
    //更新label
    self.currentTimeLabel.text = [NSString stringWithTime:self.progressSlider.value * self.currentPlayer.duration];
    
}

- (IBAction)sliderUpInside:(id)sender {
    //更新播放时间
    self.currentPlayer.currentTime = self.progressSlider.value * self.currentPlayer.duration;
    
    //添加定时器,
    [self addProgressTimer];
}

- (void)sliderTaped:(UITapGestureRecognizer *)tap {
    //获取点击的点
    CGPoint point = [tap locationInView:tap.view];
    //获取位置比例
    CGFloat ratio = point.x / self.progressSlider.bounds.size.width;
    //更新播放的时间
    self.currentPlayer.currentTime = self.currentPlayer.duration * ratio;
//    self.currentTimeLabel.text = [NSString stringWithTime:self.currentPlayer.duration * ratio];
    //更新显示时间与滑块位置
    [self updateProgress];
    
}

#pragma mark - 添加歌手图片转动动画
- (void)addSingerImageAnimate {
    CABasicAnimation *rotateAnimate = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotateAnimate.fromValue = @(0);
    rotateAnimate.toValue = @(M_PI * 2);
    rotateAnimate.repeatCount = NSIntegerMax;
    rotateAnimate.duration = 30;
    [self.singerImage.layer addAnimation:rotateAnimate forKey:nil];
    
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"iconViewAnimate"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - 按钮事件处理
- (IBAction)lastButtonPressed:(id)sender {
    //获取当前播放的player
    Music *currentMusic = [MusicTool playingMusic];
    //停止当前播放的player
    [AVTools stopMusicWithName:currentMusic.filename];
    //获取上一首音乐
    Music *preMusic = [MusicTool previousMusic];
    [MusicTool setupPlayingMusic:preMusic];
    //播放表更新音乐
    [self startPlayingMusic];
    
}

- (IBAction)playButtonPressed:(id)sender {
    self.playButton.selected = !self.playButton.selected;
    if (self.currentPlayer.playing) {
        //暂停播放器
        [self.currentPlayer pause];
        //移除定时器
        [self removeProgressTimer];
        //暂停旋转动画
        [self.singerImage.layer pauseAnimate];
    }else {
        //开始播放器
        [self.currentPlayer play];
        //添加定时器
        [self addProgressTimer];
        //恢复动画
        [self.singerImage.layer resumeAnimate];
    }
}

- (IBAction)nextButtonPressed:(id)sender {
    //获取当前播放的player
    Music *currentMusic = [MusicTool playingMusic];
    //停止当前播放的player
    [AVTools stopMusicWithName:currentMusic.filename];
    //获取下一首音乐
    Music *nextMusic = [MusicTool nextMusic];
    [MusicTool setupPlayingMusic:nextMusic];
    [self startPlayingMusic];
    
}

#pragma mark - UIscrollerView代理
-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGPoint point = scrollView.contentOffset;
    CGFloat alpha = point.x / scrollView.bounds.size.width;
    self.singerImage.alpha = 1 - alpha;
    self.lyricLabel.alpha = 1 - alpha;
}

-(UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

//#pragma mark - 设置锁屏信息与锁屏时间处理
//- (void)setupLockScreenInfo
//{
//
//    // MPMediaItemPropertyAlbumTitle
//    // MPMediaItemPropertyAlbumTrackCount
//    // MPMediaItemPropertyAlbumTrackNumber
//    // MPMediaItemPropertyArtist
//    // MPMediaItemPropertyArtwork
//    // MPMediaItemPropertyComposer
//    // MPMediaItemPropertyDiscCount
//    // MPMediaItemPropertyDiscNumber
//    // MPMediaItemPropertyGenre
//    // MPMediaItemPropertyPersistentID
//    // MPMediaItemPropertyPlaybackDuration
//    // MPMediaItemPropertyTitle
//
//
//    // 0.获取当前播放的歌曲
//    Music *playingMusic = [MusicTool playingMusic];
//
//    // 1.获取锁屏中心
//    MPNowPlayingInfoCenter *playingInfoCenter = [MPNowPlayingInfoCenter defaultCenter];
//
//    // 2.设置锁屏参数
//    NSMutableDictionary *playingInfoDict = [NSMutableDictionary dictionary];
//    // 2.1设置歌曲名
//    [playingInfoDict setObject:playingMusic.name forKey:MPMediaItemPropertyAlbumTitle];
//    // 2.2设置歌手名
//    [playingInfoDict setObject:playingMusic.singer forKey:MPMediaItemPropertyArtist];
//    // 2.3设置封面的图片
//    MPMediaItemArtwork *artwork = [[MPMediaItemArtwork alloc] initWithImage:[UIImage imageNamed:playingMusic.icon]];
//    [playingInfoDict setObject:artwork forKey:MPMediaItemPropertyArtwork];
//    // 2.4设置歌曲的总时长
//    [playingInfoDict setObject:@(self.currentPlayer.duration) forKey:MPMediaItemPropertyPlaybackDuration];
//    playingInfoCenter.nowPlayingInfo = playingInfoDict;
//
//    // 3.开启远程交互
//    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
//}
//
//- (void)remoteControlReceivedWithEvent:(UIEvent *)event
//{
//    /*
//     UIEventSubtypeRemoteControlPlay                 = 100,
//     UIEventSubtypeRemoteControlPause                = 101,
//     UIEventSubtypeRemoteControlStop                 = 102,
//     UIEventSubtypeRemoteControlTogglePlayPause      = 103,
//     UIEventSubtypeRemoteControlNextTrack            = 104,
//     UIEventSubtypeRemoteControlPreviousTrack        = 105,
//     UIEventSubtypeRemoteControlBeginSeekingBackward = 106,
//     UIEventSubtypeRemoteControlEndSeekingBackward   = 107,
//     UIEventSubtypeRemoteControlBeginSeekingForward  = 108,
//     UIEventSubtypeRemoteControlEndSeekingForward    = 109,
//     */
//    switch (event.subtype) {
//        case UIEventSubtypeRemoteControlPlay:
//        case UIEventSubtypeRemoteControlPause:
//            [self playButtonPressed:nil];
//            break;
//
//        case UIEventSubtypeRemoteControlNextTrack:
//            [self nextButtonPressed:nil];
//            break;
//
//        case UIEventSubtypeRemoteControlPreviousTrack:
//            [self lastButtonPressed:nil];
//            break;
//
//        default:
//            break;
//    }
//}

#pragma mark - 移除通知
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end

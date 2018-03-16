//
//  LyricView.m
//  QQMuisic
//
//  Created by 祁子栋 on 2018/3/15.
//  Copyright © 2018年 祁子栋. All rights reserved.
//

#import "LyricView.h"
#import "LyricTool.h"
#import "LyricLine.h"
#import "LyricLabel.h"
#import <MediaPlayer/MediaPlayer.h>
#import "Music.h"
#import "MusicTool.h"

@interface LyricView()<UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;

/** 歌词数组 */
@property (nonatomic, strong) NSArray *lrcList;

//当前滚动的行数
@property (nonatomic, assign) NSInteger currentIndex;
@end

@implementation LyricView

//通过SB创建走这个
-(instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        //初始化tableView
        [self setupTabelView];
    }
    return  self;
}

-(void)layoutSubviews {
    [super layoutSubviews];
    
    self.tableView.frame = CGRectMake(self.frame.size.width, 0, self.frame.size.width, self.frame.size.height);
    //tableView背景颜色,与cell的默认分割线，必须要在frame设置有大小后生效，否则没效果好像
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //设置可以滑动的停靠位置，也可以说是可滑动到的位置
    self.tableView.contentInset = UIEdgeInsetsMake(self.frame.size.height * 0.5, 0, self.frame.size.height * 0.5, 0);
}

-(instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        //初始化tableView
        [self setupTabelView];
    }
    return  self;
}

-(void) setupTabelView {
    self.tableView = [[UITableView alloc] init];
    [self addSubview:self.tableView];
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 40;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString* cellID = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        LyricLabel *lyricLabel = [[LyricLabel alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 40)];
        [cell.contentView addSubview:lyricLabel];
        lyricLabel.tag = 3;
    }
    LyricLine *lyricLine = self.lrcList[indexPath.row];
//    cell.textLabel.text = lyricLine.text;//[NSString stringWithFormat:@"ceshi%ld", indexPath.row];
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = [UIColor lightTextColor];
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    LyricLabel *lrcLyricLabel = [cell viewWithTag:3];
    if (lyricLine.text.length) {
        lrcLyricLabel.text = lyricLine.text;
    }else {
        lrcLyricLabel.text = @"";
    }
    
    if (indexPath.row == self.currentIndex) {
//        cell.textLabel.font = [UIFont systemFontOfSize:18];
        lrcLyricLabel.font = [UIFont systemFontOfSize:20];
    }else {
//        cell.textLabel.font = [UIFont systemFontOfSize:14];
        lrcLyricLabel.font = [UIFont systemFontOfSize:14];
        lrcLyricLabel.progress = 0;
    }
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.lrcList.count;
}

-(void)setLrcName:(NSString *)lrcName {
    
    // -1让tableView滚到中间
    [self.tableView setContentOffset:CGPointMake(0, -self.tableView.bounds.size.height * 0.5) animated:NO];
    
    // 0.将currentIndex初始化为0
    self.currentIndex = 0;
    //记录歌词名
    _lrcName = [_lrcName copy];
    //解析歌词
    self.lrcList = [LyricTool lyricToolWithName:lrcName];
    // 2.1设置第一句歌词
    LyricLine *firstLrcLine = self.lrcList[0];
    self.lrcLabel.text = firstLrcLine.text;
    //刷新表格
    [self.tableView reloadData];
    
}

#pragma mark -- 重写当前时间的setter，更新歌词滚动与歌词颜色变化
-(void)setCurrentTime:(NSTimeInterval)currentTime {
    //保存时间
    _currentTime = currentTime;
    //判断显示哪句歌词与歌词更新的进度
    NSInteger count = self.lrcList.count;
    for (NSInteger i = 0; i < count; i++) {
        //取出当前歌词
        LyricLine *currentLyricLine = self.lrcList[i];
        //下一句歌词
        LyricLine *nextLyricLine = nil;
        NSInteger nextIndex = i + 1;
        if (nextIndex < self.lrcList.count) {
            nextLyricLine = self.lrcList[nextIndex];
        }
        //首先判断当前是否是当前位置，如果是当前位置不用再滚动，不是再判断时间是否正确，用两句歌词时间与当前播放时间进行比对，决定是否更新当前播放歌词滚动
        if (self.currentIndex != i && currentTime >= currentLyricLine.time && currentTime < nextLyricLine.time) {
            //获取当前歌词与上一句歌词的indexPath
            NSIndexPath *indexpath = [NSIndexPath indexPathForRow:i inSection:0];
            NSIndexPath *previousIndexPath = [NSIndexPath indexPathForRow:self.currentIndex inSection:0];
            //记录当前已经刷新到某行某位置
            self.currentIndex = i;
            //刷新当前歌词并刷新上一句已播放的歌词
            [self.tableView reloadRowsAtIndexPaths:@[indexpath,previousIndexPath] withRowAnimation:UITableViewRowAnimationNone];
            //将当前歌词滚动到中间
            [self.tableView scrollToRowAtIndexPath:indexpath atScrollPosition:UITableViewScrollPositionTop animated:YES];
            
            self.lrcLabel.text = currentLyricLine.text;
            //生成锁屏图片并且配置锁屏信息
            [self genaratorLockImage];
        }
        
        if (self.currentIndex == i) { // 循环到是当前位置当前这句歌词，更新歌词颜色
            
            // 1.用当前播放器的时间减去当前歌词的时间除以(下一句歌词的时间-当前歌词的时间)
            CGFloat value = (currentTime - currentLyricLine.time) / (nextLyricLine.time - currentLyricLine.time);
            
            // 2.设置当前歌词播放的进度
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.currentIndex inSection:0];
            UITableViewCell *lrcCell = [self.tableView cellForRowAtIndexPath:indexPath];
            LyricLabel *lrcLabel = [lrcCell viewWithTag:3];
            lrcLabel.progress = value;
            self.lrcLabel.progress = value;
        }
    }
    
}

#pragma mark - 生成锁屏图片
- (void)genaratorLockImage
{
    // 1.获取当前音乐的图片
    Music *playingMusic = [MusicTool playingMusic];
    UIImage *currentImage = [UIImage imageNamed:playingMusic.icon];
    
    // 2.取出歌词
    // 2.1取出当前的歌词
    LyricLine *currentLrcLine = self.lrcList[self.currentIndex];
    
    // 2.2取出上一句歌词
    NSInteger previousIndex = self.currentIndex - 1;
    LyricLine *previousLrcLine = nil;
    if (previousIndex >= 0) {
        previousLrcLine = self.lrcList[previousIndex];
    }
    
    // 2.3取出下一句歌词
    NSInteger nextIndex = self.currentIndex + 1;
    LyricLine *nextLrcLine = nil;
    if (nextIndex < self.lrcList.count) {
        nextLrcLine = self.lrcList[nextIndex];
    }
    
    // 3.生成水印图片
    // 3.1获取上下文
    UIGraphicsBeginImageContext(currentImage.size);
    
    // 3.2将图片画上去
    [currentImage drawInRect:CGRectMake(0, 0, currentImage.size.width, currentImage.size.height)];
    
    // 3.3将文字画上去
    CGFloat titleH = 25;
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment =  NSTextAlignmentCenter;
    NSDictionary *attributes1 = @{NSFontAttributeName : [UIFont systemFontOfSize:14],
                                  NSForegroundColorAttributeName : [UIColor lightGrayColor],
                                  NSParagraphStyleAttributeName : paragraphStyle};
    [previousLrcLine.text drawInRect:CGRectMake(0, currentImage.size.height - titleH * 3, currentImage.size.width, titleH) withAttributes:attributes1];
    [nextLrcLine.text drawInRect:CGRectMake(0, currentImage.size.height - titleH, currentImage.size.width, titleH) withAttributes:attributes1];
    
    NSDictionary *attributes2 =  @{NSFontAttributeName : [UIFont systemFontOfSize:20],
                                   NSForegroundColorAttributeName : [UIColor whiteColor],
                                   NSParagraphStyleAttributeName : paragraphStyle};
    [currentLrcLine.text drawInRect:CGRectMake(0, currentImage.size.height - titleH *2, currentImage.size.width, titleH) withAttributes:attributes2];
    
    // 3.4获取画好的图片
    UIImage *lockImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // 3.5关闭上下文
    UIGraphicsEndImageContext();
    
    // 3.6设置锁屏界面的图片
    [self setupLockScreenInfoWithLockImage:lockImage];
    
}

#pragma mark - 设置锁屏信息
- (void)setupLockScreenInfoWithLockImage:(UIImage *)lockImage
{
    /*
     // MPMediaItemPropertyAlbumTitle
     // MPMediaItemPropertyAlbumTrackCount
     // MPMediaItemPropertyAlbumTrackNumber
     // MPMediaItemPropertyArtist
     // MPMediaItemPropertyArtwork
     // MPMediaItemPropertyComposer
     // MPMediaItemPropertyDiscCount
     // MPMediaItemPropertyDiscNumber
     // MPMediaItemPropertyGenre
     // MPMediaItemPropertyPersistentID
     // MPMediaItemPropertyPlaybackDuration
     // MPMediaItemPropertyTitle
     */
    
    // 0.获取当前播放的歌曲
    Music *playingMusic = [MusicTool playingMusic];
    
    // 1.获取锁屏中心
    MPNowPlayingInfoCenter *playingInfoCenter = [MPNowPlayingInfoCenter defaultCenter];
    
    // 2.设置锁屏参数
    NSMutableDictionary *playingInfoDict = [NSMutableDictionary dictionary];
    // 2.1设置歌曲名
    [playingInfoDict setObject:playingMusic.name forKey:MPMediaItemPropertyAlbumTitle];
    // 2.2设置歌手名
    [playingInfoDict setObject:playingMusic.singer forKey:MPMediaItemPropertyArtist];
    // 2.3设置封面的图片
    MPMediaItemArtwork *artwork = [[MPMediaItemArtwork alloc] initWithImage:lockImage];
    [playingInfoDict setObject:artwork forKey:MPMediaItemPropertyArtwork];
    // 2.4设置歌曲的总时长
    [playingInfoDict setObject:@(self.duration) forKey:MPMediaItemPropertyPlaybackDuration];
    
    // 2.4设置歌曲当前的播放时间
    [playingInfoDict setObject:@(self.currentTime) forKey:MPNowPlayingInfoPropertyElapsedPlaybackTime];
    
    playingInfoCenter.nowPlayingInfo = playingInfoDict;
    
    // 3.开启远程交互
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
}


@end

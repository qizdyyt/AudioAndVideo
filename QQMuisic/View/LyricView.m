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
        //首先判断当前是否是当前位置，如果是当前位置不用再滚动，不是再判断时间是否正确，用两句歌词时间与当前播放时间进行比对，决定是否更新当前播放歌词
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




@end

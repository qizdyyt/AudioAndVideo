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

@interface LyricView()<UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;

/** 歌词数组 */
@property (nonatomic, strong) NSArray *lrcList;
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
    }
    LyricLine *lyricLine = self.lrcList[indexPath.row];
    cell.textLabel.text = lyricLine.text;//[NSString stringWithFormat:@"ceshi%ld", indexPath.row];
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = [UIColor lightTextColor];
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.lrcList.count;
}

-(void)setLrcName:(NSString *)lrcName {
    //记录歌词名
    _lrcName = [_lrcName copy];
    //解析歌词
    self.lrcList = [LyricTool lyricToolWithName:lrcName];
    //刷新表格
    [self.tableView reloadData];
    
}

@end

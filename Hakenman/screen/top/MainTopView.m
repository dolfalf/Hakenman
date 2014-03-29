//
//  MainTopView.m
//  Hakenman
//
//  Created by Lee jaeeun on 2014/03/22.
//  Copyright (c) 2014年 kjcode. All rights reserved.
//

#import "MainTopView.h"
#import "WorkStatusCell.h"
#import "TodoListCell.h"
#import "GraphTableViewCell.h"
#import "WeekWorkStatusCell.h"

@interface MainTopView() <UITableViewDataSource, UITableViewDelegate> {
    
    IBOutlet UITableView *workTableView;
}

@property (nonatomic, strong) WorkStatusCell *workStatusCell;
@property (nonatomic, strong) TodoListCell *todoListCell;
@property (nonatomic, strong) GraphTableViewCell *graphTableViewCell;
@property (nonatomic, strong) WeekWorkStatusCell *weekWorkStatusCell;

- (WorkStatusCell *)tableView:(UITableView *)tableView workStatusCellForRowAtIndexPath:(NSIndexPath *)indexPath;
- (TodoListCell *)tableView:(UITableView *)tableView todoListCellForRowAtIndexPath:(NSIndexPath *)indexPath;
- (WeekWorkStatusCell *)tableView:(UITableView *)tableView weekWorkStatusCellForRowAtIndexPath:(NSIndexPath *)indexPath;

@end

@implementation MainTopView

+ (id)createView {
    NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"MainTopView" owner:nil options:nil];
    return [views objectAtIndex:0];
}

- (id)initTableCellView:(tableCellType)cellType {
    NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"MainTopView" owner:nil options:nil];
    
    return [views objectAtIndex:(cellType + 1)];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/


#pragma mark - tableView private method
- (WorkStatusCell *)tableView:(UITableView *)tableView workStatusCellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    NSString *cellIdentifier = @"WorkStatusCellIdentifier";
//    WorkStatusCell *cell = (WorkStatusCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
//    if (!cell) {
//        cell = [[WorkStatusCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
//    }
//    
//    //TODO: cell更新
//    
//    return cell;
    
    if (_workStatusCell == nil) {
        _workStatusCell = (WorkStatusCell *)[self initTableCellView:tableCellTypeCurrentStatus];
    }
    
    return _workStatusCell;
}

- (TodoListCell *)tableView:(UITableView *)tableView todoListCellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (_todoListCell == nil) {
        _todoListCell = (TodoListCell *)[self initTableCellView:tableCellTypeTodoList];
    }
    
    return _todoListCell;
}

- (GraphTableViewCell *)tableView:(UITableView *)tableView graphViewCellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (_graphTableViewCell == nil) {
        _graphTableViewCell = (GraphTableViewCell *)[self initTableCellView:tableCellTypeGraphView];
    }
    
    return _graphTableViewCell;
}

- (WeekWorkStatusCell *)tableView:(UITableView *)tableView weekWorkStatusCellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (_weekWorkStatusCell == nil) {
        _weekWorkStatusCell = (WeekWorkStatusCell *)[self initTableCellView:tableCellTypeWeekStatus];
    }
    
    return _weekWorkStatusCell;
}

#pragma mark - UITableView Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == tableCellTypeCurrentStatus) {
        return 140.0f;
        
    }else if(indexPath.row == tableCellTypeTodoList) {
        return 120.0f;
        
    }else if(indexPath.row == tableCellTypeGraphView) {
        return 130.0f;
        
    }else if(indexPath.row == tableCellTypeWeekStatus) {
        return 130.0f;
        
    }
    
    return 44.0f;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return tableCellTypeMaxCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == tableCellTypeCurrentStatus) {
        WorkStatusCell *cell = [self tableView:tableView workStatusCellForRowAtIndexPath:indexPath];
        
        return cell;
        
    }else if(indexPath.row == tableCellTypeTodoList) {
        TodoListCell *cell = [self tableView:tableView todoListCellForRowAtIndexPath:indexPath];
        
        return cell;
        
    }else if(indexPath.row == tableCellTypeGraphView) {
        GraphTableViewCell *cell = [self tableView:tableView graphViewCellForRowAtIndexPath:indexPath];
        
        return cell;
        
    }else if(indexPath.row == tableCellTypeWeekStatus) {
        WeekWorkStatusCell *cell = [self tableView:tableView weekWorkStatusCellForRowAtIndexPath:indexPath];
        
        return cell;
        
    }else {
        //その他
    }

    //ここにくることはありえないのでnilにする
    return nil;
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    DLog(@"%d table cell selected.", indexPath.row);
    
}
@end

//
//  CardSelectorView.h
//  CardSelectorDemo
//
//  Created by zhaoP on 16/9/5.
//  Copyright © 2016年 langya. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CardSelectorView : UIView
//数据源
@property (nonatomic,strong) NSArray *cardDatas;
//向左拖动
@property (nonatomic,copy) void(^dragToLeftAction)();
//向右拖动
@property (nonatomic,copy) void(^dragToRightAction)();
//向上拖动
@property (nonatomic,copy) void(^dragToTopAction)();
//点击singCardView的block
@property (nonatomic,copy) void(^tapAction)();

@end

//
//  SingleCardView.h
//  CardSelectorDemo
//
//  Created by zhaoP on 16/9/5.
//  Copyright © 2016年 langya. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SingleCardView;
@protocol SingleCardViewDelegate <NSObject>
@optional
-(void)singleCardView:( SingleCardView * _Nonnull )singleCardView panGestureRecognizer:(UIPanGestureRecognizer * _Nonnull)pan;

@end

@interface SingleCardView : UIView
@property (nonatomic,copy) void(^_Nonnull tapAction)();
@property(nullable,nonatomic,weak) id <SingleCardViewDelegate> delegate;
@end

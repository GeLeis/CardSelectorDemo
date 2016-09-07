//
//  CardSelectorView.m
//  CardSelectorDemo
//
//  Created by zhaoP on 16/9/5.
//  Copyright © 2016年 langya. All rights reserved.
//

#import "CardSelectorView.h"
#import "SingleCardView.h"
#define kLeftSpace 20

@interface CardSelectorView ()<SingleCardViewDelegate>
@property (nonatomic,assign) int currentIndex;
@property (nonatomic,strong) NSMutableArray *cardViews;
@property (nonatomic,assign) CGFloat translateX,translateY,minTrasnlate;
@property (nonatomic,strong) NSMutableArray *changingCardViewFrames;
@property (nonatomic,assign) CGPoint originPoint, nowPoint;
@end

@implementation CardSelectorView

-(instancetype)initWithFrame:(CGRect)frame{
	if (self = [super initWithFrame:frame]) {
		_currentIndex = 0;
		_cardViews = nil;
		_translateX = 0.f;
		_translateY = 0.f;
		_minTrasnlate = self.frame.size.width * 0.3;
		self.layer.speed = 1;
	}
	return self;
}

-(NSMutableArray *)cardViews{
	if (!_cardViews) {
		_cardViews = [NSMutableArray array];
	}
	return  _cardViews;
}


-(NSMutableArray *)changingCardViewFrames{
	if (!_changingCardViewFrames) {
		_changingCardViewFrames = [NSMutableArray array];
	}
	return _changingCardViewFrames;
}

-(void)setCardDatas:(NSArray *)cardDatas{
	_cardDatas = cardDatas;
	CGFloat singleCardWidth,topOffset;
	NSMutableArray *mutArr = [NSMutableArray array];
	for (int index = 0; index < cardDatas.count; index++) {
		if (index <= 2) {
			singleCardWidth = (self.frame.size.width - 2 * kLeftSpace) - index * 10;
			topOffset = 35 - index * 5;
		}else {
			topOffset = 25;
			singleCardWidth = (self.frame.size.width - 2 * kLeftSpace) - 2 * 10;
		}
		
		
		SingleCardView *singleCardView = [[SingleCardView alloc] initWithFrame:CGRectMake(0, 0, singleCardWidth, singleCardWidth * 1.37)];
		
		
		singleCardView.backgroundColor = [UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:1];
		singleCardView.delegate = self;
		if (self.tapAction) {
			singleCardView.tapAction = self.tapAction;
		}
		singleCardView.frame = CGRectMake((self.frame.size.width - singleCardWidth) * 0.5, topOffset, singleCardWidth, singleCardWidth * 1.37);

		[self insertSubview:singleCardView atIndex:0];
		[mutArr addObject:singleCardView];
		
	}
	self.cardViews = mutArr;
}

-(void)setTapAction:(void (^)())tapAction{
	_tapAction = tapAction;
	if (!self.cardViews) {
		return;
	}
	for (SingleCardView *singleCardView in self.cardViews) {
		singleCardView.tapAction = tapAction;
	}
}


-(void)setDragToTopAction:(void (^)())dragToTopAction{
	_dragToTopAction = dragToTopAction;

}

-(void)setDragToLeftAction:(void (^)())dragToLeftAction{
	_dragToLeftAction = dragToLeftAction;

}

-(void)setDragToRightAction:(void (^)())dragToRightAction{
	_dragToRightAction = dragToRightAction;

}



#pragma mark - SingleCardViewDelegate
-(void)singleCardView:(SingleCardView *)singleCardView panGestureRecognizer:(UIPanGestureRecognizer *)pan{
	CGFloat x,y,changeW = 0.0,changeY = 0.0;
	x = [pan translationInView:self].x;
	y = [pan translationInView:self].y;
//	NSLog(@"%f==%f",x,y);
	if (pan.state == UIGestureRecognizerStateBegan) {
		_originPoint = [pan locationInView:self];
		
		for (int index = 1; index < self.cardViews.count; index++) {
			if (index > 2) {
				break;
			}
			SingleCardView *subCard = self.cardViews[index];
			CGRect frame = subCard.frame;
			[self.changingCardViewFrames addObject:[NSValue valueWithCGRect:frame]];
		}
	}
	if (pan.state == UIGestureRecognizerStateChanged) {
		//旋转角度
		_translateX += x;
		_translateY += y;
		CGFloat angle = -atan(x/(self.frame.size.width - 2 * kLeftSpace) * 1.37) / 3;//3为角度旋转比例，越大转的越慢
		
		
		singleCardView.transform = CGAffineTransformTranslate(singleCardView.transform, x, y);
		singleCardView.transform = CGAffineTransformRotate(singleCardView.transform, angle);
		
		//往左
		if (_translateX < 0) {
			if (fabs(_translateX) < _minTrasnlate) {
				changeW = -x * 10 / _minTrasnlate;
				changeY = -x * 5 / _minTrasnlate;
				
			}
		}else {
			if (fabs(_translateX) < _minTrasnlate) {
				
				changeW = x * 10 / _minTrasnlate;
				changeY = x * 5 / _minTrasnlate;
			}
		}
		
		
		if (self.cardViews.count > 1) {
			for (int index = 1; index < self.cardViews.count; index++) {
				if (index > 2) {
					break;
				}
				SingleCardView *subCard = self.cardViews[index];
				CGRect frame = subCard.frame;
				subCard.frame = CGRectMake(frame.origin.x - changeW * 0.5, frame.origin.y + changeY, frame.size.width + changeW, (frame.size.width + changeW) * 1.37);
			}
		}
		[pan setTranslation:CGPointZero inView:self];
	}else if (pan.state == UIGestureRecognizerStateEnded){
		_nowPoint = [pan locationInView:self];
		if (_translateX < -_minTrasnlate && _translateY > -_minTrasnlate) {
			
			[self removeTopSingleCardView:singleCardView];
			[self.cardViews removeObjectAtIndex:0];
			if (self.dragToLeftAction) {
				self.dragToLeftAction();
			}
		}else if (_translateX > _minTrasnlate && _translateY > -_minTrasnlate) {
			
			[self removeTopSingleCardView:singleCardView];
			[self.cardViews removeObjectAtIndex:0];
			if (self.dragToRightAction) {
				self.dragToRightAction();
			}
		}else if (_translateY < -_minTrasnlate) {
			
			[self removeTopSingleCardView:singleCardView];
			[self.cardViews removeObjectAtIndex:0];
			if (self.dragToTopAction) {
				self.dragToTopAction();
			}
		}else{
			
			[UIView animateWithDuration:0.5 animations:^{
				singleCardView.transform = CGAffineTransformIdentity;
			}];
			if (self.cardViews.count > 1) {
				for (int index = 1 ; index < self.cardViews.count; index++) {
					if (index > 2) {
						break;
					}
					SingleCardView *subCard = self.cardViews[index];
					CGRect frame = [self.changingCardViewFrames[index - 1] CGRectValue];
					[UIView animateWithDuration:0.5 animations:^{
						subCard.frame = frame;
					}];
				}
			}
			
		}
		[self.changingCardViewFrames removeAllObjects];
		_translateX = 0.f;
		_translateY = 0.f;
	}
}

-(void)removeTopSingleCardView:(SingleCardView *)singleCardView {
	//计算位移角度
	CGFloat tanAngle = fabs(_nowPoint.y - _originPoint.y) / fabs(_nowPoint.x - _originPoint.x);
	CGFloat angle = fabs(atan(tanAngle));
	//对角线长度
	CGFloat screenDiagonal = sqrt(pow(self.frame.size.width, 2) + pow(self.frame.size.height, 2));
	//水平方向剩余位移
	CGFloat nextTranslateX = screenDiagonal * cos(angle) - fabs(_nowPoint.x - _originPoint.x);
	//垂直方向剩余位移
	CGFloat nextTranslateY = screenDiagonal *sin(angle) - fabs(_nowPoint.y - _originPoint.y);
	//计算终点
	CGFloat endX = (_nowPoint.x > _originPoint.x) ? (nextTranslateX + singleCardView.frame.origin.x) : (singleCardView.frame.origin.x - nextTranslateX);
	CGFloat endY = (_nowPoint.y > _originPoint.y) ? (nextTranslateY + singleCardView.frame.origin.y) : (singleCardView.frame.origin.y - nextTranslateY);
	
	[UIView animateWithDuration:MAX(nextTranslateX, nextTranslateY) / singleCardView.frame.size.height animations:^{
		singleCardView.frame = CGRectMake(endX, endY, singleCardView.frame.size.width, singleCardView.frame.size.height);
		
		if (self.cardViews.count > 1) {
			for (int index = 1; index < self.cardViews.count; index++) {
				if (index > 2) {
					break;
				}
				SingleCardView *subCard = self.cardViews[index];
				CGRect frame = [self.changingCardViewFrames[index - 1] CGRectValue];
				subCard.frame = CGRectMake(frame.origin.x - 10 * 0.5, frame.origin.y + 5, frame.size.width + 10, (frame.size.width + 10) * 1.37);
			}
		}
	} completion:^(BOOL finished) {
		[singleCardView removeFromSuperview];
	}];
	_originPoint = CGPointZero;
	_nowPoint = CGPointZero;
}

@end

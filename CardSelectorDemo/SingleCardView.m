//
//  SingleCardView.m
//  CardSelectorDemo
//
//  Created by zhaoP on 16/9/5.
//  Copyright © 2016年 langya. All rights reserved.
//

#import "SingleCardView.h"



@implementation SingleCardView

-(instancetype)initWithFrame:(CGRect)frame{
	
	if (self = [super initWithFrame:frame]) {
		self.layer.cornerRadius = 4;
		self.layer.masksToBounds = YES;
		UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panHandle:)];
		[self addGestureRecognizer:pan];
		
		UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHandle:)];
		[self addGestureRecognizer:tap];
		[pan requireGestureRecognizerToFail:tap];
		
	}
	return self;
}

-(void)panHandle:(UIPanGestureRecognizer *)pan {
	if ([self.delegate respondsToSelector:@selector(singleCardView:panGestureRecognizer:)]) {
		[self.delegate performSelector:@selector(singleCardView:panGestureRecognizer:) withObject:self withObject:pan];
	}
}

-(void)tapHandle:(UITapGestureRecognizer *)tap {
	if (self.tapAction) {
		self.tapAction();
	}
}







@end

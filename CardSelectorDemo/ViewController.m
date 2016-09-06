//
//  ViewController.m
//  CardSelectorDemo
//
//  Created by zhaoP on 16/9/5.
//  Copyright © 2016年 langya. All rights reserved.
//

#import "ViewController.h"
#import "CardSelectorView.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	CardSelectorView *cardSelectorView = [[CardSelectorView alloc] initWithFrame:self.view.frame];
	cardSelectorView.cardDatas = @[@"1",@"2",@"3",@"4"];
	cardSelectorView.tapAction = ^(){
		NSLog(@"==tap==");
	};
	cardSelectorView.dragToLeftAction = ^(){
		NSLog(@"向左");
	};
	cardSelectorView.dragToRightAction = ^(){
		NSLog(@"向右");
	};
	
	cardSelectorView.dragToTopAction = ^(){
		NSLog(@"向上");
	};
	
	[self.view addSubview:cardSelectorView];
	@weakify(self);
	[cardSelectorView mas_makeConstraints:^(MASConstraintMaker *make) {
		@strongify(self);
		make.edges.equalTo(self.view);
	}];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	
}

@end

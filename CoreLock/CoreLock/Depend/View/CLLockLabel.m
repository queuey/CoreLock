//
//  CLLockLabel.m
//  CoreLock
//
//  Created by 成林 on 15/4/27.
//  Copyright (c) 2015年 冯成林. All rights reserved.
//

#import "CLLockLabel.h"
#import "CoreLockConst.h"
#import "CALayer+Anim.h"
#import "UIColor+YBAdd.h"


@implementation CLLockLabel


#pragma mark - life cycle
- (instancetype)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	if (self) {
		[self viewPrepare];//视图初始化
	}
	return self;
}


- (instancetype)initWithCoder:(NSCoder *)aDecoder {
	self = [super initWithCoder:aDecoder];
	if (self) {
		[self viewPrepare];//视图初始化
	}
	return self;
}


#pragma mark - event response
/*
 *  普通提示信息
 */
- (void)showNormalMsg:(NSString *)msg {
	
	self.text = msg;
	self.textColor = [UIColor colorWithHex:coreLockCircleLineNormalColor];
}


/*
 *  警示信息
 */
- (void)showWarnMsg:(NSString *)msg {
	
	self.text = msg;
	self.textColor = [UIColor colorWithHex:coreLockWarnColor];
	
	//添加一个shake动画
	[self.layer shake];
}


#pragma mark - private methods
/*
 *  视图初始化
 */
- (void)viewPrepare {
	self.font = [UIFont systemFontOfSize:16.0f];
}

#pragma mark - getters and setters




@end

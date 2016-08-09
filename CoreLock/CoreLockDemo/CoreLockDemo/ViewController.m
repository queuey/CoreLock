//
//  ViewController.m
//  CoreLock
//
//  Created by 成林 on 15/4/21.
//  Copyright (c) 2015年 冯成林. All rights reserved.
//

#import "ViewController.h"
#import "CLLockVC.h"

NSString * const kUserId = @"1234";

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

/*
 *  设置密码
 */
- (IBAction)setPwd:(id)sender {
    
    
	BOOL hasPwd = [CLLockVC hasPassWordWithUser:kUserId];
    hasPwd = NO;
    if (hasPwd) {
        NSLog(@"已经设置过密码了，你可以验证或者修改密码");
    } else {
		[CLLockVC showUserId:kUserId settingLockVCInVC:self successBlock:^(CLLockVC *lockVC, NSString *pwd) {
			NSLog(@"密码设置成功");
			[lockVC dismiss:1.0f];
			NSLog(@"密码是%@",pwd);
		}];
    }
}

/*
 *  验证密码
 */
- (IBAction)verifyPwd:(id)sender {
    
    BOOL hasPwd = [CLLockVC hasPassWordWithUser:kUserId];
    
    if (!hasPwd) {
        
        NSLog(@"你还没有设置密码，请先设置密码");
    } else {
        
		[CLLockVC showUserId:kUserId verifyLockVCInVC:self forgetPwdBlock:^{
			NSLog(@"忘记密码");
		} successBlock:^(CLLockVC *lockVC, NSString *pwd) {
			NSLog(@"密码正确");
			[lockVC dismiss:1.0f];
		}];
    }
}


/*
 *  修改密码
 */
- (IBAction)modifyPwd:(id)sender {
    
    BOOL hasPwd = [CLLockVC hasPassWordWithUser:kUserId];
    
    if (!hasPwd) {
        NSLog(@"你还没有设置密码，请先设置密码");
    } else {
		[CLLockVC showUserId:kUserId modifyLockVCInVC:self successBlock:^(CLLockVC *lockVC, NSString *pwd) {
			
			[lockVC dismiss:.5f];
		}];
	}
}




@end

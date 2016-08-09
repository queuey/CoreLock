//
//  CLLockVC.h
//  CoreLock
//
//  Created by 成林 on 15/4/21.
//  Copyright (c) 2015年 冯成林. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSInteger, CoreLockType) {
	//设置密码
	CoreLockTypeSetPwd = 0,
	//输入并验证密码
	CoreLockTypeVeryfiPwd,
	//修改密码
	CoreLockTypeModifyPwd,
};


@interface CLLockVC : UIViewController


@property (nonatomic, assign) CoreLockType type;


/*
 *  是否有本地密码缓存？即用户是否设置过初始密码？
 */
+ (BOOL)hasPassWordWithUser:(NSString *)userId ;

/*
 *  展示设置密码控制器
 */
+ (instancetype)showUserId:(NSString *)user settingLockVCInVC:(UIViewController *)vc successBlock:(void(^)(CLLockVC *lockVC, NSString *pwd))successBlock;


/*
 *  展示验证密码输入框
 */
+ (instancetype)showUserId:(NSString *)user verifyLockVCInVC:(UIViewController *)vc forgetPwdBlock:(void(^)())forgetPwdBlock successBlock:(void(^)(CLLockVC *lockVC, NSString *pwd))successBlock;

/*
 *  展示验证密码输入框
 */
+ (instancetype)showUserId:(NSString *)user modifyLockVCInVC:(UIViewController *)vc successBlock:(void(^)(CLLockVC *lockVC, NSString *pwd))successBlock;

/**
 *	让手势密码界面interval间隔后消失
 *
 *	@param interval	间隔时间
 */
- (void)dismiss:(NSTimeInterval)interval;


@end

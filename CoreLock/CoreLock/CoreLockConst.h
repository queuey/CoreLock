//
//  CoreLockConst.h
//  CoreLock
//
//  Created by 成林 on 15/4/24.
//  Copyright (c) 2015年 冯成林. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


#ifndef _CoreLockConst_H_
#define _CoreLockConst_H_


///*
// *  背景色
// */
static UInt32 const coreLockViewBgColor = 0x0d3459;
/*
 *  外环线条颜色：默认
 */
static UInt32 const coreLockCircleLineNormalColor = 0xF1F1F1;

/*
 *  外环线条颜色：选中
 */
static UInt32 const coreLockCircleLineSelectedColor = 0x22B2F6;

/*
 *  实心圆
 */
static UInt32 const coreLockCircleLineSelectedCircleColor = 0x22b2f6;

/*
 *  实心圆
 */
static UInt32 const coreLockLockLineColor = 0x22b2f6;
/*
 *  警示文字颜色
 */
static UInt32 const coreLockWarnColor = 0xfe525c;


/* 两个圆之间的间距 */
static CGFloat const CoreLockCellMargin = 38.0f;
/* 选中圆大小比例 */
static CGFloat const CoreLockArcWHR = 0.3f;


/** 选中圆大小的线宽 */
static CGFloat const CoreLockArcLineW = 1.0f;


/** 密码存储Key */
static NSString * const CoreLockPWDKey = @"CoreLockPassWordKey";



/**/
/*  设置密码  */
/**/

/** 最低设置密码数目 */
static NSUInteger const CoreLockMinItemCount = 4;


/** 设置密码提示文字 */
static NSString * const CoreLockPWDTitleFirst = @"请滑动设置新密码";

/** 设置密码提示文字：确认 */
static NSString *const CoreLockPWDTitleConfirm = @"请再次输入确认密码";


/** 设置密码提示文字：再次密码不一致 */
static NSString *const CoreLockPWDDiffTitle = @"再次密码输入不一致";

/** 设置密码提示文字：设置成功 */
static NSString *const CoreLockPWSuccessTitle = @"密码设置成功！";




/**/
/*  验证密码  */
/**/

/** 验证密码：普通提示文字 */
static NSString *const CoreLockVerifyNormalTitle = @"请滑动输入密码";

/** 验证密码：密码错误 */
static NSString *const CoreLockVerifyErrorPwdTitle = @"输入密码错误";

/** 验证密码：验证成功 */
static NSString *const CoreLockVerifySuccesslTitle = @"密码正确";



/**/
/*  修改密码  */
/**/

/** 修改密码：普通提示文字 */
static NSString *const CoreLockModifyNormalTitle = @"请输入旧密码";


#endif
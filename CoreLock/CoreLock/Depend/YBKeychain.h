//
//  YBKeychain.h
//  jfccFinancial
//
//  Created by 杨斌 on 15/10/27.
//  Copyright © 2015年 杨斌. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString * const keyChain_CoreLockKey = @"keyChain_CoreLockKey";


@interface YBKeychain : NSObject
/**
 *	保存数据至KeyChain
 *
 *	@param service	需要存储数据对应的KEY
 *	@param data		需要存储的数据
 */
+ (void)save:(NSString *)service data:(id)data;
/**
 *	取出数据
 *
 *	@param service	service KEY
 *
 *	@return 需要取出的数据
 */
+ (id)load:(NSString *)service;
/**
 *	删除数据
 *
 *	@param service	删除SERVICE对应的数据
 */
+ (void)deleteItems:(NSString *)service;


@end

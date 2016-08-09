//
//  CLLockVC.m
//  CoreLock
//
//  Created by 成林 on 15/4/21.
//  Copyright (c) 2015年 冯成林. All rights reserved.
//

#import "CLLockVC.h"
#import "CoreLockConst.h"
#import "CLLockLabel.h"
#import "CLLockNavVC.h"
#import "CLLockView.h"
#import "UIColor+YBAdd.h"
#import "YBKeychain.h"

@interface CLLockVC ()

/** 操作成功：密码设置成功、密码验证成功 */
@property (copy, nonatomic) void (^successBlock)(CLLockVC *lockVC,NSString *pwd);
/**/
@property (copy, nonatomic) void (^forgetPwdBlock)();
/**/
@property (weak, nonatomic) IBOutlet CLLockLabel *label;
/*提示信息*/
@property (copy, nonatomic) NSString *msg;
/**/
@property (weak, nonatomic) IBOutlet CLLockView *lockView;
/**/
@property (weak, nonatomic) UIViewController *vc;
/*重置第一次手势*/
@property (strong, nonatomic) UIBarButtonItem *resetItem;
/**/
@property (copy, nonatomic) NSString *modifyCurrentTitle;
/**/
@property (weak, nonatomic) IBOutlet UIView *actionView;
/*修改密码按钮*/
@property (weak, nonatomic) IBOutlet UIButton *modifyBtn;

/** 直接进入修改页面的 */
@property (nonatomic) BOOL isDirectModify;

@property (nonatomic, copy) NSString *userID;


@end


@implementation CLLockVC

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];

    //控制器准备
    [self vcPrepare];
    //数据传输
    [self dataTransfer];
    //事件
    [self event];
}


/*
 *  事件
 */
- (void)event {
	
	/**/
	/*  设置密码  */
	/**/
    
    /** 开始输入：第一次 */
    self.lockView.setPWBeginBlock = ^(){
        [self.label showNormalMsg:CoreLockPWDTitleFirst];
    };
    
    /** 开始输入：确认 */
    self.lockView.setPWConfirmlock = ^(){
        [self.label showNormalMsg:CoreLockPWDTitleConfirm];
    };
	
    /** 密码长度不够 */
    self.lockView.setPWSErrorLengthTooShortBlock = ^(NSUInteger currentCount){
        [self.label showWarnMsg:[NSString stringWithFormat:@"请连接至少%@个点",@(CoreLockMinItemCount)]];
    };

    /** 两次密码不一致 */
    self.lockView.setPWSErrorTwiceDiffBlock = ^(NSString *pwd1,NSString *pwdNow){
		
		[self.label showWarnMsg:CoreLockPWDDiffTitle];
        self.navigationItem.rightBarButtonItem = self.resetItem;
    };
    
    /** 第一次输入密码：正确 */
    self.lockView.setPWFirstRightBlock = ^(){
      
        [self.label showNormalMsg:CoreLockPWDTitleConfirm];
    };
    
    /** 再次输入密码一致 */
    self.lockView.setPWTwiceSameBlock = ^(NSString *pwd){
      
        [self.label showNormalMsg:CoreLockPWSuccessTitle];

        //存储密码
		NSMutableDictionary *keys = [YBKeychain load:keyChain_CoreLockKey];
		if (!(keys && [keys isKindOfClass:[NSDictionary class]])) {
			keys = [[NSMutableDictionary alloc] init];
		}
		keys = keys.mutableCopy;
		[keys setObject:pwd forKey:self.userID];

		[YBKeychain save:keyChain_CoreLockKey data:keys];
		
        //禁用交互
        self.view.userInteractionEnabled = NO;
        
		if (_successBlock) {
			_successBlock(self,pwd);
		}
			
        if (CoreLockTypeModifyPwd == _type) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        }
    };
    
    
    
	/**/
	/*  验证密码  */
	/**/
    
    /** 开始 */
    self.lockView.verifyPWBeginBlock = ^(){
        
        [self.label showNormalMsg:CoreLockVerifyNormalTitle];
    };
    
    /** 验证 */
    self.lockView.verifyPwdBlock = ^(NSString *pwd){
    
        //取出本地密码
		NSDictionary *keys = [YBKeychain load:keyChain_CoreLockKey];
		if (!(keys && [keys isKindOfClass:[NSDictionary class]])) {
			keys = [[NSDictionary alloc] init];
		}
		
		NSString *pwdLocal = [keys objectForKey:self.userID];

        BOOL res = [pwdLocal isEqualToString:pwd];
        
        if (res) {//密码一致
            
            [self.label showNormalMsg:CoreLockVerifySuccesslTitle];
            
            if (CoreLockTypeVeryfiPwd == _type) {
                
                //禁用交互
                self.view.userInteractionEnabled = NO;
                
            } else if (CoreLockTypeModifyPwd == _type) {//修改密码
                
                [self.label showNormalMsg:CoreLockPWDTitleFirst];
                
                self.modifyCurrentTitle = CoreLockPWDTitleFirst;
            }
            
            if (CoreLockTypeVeryfiPwd == _type && _successBlock) {
                _successBlock(self,pwd);
            }
            
        } else {//密码不一致
            
            [self.label showWarnMsg:CoreLockVerifyErrorPwdTitle];

        }
        
        return res;
    };
    
    
    
	/**/
	/*  修改密码  */
	/**/
	
    /** 开始 */
    self.lockView.modifyPwdBlock = ^(){
        [self.label showNormalMsg:self.modifyCurrentTitle];
    };
}






/*
 *  数据传输
 */
- (void)dataTransfer {
	
    [self.label showNormalMsg:self.msg];
    //传递类型
    self.lockView.type = self.type;
}


/*
 *  控制器准备
 */
- (void)vcPrepare {

    //设置背景色
	self.view.backgroundColor = [UIColor colorWithHex:coreLockViewBgColor];
	
    //初始情况隐藏
    self.navigationItem.rightBarButtonItem = nil;
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    
    //默认标题
    self.modifyCurrentTitle = CoreLockModifyNormalTitle;
    
    if (CoreLockTypeModifyPwd == _type) {
        
        _actionView.hidden = YES;
        
        [_actionView removeFromSuperview];

        if(_isDirectModify) return;
        
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"关闭" style:UIBarButtonItemStylePlain target:self action:@selector(dismiss)];
    }
    
    if (![self.class hasPassWordWithUser:self.userID]) {
        [_modifyBtn removeFromSuperview];
    }
}

- (void)dismiss {
    [self dismiss:0];
}



/*
 *  密码重设
 */
- (void)setPwdReset {
    
    [self.label showNormalMsg:CoreLockPWDTitleFirst];
    
    //隐藏
    self.navigationItem.rightBarButtonItem = nil;
    
    //通知视图重设
    [self.lockView resetPwd];
}


/*
 *  忘记密码
 */
- (void)forgetPwd {
    
}



/*
 *  修改密码
 */
- (void)modiftyPwd {
    
}

/*
 *  是否有本地密码缓存？即用户是否设置过初始密码？
 */
+ (BOOL)hasPassWordWithUser:(NSString *)userId {
	
	NSDictionary *keys = [YBKeychain load:keyChain_CoreLockKey];
	NSLog(@"key = %@",keys);
	if (!(keys && [keys isKindOfClass:[NSDictionary class]])) {
		keys = [[NSDictionary alloc] init];
	}
	

	NSString *pwd = [keys objectForKey:userId];

    return pwd != nil;
}




/*
 *  展示设置密码控制器
 */
+ (instancetype)showUserId:(NSString *)user settingLockVCInVC:(UIViewController *)vc successBlock:(void(^)(CLLockVC *lockVC,NSString *pwd))successBlock {
    
    CLLockVC *lockVC = [self lockVC:vc];
    
    lockVC.title = @"设置密码";
    
    //设置类型
    lockVC.type = CoreLockTypeSetPwd;
    lockVC.userID = user;
    //保存block
    lockVC.successBlock = successBlock;
    
    return lockVC;
}




/*
 *  展示验证密码输入框
 */
+ (instancetype)showUserId:(NSString *)user verifyLockVCInVC:(UIViewController *)vc forgetPwdBlock:(void(^)())forgetPwdBlock successBlock:(void(^)(CLLockVC *lockVC, NSString *pwd))successBlock {
    
    
    CLLockVC *lockVC = [self lockVC:vc];
    
    lockVC.title = @"手势解锁";
    
    //设置类型
    lockVC.type = CoreLockTypeVeryfiPwd;
    lockVC.userID = user;
    //保存block
    lockVC.successBlock = successBlock;
    lockVC.forgetPwdBlock = forgetPwdBlock;
    
    return lockVC;
}




/*
 *  展示验证密码输入框
 */
+ (instancetype)showUserId:(NSString *)user modifyLockVCInVC:(UIViewController *)vc successBlock:(void(^)(CLLockVC *lockVC, NSString *pwd))successBlock {
    
    CLLockVC *lockVC = [self lockVC:vc];
    
    lockVC.title = @"修改密码";
    
    //设置类型
    lockVC.type = CoreLockTypeModifyPwd;
	lockVC.userID = user;
    //记录
    lockVC.successBlock = successBlock;
    
    return lockVC;
}




+ (instancetype)lockVC:(UIViewController *)vc {
    
    CLLockVC *lockVC = [[CLLockVC alloc] init];

    lockVC.vc = vc;
    
    CLLockNavVC *navVC = [[CLLockNavVC alloc] initWithRootViewController:lockVC];
    
    [vc presentViewController:navVC animated:YES completion:nil];

    
    return lockVC;
}



- (void)setType:(CoreLockType)type {
    
    _type = type;
    //根据type自动调整label文字
    [self labelWithType];
}






/*
 *  消失
 */
- (void)dismiss:(NSTimeInterval)interval {
	
	dispatch_async(dispatch_get_main_queue(), ^{
		[self dismissViewControllerAnimated:YES completion:nil];
	});
	
}


/*
 *  重置
 */
- (UIBarButtonItem *)resetItem {
    if (!_resetItem) {
        //添加右按钮
        _resetItem= [[UIBarButtonItem alloc] initWithTitle:@"重设" style:UIBarButtonItemStylePlain target:self action:@selector(setPwdReset)];
    }
    
    return _resetItem;
}








#pragma mark - delegate


#pragma mark - event response

- (IBAction)forgetPwdAction:(id)sender {
	
	[self dismiss:0];
	if (_forgetPwdBlock) _forgetPwdBlock();
}


- (IBAction)modifyPwdAction:(id)sender {
	
	CLLockVC *lockVC = [[CLLockVC alloc] init];
	
	lockVC.title = @"修改密码";
	
	lockVC.isDirectModify = YES;
	
	//设置类型
	lockVC.type = CoreLockTypeModifyPwd;
	
	[self.navigationController pushViewController:lockVC animated:YES];
}


#pragma mark - private methods
/*
 *  根据type自动调整label文字
 */
- (void)labelWithType {
	
	switch (_type) {
			
		case CoreLockTypeSetPwd: {
			self.msg = CoreLockPWDTitleFirst;
		} break;
			
		case CoreLockTypeVeryfiPwd: {
			self.msg = CoreLockVerifyNormalTitle;
		} break;
			
		case CoreLockTypeModifyPwd: {
			self.msg = CoreLockModifyNormalTitle;
		} break;
	}
	
}


#pragma mark - getters and setters




@end

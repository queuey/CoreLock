<br /><br />



## Fork内容

1. 取消NSUserDefaults存储，改用KeyChain存储手势密码。
2. 可以存储多组手势密码。
3. 将源代码规范化。

后续继续优化方案：

1. 将CoreLock提取成View，以供更多设计需求使用。
2. 类名和方法名规范化。



****



    Charlin出框架的目标：简单、易用、实用、高度封装、绝对解耦！

CoreLock（关注[信息公告牌](https://github.com/CharlinFeng/Show)）
===============
高仿支付宝解锁！<br />

    注：本框架是高仿支付宝，并集成了所有功能，并非一个简单的解锁界面展示。个人制作用时1周多，打造解锁终结者框架。



<br /><br />
示例截图
===============
![image](./CoreLock/core.gif)<br />
<br /><br />


框架特性：
===============
>.ios版本兼容ios 7.0及以上.<br />
>.扁平化设计，全部使用QuartzCore引擎绘制，没有使用任何图片素材<br />
>.完全解耦，不需要继承，不需要定义成员属性，类方法直接搞定一切。<br />
>.自动管理生命周期，你只需要使用即可，不需要管理控制器的生命周期。<br />
>block封装，不需要任何代理<br />
>.完美屏幕适配，支持所有ios设备。<br />
>.做了比较多的性能优化，最大必的提高性能。<br />
>.完善的错误处理机制。<br />

<br /><br />
Charlin想说：
===============
此版本是全部的QuartzCore绘制，整个框架使用了几乎所有的QuartzCore技术，如果你有兴趣，可以看下源代码，
算是一个比较不错的QuartzCore实战教程。

对于本框架，有以下技术点和大家分享：<br />
1.主界面使用Xib定制，如果你需要添加控件，非常方便，比如支付宝顶部有用户头像，我这里没有，所以就没加，如果你需要加，直接在xib添加即可。<br />
2.本地数据存储使用沙盒存储。<br />
3.无任何代理设计，全程使用block解决，引用老刘的一句话，目前代理设计模式正在被块代码所逐步取代。<br />
4.解锁线条绘制使用的是比较复杂的奇偶裁剪技术。有兴趣可以看看苹果官方示例。<br />
5.关于QuartzCore，使用到的技术除了基本的绘制以外，还使用了图形上下文栈，矩阵变换，刷新图层等。<br />
6.本框架考虑了添加密码，修改密码，验证密码，忘记密码等支付宝几乎全部的功能，并且使用简单。<br />





<br /><br />

#### 使用示例

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
    



  <br /><br />

  


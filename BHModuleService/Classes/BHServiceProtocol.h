//
//  BHServiceProtocol.h
//  BHModuleService
//
//  Created by 汪志刚 on 2019/01/29.
//  Copyright © 2019年 wwwarehouse. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 服务协议
 */
@protocol BHServiceProtocol <NSObject>

@optional

/**
 设置注册服务是否异步进行，默认异步。
 注：对注册app间调用的服务无效，且注册app间是同步进行的。
 如果出现：代码已注册服务，但是代码奔溃提示服务未注册。请把服务改为  同步  进行。

 @return 是否异步
 */
+ (BOOL)async;

/**
 设置是否成为单例

 @return 是否是单例
 */
+ (BOOL)isSingleton;

/**
 获取单例对象

 @return 返回单例对象
 */
+ (id)sharedInstance;

@end

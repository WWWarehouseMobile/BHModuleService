//
//  BHServiceManager.h
//  BHModuleService
//
//  Created by WZG on 19/01/29.
//  Copyright © 2019年 浙江网仓科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
 创建服务的block，主要用于app间跳转

 @param service 服务对象
 @param params 参数字典
 */
typedef void(^BHServiceCreatedBlock)(id _Nullable service, NSDictionary *_Nullable params);

typedef void(^BHNavServiceBlock)(UIViewController *_Nullable service, UINavigationController *_Nullable nav);
/**
 服务管理类
 */
@interface BHServiceManager : NSObject

+ (instancetype _Nonnull)sharedInstance;

/**
 注册 SAService.plist 中的服务
 plist 格式 ：
 {
 "protocol" : "service",
 }
 */
+ (void)registerLocalServices;

/**
 注册数组中的服务
 serviceList 格式 ：
 {
 "protocol" : "service",
 }
 @param serviceDictionary 服务字典
 */
+ (void)registerServicesWithServiceDictionary:(NSDictionary <NSString *, NSString *>*)serviceDictionary;

/**
 开启 log 日志打印
 */
+ (void)enableDebugLog;

#pragma mark-
#pragma mark-   注册模块间调用服务，协议注册

/**
 通过protocol创建对应的服务，主要用于模块间的调用

 @param protocol 协议Protocol
 @return 返回协议对应的服务
 */
+ (id _Nullable)createServiceWithProtocol:(Protocol *_Nonnull)protocol;

/**
 使用协议注册服务，将对应模块的protocol和service进行绑定。主要用于模块间的调用。
 注：此方法需要在 load 中调用。不可多次调用。
 
 @param protocol 模块协议
 @param service 模块服务，即模块的入口类
 */
+ (void)registerServiceWithProtocol:(Protocol *_Nonnull)protocol service:(Class _Nonnull)service;



/*---------------------------------------------------------------------------------------------*/



/**
 通过protocol创建对应的服务，主要用于模块间的调用。
 注：使用此方法会创建一个以 service 的实例为根控制器的导航控制器。如果注册是没有导航，则只会创建一个 service 实例。
 此方法创建的 service 实例必须是 UIViewController 类或其子类；nav 则必须是 UINavigationController 类或其子类。
 
 @param protocol 模块协议
 @param completion 服务创建完成的回调
 */
+ (void)createServiceWithProtocol:(Protocol *_Nonnull)protocol completion:(BHNavServiceBlock)completion;

/**
 使用协议注册服务，将对应模块的protocol和service, navClass进行绑定。主要用于模块间的调用。
 注：此方法需要在 load 中调用。不可多次调用。

 @param protocol 模块协议
 @param service 模块服务，即模块的入口类
 @param navClass 导航控制器类
 */
+ (void)registerServiceWithProtocol:(Protocol *_Nonnull)protocol
                            service:(Class _Nonnull)service
                           navClass:(Class _Nullable)navClass;

#pragma mark-
#pragma mark-   注册模块间调用服务，路由注册

/**
 通过OpenUrl创建对应的服务。可用于 app 间的调整。

 @param openUrl NSURL对象
 @param compeletion 服务创建Block
 */
+ (void)createServiceWithOpenUrl:(NSURL *_Nullable)openUrl compeletion:(BHServiceCreatedBlock _Nullable)compeletion;

/**
 通过 路由 创建对应的服务，主要用于模块间的调用。
 注：此方法需要在 load 中调用。不可多次调用。

 @param urlString 用于app间调转的字符串
 @param service 服务类Class
 */
+ (void)registerServiceWithUrlString:(NSString *_Nonnull)urlString service:(Class _Nonnull)service;



#pragma mark-
#pragma mark-   DEPRECATED METHOD
- (void)registerServiceWithProtocol:(Protocol *_Nonnull)protocol service:(Class _Nonnull)service DEPRECATED_MSG_ATTRIBUTE("use static func 'registerServiceWithProtocol:service:' instead");

- (void)registerServiceWithUrlString:(NSString *_Nonnull)urlString service:(Class _Nonnull)service DEPRECATED_MSG_ATTRIBUTE("use static func 'registerServiceWithUrlString:service:' instead");

@end

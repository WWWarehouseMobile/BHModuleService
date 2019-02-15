//
//  BHModuleManager.h
//  BHModuleService
//
//  Created by 汪志刚 on 2019/01/29.
//  Copyright © 2019年 浙江网仓科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BHModuleAppDelegate.h"

/**
 模块管理类
 */

@interface BHModuleManager : NSObject

+ (instancetype)sharedInstance;

/**
 注册 SAModule.plist 中所有的模块
 plist 格式 ：
 [
 "moduleClass"
 ]
 */
- (void)registerLocalModules;

- (void)registerModulesWithModuleArray:(NSArray <NSString *>*)moduleArray;

/**
 注册模块，主要用于处理AppDelegate中的事件

 @param modlue 模块类Class
 */
- (void)registerModule:(Class <BHModuleAppDelegate>)modlue;

- (void)trigger_applicationWillFinishLaunchingWithOptions:(NSDictionary *)options;

/**
 应用启动完成
 
 @param options 启动参数
 */
- (void)trigger_applicationDidFinishLaunchingWithOptions:(NSDictionary *)options;

/**
 程序暂行
 */
- (void)trigger_applicationWillResignActive;

/**
 程序已经进入后台
 */
- (void)trigger_applicationDidEnterBackground;

/**
 程序将要进入前台
 */
- (void)trigger_applicationWillEnterForeground;

/**
 程序已经被激活
 */
- (void)trigger_applicationDidBecomeActive;

/**
 程序将要被终止
 */
- (void)trigger_applicationWillTerminate;

/**
 3D-Touch
 
 @param shortcutItem touch对象
 @param completionHandler 完成block
 */
- (void)trigger_applicationPerformActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem completionHandler:(void (^)(BOOL))completionHandler;

/**
 app间调转
 */
- (BOOL)trigger_applicationOpenURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation;

#if __IPHONE_OS_VERSION_MAX_ALLOWED > 80400
- (BOOL)trigger_applicationOpenURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options;
#endif

/**
 收到远程推送
 
 @param userInfo 推送信息
 */
- (void)trigger_applicationDidReceiveRemoteNotification:(NSDictionary *)userInfo;

- (void)trigger_applicationDidReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler;

/**
 收到本地推送
 
 @param notification 本地通知
 */
- (void)trigger_applicationDidReceiveLocalNotification:(UILocalNotification *)notification;

/**
 iOS10+ PresentNotification
 
 */
- (void)trigger_userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler;

/**
 iOS10+ DidReceiveNotificationResponse
 */
- (void)trigger_userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void(^)())completionHandler;

/**
 DidUpdateUserActivity
 
 @param userActivity 模块事件item
 */
- (void)trigger_applicationDidUpdateUserActivity:(NSUserActivity *)userActivity;

/**
 DidFailToContinueUserActivity
 */
- (void)trigger_applicationDidFailToContinueUserActivityWithType:(NSString *)userActivityType error:(NSError *)error;

/**
 ContinueUserActivity
 */
- (BOOL)trigger_applicationContinueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void (^)(NSArray * ))restorationHandler;

/**
 WillContinueUserActivity
 
 @param userActivityType 模块事件item
 */
- (BOOL)trigger_applicationWillContinueUserActivityWithType:(NSString *)userActivityType;

/**
 将要收到内存警告
 */
- (void)trigger_applicationDidReceiveMemoryWarning;

@end

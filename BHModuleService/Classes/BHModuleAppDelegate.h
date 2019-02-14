//
//  BHModuleAppDelegate.h
//  BHModuleService
//
//  Created by 汪志刚 on 2019/01/29.
//
//

#import <Foundation/Foundation.h>
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif

@protocol BHModuleAppDelegate <NSObject>

/**
 如果要想以下方法触发，需要在AppDelegate中将对应的事件方法删掉。
 */
@optional

+ (void)bh_applicationWillFinishLaunchingWithOptions:(NSDictionary *)options;
/**
 应用启动完成
 
 @param options 启动参数
 */
+ (void)bh_applicationDidFinishLaunchingWithOptions:(NSDictionary *)options;

/**
 程序暂行
 */
+ (void)bh_applicationWillResignActive;

/**
 程序已经进入后台
 */
+ (void)bh_applicationDidEnterBackground;

/**
 程序将要进入前台
 */
+ (void)bh_applicationWillEnterForeground;

/**
 程序已经被激活
 */
+ (void)bh_applicationDidBecomeActive;

/**
 程序将要被终止
 */
+ (void)bh_applicationWillTerminate;

/**
 3D-Touch
 
 @param shortcutItem touch对象
 @param completionHandler 完成block
 */
+ (void)bh_applicationPerformActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem completionHandler:(void (^)(BOOL))completionHandler;

/**
 app间调转
 */
+ (BOOL)bh_applicationOpenURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation;

#if __IPHONE_OS_VERSION_MAX_ALLOWED > 80400
+ (BOOL)bh_applicationOpenURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options;
#endif

/**
 收到远程推送
 
 @param userInfo 推送信息
 */
+ (void)bh_applicationDidReceiveRemoteNotification:(NSDictionary *)userInfo;

+ (void)bh_applicationDidReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler;

/**
 收到本地推送
 
 @param notification 本地通知
 */
+ (void)bh_applicationDidReceiveLocalNotification:(UILocalNotification *)notification;

/**
 iOS10+ PresentNotification
 
 */
+ (void)bh_userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler;

/**
 iOS10+ DidReceiveNotificationResponse
 */
+ (void)bh_userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void(^)())completionHandler;

/**
 DidUpdateUserActivity
 
 @param userActivity 模块事件item
 */
+ (void)bh_applicationDidUpdateUserActivity:(NSUserActivity *)userActivity;

/**
 DidFailToContinueUserActivity
 */
+ (void)bh_applicationDidFailToContinueUserActivityWithType:(NSString *)userActivityType error:(NSError *)error;

/**
 ContinueUserActivity
 */
+ (BOOL)bh_applicationContinueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void (^)(NSArray * ))restorationHandler;

/**
 WillContinueUserActivity
 
 @param userActivityType 模块事件item
 */
+ (BOOL)bh_applicationWillContinueUserActivityWithType:(NSString *)userActivityType;

/**
 将要收到内存警告
 */
+ (void)bh_applicationDidReceiveMemoryWarning;

@end

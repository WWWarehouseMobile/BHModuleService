//
//  UIResponder+BHEventhandler.m
//  BHModuleService
//
//  Created by 汪志刚 on 2019/01/29.
//  Copyright © 2019年 浙江网仓科技有限公司. All rights reserved.
//

#import "UIResponder+BHEventhandler.h"
#import "BHModuleManager.h"

@interface UIResponder ()<UIApplicationDelegate>

@end

@implementation UIResponder (BHEventhandler)

- (void)bh_appDidFinishLaunchingWithOptions:(NSDictionary *)options {
    [[BHModuleManager sharedInstance] trigger_applicationDidFinishLaunchingWithOptions:options];
}

- (void)application:(UIApplication *)application performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem completionHandler:(void (^)(BOOL))completionHandler {
    [[BHModuleManager sharedInstance] trigger_applicationPerformActionForShortcutItem:shortcutItem completionHandler:completionHandler];
}

- (BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [[BHModuleManager sharedInstance] trigger_applicationWillFinishLaunchingWithOptions:launchOptions];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    [[BHModuleManager sharedInstance] trigger_applicationWillResignActive];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    [[BHModuleManager sharedInstance] trigger_applicationDidEnterBackground];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    [[BHModuleManager sharedInstance] trigger_applicationWillEnterForeground];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [[BHModuleManager sharedInstance] trigger_applicationDidBecomeActive];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    [[BHModuleManager sharedInstance] trigger_applicationWillTerminate];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [[BHModuleManager sharedInstance] trigger_applicationOpenURL:url sourceApplication:sourceApplication annotation:annotation];
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options {
    return [[BHModuleManager sharedInstance] trigger_applicationOpenURL:url options:options];
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    [[BHModuleManager sharedInstance] trigger_applicationDidReceiveMemoryWarning];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [[BHModuleManager sharedInstance] trigger_applicationDidReceiveRemoteNotification:userInfo];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    [[BHModuleManager sharedInstance] trigger_applicationDidReceiveRemoteNotification:userInfo fetchCompletionHandler:completionHandler];
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    [[BHModuleManager sharedInstance] trigger_applicationDidReceiveLocalNotification:notification];
}


- (void)application:(UIApplication *)application didUpdateUserActivity:(NSUserActivity *)userActivity {
    [[BHModuleManager sharedInstance] trigger_applicationDidUpdateUserActivity:userActivity];
}

- (void)application:(UIApplication *)application didFailToContinueUserActivityWithType:(NSString *)userActivityType error:(NSError *)error {
    [[BHModuleManager sharedInstance] trigger_applicationDidFailToContinueUserActivityWithType:userActivityType error:error];
}

- (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void (^)(NSArray * _Nullable))restorationHandler
{
    return [[BHModuleManager sharedInstance] trigger_applicationContinueUserActivity:userActivity restorationHandler:restorationHandler];
}

- (BOOL)application:(UIApplication *)application willContinueUserActivityWithType:(NSString *)userActivityType
{
    return [[BHModuleManager sharedInstance] trigger_applicationWillContinueUserActivityWithType:userActivityType];
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler {
    [[BHModuleManager sharedInstance] trigger_userNotificationCenter:center willPresentNotification:notification withCompletionHandler:completionHandler];
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void(^)())completionHandler {
    [[BHModuleManager sharedInstance] trigger_userNotificationCenter:center didReceiveNotificationResponse:response withCompletionHandler:completionHandler];
}

@end

//
//  BHModuleManager.m
//  BHModuleService
//
//  Created by 汪志刚 on 2019/01/29.
//  Copyright © 2019年 浙江网仓科技有限公司. All rights reserved.
//

#import "BHModuleManager.h"


@interface BHModuleManager ()

@property (nonatomic, strong) NSMutableArray <NSString *>*moduleList;

@end

@implementation BHModuleManager

+ (instancetype)sharedInstance {
    static BHModuleManager *handler = nil;
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        handler = [BHModuleManager new];
    });
    return handler;
}

#pragma mark-
#pragma mark- Public Methods
- (void)registerLocalModules {
    NSString *plistSubPath = @"BHModuleService.bundle/BHModule";
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:plistSubPath ofType:@"plist"];
    if (!plistPath) {
        return;
    }
    
    NSArray *moduleList = [[NSArray alloc] initWithContentsOfFile:plistPath];
    [self registerModulesWithModuleArray:moduleList];
}

- (void)registerModulesWithModuleArray:(NSArray <NSString *>*)moduleArray {
    
    [self.moduleList addObjectsFromArray:moduleArray];
    NSArray *newList = [self.moduleList valueForKeyPath:@"@distinctUnionOfObjects.self"];
    [self.moduleList removeAllObjects];
    [self.moduleList addObjectsFromArray:newList];
}

- (void)registerModule:(Class)modlue {
    
#if DEBUG
    NSAssert(modlue != nil, @"modlue should not be nil");
#else
    if (!modlue) return;
#endif
    
    if ([modlue conformsToProtocol:@protocol(BHModuleAppDelegate)]) {
        [self.moduleList addObject:NSStringFromClass(modlue)];
    }
}

- (void)trigger_applicationWillFinishLaunchingWithOptions:(NSDictionary *)options {
    [self.moduleList enumerateObjectsUsingBlock:^(NSString  *_Nonnull objStr, NSUInteger idx, BOOL * _Nonnull stop) {
        Class obj = NSClassFromString(objStr);
        if ([obj respondsToSelector:@selector(bh_applicationWillFinishLaunchingWithOptions:)]) {
            [obj bh_applicationWillFinishLaunchingWithOptions:options];
        }
    }];
}

- (void)trigger_applicationDidFinishLaunchingWithOptions:(NSDictionary *)options {
    [self.moduleList enumerateObjectsUsingBlock:^(NSString  *_Nonnull objStr, NSUInteger idx, BOOL * _Nonnull stop) {
        Class obj = NSClassFromString(objStr);
        if ([obj respondsToSelector:@selector(bh_applicationDidFinishLaunchingWithOptions:)]) {
            [obj bh_applicationDidFinishLaunchingWithOptions:options];
        }
    }];
}

- (void)trigger_applicationWillResignActive {
    [self handleModuleNoParamEvent:@selector(bh_applicationWillResignActive)];
}

- (void)trigger_applicationDidEnterBackground {
    [self handleModuleNoParamEvent:@selector(bh_applicationDidEnterBackground)];
}

- (void)trigger_applicationWillEnterForeground {
    [self handleModuleNoParamEvent:@selector(bh_applicationWillEnterForeground)];
}

- (void)trigger_applicationDidBecomeActive {
    [self handleModuleNoParamEvent:@selector(bh_applicationDidBecomeActive)];
}

- (void)trigger_applicationWillTerminate {
    [self handleModuleNoParamEvent:@selector(bh_applicationWillTerminate)];
}

- (void)trigger_applicationPerformActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem completionHandler:(void (^)(BOOL))completionHandler{
    [self.moduleList enumerateObjectsUsingBlock:^(NSString  *_Nonnull objStr, NSUInteger idx, BOOL * _Nonnull stop) {
        Class obj = NSClassFromString(objStr);
        if ([obj respondsToSelector:@selector(bh_applicationPerformActionForShortcutItem:completionHandler:)]) {
            [obj bh_applicationPerformActionForShortcutItem:shortcutItem completionHandler:completionHandler];
        }
    }];
}

- (BOOL)trigger_applicationOpenURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    __block BOOL flag = NO;
    [self.moduleList enumerateObjectsUsingBlock:^(NSString  *_Nonnull objStr, NSUInteger idx, BOOL * _Nonnull stop) {
        Class obj = NSClassFromString(objStr);
        if ([obj respondsToSelector:@selector(bh_applicationOpenURL:sourceApplication:annotation:)]) {
            BOOL isTrue = [obj bh_applicationOpenURL:url sourceApplication:sourceApplication annotation:annotation];
            if(isTrue) {
                flag = YES;
            }
        }
    }];
    return flag;
}

- (BOOL)trigger_applicationOpenURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options {
    __block BOOL flag = NO;
    [self.moduleList enumerateObjectsUsingBlock:^(NSString  *_Nonnull objStr, NSUInteger idx, BOOL * _Nonnull stop) {
        Class obj = NSClassFromString(objStr);
        if ([obj respondsToSelector:@selector(bh_applicationOpenURL:options:)]) {
            BOOL isTrue  = [obj bh_applicationOpenURL:url options:options];
            if(isTrue) {
                flag = YES;
            }
        }
    }];
    return flag;
}

- (void)trigger_applicationDidReceiveRemoteNotification:(NSDictionary *)userInfo {
    [self.moduleList enumerateObjectsUsingBlock:^(NSString  *_Nonnull objStr, NSUInteger idx, BOOL * _Nonnull stop) {
        Class obj = NSClassFromString(objStr);
        if ([obj respondsToSelector:@selector(bh_applicationDidReceiveRemoteNotification:)]) {
            [obj bh_applicationDidReceiveRemoteNotification:userInfo];
        }
    }];
}

- (void)trigger_applicationDidReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    [self.moduleList enumerateObjectsUsingBlock:^(NSString  *_Nonnull objStr, NSUInteger idx, BOOL * _Nonnull stop) {
        Class obj = NSClassFromString(objStr);
        if ([obj respondsToSelector:@selector(bh_applicationDidReceiveRemoteNotification:fetchCompletionHandler:)]) {
            [obj bh_applicationDidReceiveRemoteNotification:userInfo fetchCompletionHandler:completionHandler];
        }
    }];
}

- (void)trigger_applicationDidReceiveLocalNotification:(UILocalNotification *)notification {
    [self.moduleList enumerateObjectsUsingBlock:^(NSString  *_Nonnull objStr, NSUInteger idx, BOOL * _Nonnull stop) {
        Class obj = NSClassFromString(objStr);
        if ([obj respondsToSelector:@selector(bh_applicationDidReceiveLocalNotification:)]) {
            [obj bh_applicationDidReceiveLocalNotification:notification];
        }
    }];
}

/**
 iOS10+ PresentNotification
 
 */
- (void)trigger_userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler {
    [self.moduleList enumerateObjectsUsingBlock:^(NSString  *_Nonnull objStr, NSUInteger idx, BOOL * _Nonnull stop) {
        Class obj = NSClassFromString(objStr);
        if ([obj respondsToSelector:@selector(bh_userNotificationCenter:willPresentNotification:withCompletionHandler:)]) {
            [obj bh_userNotificationCenter:center willPresentNotification:notification withCompletionHandler:completionHandler];
        }
    }];
}

- (void)trigger_userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void(^)())completionHandler {
    [self.moduleList enumerateObjectsUsingBlock:^(NSString  *_Nonnull objStr, NSUInteger idx, BOOL * _Nonnull stop) {
        Class obj = NSClassFromString(objStr);
        if ([obj respondsToSelector:@selector(bh_userNotificationCenter:didReceiveNotificationResponse:withCompletionHandler:)]) {
            [obj bh_userNotificationCenter:center didReceiveNotificationResponse:response withCompletionHandler:completionHandler];
        }
    }];
}

- (void)trigger_applicationDidUpdateUserActivity:(NSUserActivity *)userActivity {
    [self.moduleList enumerateObjectsUsingBlock:^(NSString  *_Nonnull objStr, NSUInteger idx, BOOL * _Nonnull stop) {
        Class obj = NSClassFromString(objStr);
        if ([obj respondsToSelector:@selector(bh_applicationDidUpdateUserActivity:)]) {
            [obj bh_applicationDidUpdateUserActivity:userActivity];
        }
    }];
}

- (void)trigger_applicationDidFailToContinueUserActivityWithType:(NSString *)userActivityType error:(NSError *)error {
    [self.moduleList enumerateObjectsUsingBlock:^(NSString  *_Nonnull objStr, NSUInteger idx, BOOL * _Nonnull stop) {
        Class obj = NSClassFromString(objStr);
        if ([obj respondsToSelector:@selector(bh_applicationDidFailToContinueUserActivityWithType:error:)]) {
            [obj bh_applicationDidFailToContinueUserActivityWithType:userActivityType error:error];
        }
    }];
}

- (BOOL)trigger_applicationContinueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void (^)(NSArray * ))restorationHandler {
    __block BOOL flag = NO;
    [self.moduleList enumerateObjectsUsingBlock:^(NSString  *_Nonnull objStr, NSUInteger idx, BOOL * _Nonnull stop) {
        Class obj = NSClassFromString(objStr);
        if ([obj respondsToSelector:@selector(bh_applicationContinueUserActivity:restorationHandler:)]) {
            BOOL isTrue = [obj bh_applicationContinueUserActivity:userActivity restorationHandler:restorationHandler];
            if(isTrue) {
                flag = YES;
            }
        }
    }];
    return flag;
}

- (BOOL)trigger_applicationWillContinueUserActivityWithType:(NSString *)userActivityType {
    __block BOOL flag = NO;
    [self.moduleList enumerateObjectsUsingBlock:^(NSString  *_Nonnull objStr, NSUInteger idx, BOOL * _Nonnull stop) {
        Class obj = NSClassFromString(objStr);
        if ([obj respondsToSelector:@selector(bh_applicationWillContinueUserActivityWithType:)]) {
            BOOL isTrue = [obj bh_applicationWillContinueUserActivityWithType:userActivityType];
            if(isTrue) {
                flag = YES;
            }
        }
    }];
    return flag;
}

- (void)trigger_applicationDidReceiveMemoryWarning {
    [self handleModuleNoParamEvent:@selector(bh_applicationDidReceiveMemoryWarning)];
}


#pragma mark-
#pragma mark- Private Methods

- (void)handleModuleNoParamEvent:(SEL)selector{
    [self.moduleList enumerateObjectsUsingBlock:^(NSString *moduleClassString, NSUInteger idx, BOOL * _Nonnull stop) {
        Class moduleClass = NSClassFromString(moduleClassString);
        if ([moduleClass respondsToSelector:selector]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            [moduleClass performSelector:selector];
#pragma clang diagnostic pop
        }
    }];
}

#pragma mark-
#pragma mark-   setters and getters
- (NSMutableArray *)moduleList {
    if (!_moduleList) {
        _moduleList = [NSMutableArray array];
    }
    return _moduleList;
}

@end

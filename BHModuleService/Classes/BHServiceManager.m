//
//  BHServiceManager.m
//  BHModuleService
//
//  Created by WZG on 16/3/23.
//  Copyright © 2016年 浙江网仓科技有限公司. All rights reserved.
//

#import "BHServiceManager.h"
#import <objc/runtime.h>
#import "BHServiceProtocol.h"

@interface BHServiceManager ()

@property (nonatomic, strong) NSMutableDictionary *protocolServiceRecordDict;
@property (nonatomic, strong) NSMutableDictionary *protocolNavDict;
@property (nonatomic, strong) NSMutableDictionary *urlServiceRecordDict;

@property (nonatomic, strong) NSRecursiveLock *lock;

@property (nonatomic, assign) BOOL enbaleDebugLog;

@end

@implementation BHServiceManager

+ (instancetype _Nonnull )sharedInstance {
    static BHServiceManager *router = nil;
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        router = [BHServiceManager new];
    });
    return router;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _enbaleDebugLog = NO;
    }
    return self;
}

+ (void)registerLocalServices {
    
    NSString *plistSubPath = @"BHModuleService.bundle/BHService";
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:plistSubPath ofType:@"plist"];
    if (!plistPath) {
        return;
    }
    
    NSDictionary *serviceDic = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
    [self registerServicesWithServiceDictionary:serviceDic];
}

+ (void)registerServicesWithServiceDictionary:(NSDictionary <NSString *, NSString *>*)serviceDictionary {
    
//    for (NSDictionary *dict in serviceList) {
//        NSString *protocolStr = [dict objectForKey:@"protocol"];
//        NSString *serviceStr = [dict objectForKey:@"service"];
//        NSString *navClass = [dict objectForKey:@"navService"];
//        if (protocolStr.length > 0 && serviceStr.length > 0) {
//            Protocol *protocol = NSProtocolFromString(protocolStr);
//            Class service = NSClassFromString(serviceStr);
//            Class navService = NSClassFromString(navClass);
//#if DEBUG
//
//            NSAssert(service != nil, @"service '%@' should not be nil", serviceStr);
//            NSAssert(protocol != nil, @"protocol '%@' should not be nil", protocolStr);
//#else
//            if (!service || !protocol) continue;
//#endif
//            [self registerServiceWithProtocol:protocol service:service navClass:navService];
//        }
//    }
    if (serviceDictionary.count) {
        BHServiceManager *serviceManager = [BHServiceManager sharedInstance];
        [serviceManager.protocolServiceRecordDict addEntriesFromDictionary:serviceDictionary];
    }
}

#pragma mark-
#pragma mark-   创建服务
//  协议创建服务
+ (id)createServiceWithProtocol:(Protocol *)protocol {
    
    if (![self isModuleHasBeenRegistedWithProtocol:protocol]) {
//        @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:[NSString stringWithFormat:@"protocol '%@' does not regist", NSStringFromProtocol(protocol)] userInfo:nil];
        if ([BHServiceManager sharedInstance].enbaleDebugLog) NSLog(@"protocol '%@' does not regist", NSStringFromProtocol(protocol));
        return nil;
    }
    
    Class service = [self serviceWithProtocol:protocol];
    if ([service respondsToSelector:@selector(isSingleton)]) {
        if ([service isSingleton]) {
            if ([service respondsToSelector:@selector(sharedInstance)]) {
                return [service sharedInstance];
            }else{
                return [service new];
            }
        }
    }
    return [service new];
}

+ (void)createServiceWithProtocol:(Protocol *_Nonnull)protocol completion:(BHNavServiceBlock)completion {
    
    if (![self isModuleHasBeenRegistedWithProtocol:protocol]) {
        
        if ([BHServiceManager sharedInstance].enbaleDebugLog) NSLog(@"protocol '%@' does not regist", NSStringFromProtocol(protocol));
        if (completion) completion(nil, nil);
        return;
    }
    
    Class service = [self serviceWithProtocol:protocol];
    Class navClass = [self navServiceWithProtocol:protocol];
    if ([service isSubclassOfClass:[UIViewController class]]) {
        if (navClass) {
            if ([navClass isSubclassOfClass:[UINavigationController class]]) {
                UIViewController *vc = [service new];
                UINavigationController *nav = [[navClass alloc] initWithRootViewController:vc];
                if (completion) completion(vc, nav);
                return;
            }
        }else if ([service respondsToSelector:@selector(isSingleton)]) {
            if ([service isSingleton]) {
                if ([service respondsToSelector:@selector(sharedInstance)]) {
                    if (completion) completion([service sharedInstance], nil);
                    return;
                }else{
                    if (completion) completion([service new], nil);
                    return;
                }
            }
        }
        if (completion) completion([service new], nil);
        return;
    }
    if (completion) completion(nil, nil);
}

//  url创建服务
+ (void)createServiceWithOpenUrl:(NSURL *_Nullable)openUrl compeletion:(BHServiceCreatedBlock _Nullable )compeletion {
    
    NSString *urlString = openUrl.host;
    if (![self isModuleHasBeenRegistedWithUrlString:urlString]) {
//        @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:[NSString stringWithFormat:@"urlString '%@' does not regist", urlString] userInfo:nil];
        if ([BHServiceManager sharedInstance].enbaleDebugLog) NSLog(@"urlString '%@' does not regist", urlString);
        return;
    }

    NSMutableDictionary *paramsDic = [[NSMutableDictionary alloc] init];
    NSString *queryString = [openUrl query];
    for (NSString *param in [queryString componentsSeparatedByString:@"&"]) {
        NSArray *elements = [param componentsSeparatedByString:@"="];
        if([elements count] < 2) continue;
        [paramsDic setObject:[elements lastObject] forKey:[elements firstObject]];
    }
    
    Class service = [self serviceWithUrlString:urlString];
    if ([service respondsToSelector:@selector(isSingleton)]) {
        if ([service isSingleton]) {
            if ([service respondsToSelector:@selector(sharedInstance)]) {
                compeletion([service sharedInstance], paramsDic);
                return;
            }
        }
    }
    
    compeletion([service new], paramsDic);
}

#pragma mark-
#pragma mark-   注册服务
//  协议注册服务
+ (void)registerServiceWithProtocol:(Protocol *)protocol service:(Class)service {
    [[BHServiceManager sharedInstance] registerServiceWithProtocol:protocol service:service navClass:nil];
}

- (void)registerServiceWithProtocol:(Protocol *)protocol service:(Class)service {
    
    [self registerServiceWithProtocol:protocol service:service navClass:nil];
}

+ (void)registerServiceWithProtocol:(Protocol *_Nonnull)protocol
                            service:(Class _Nonnull)service
                           navClass:(Class _Nullable)navClass {
    [[BHServiceManager sharedInstance] registerServiceWithProtocol:protocol service:service navClass:navClass];
}

- (void)registerServiceWithProtocol:(Protocol *_Nonnull)protocol
                            service:(Class _Nonnull)service
                           navClass:(Class _Nullable)navClass {
#if DEBUG
    
    NSAssert(service != nil, @"service should not be nil");
    NSAssert(protocol != nil, @"protocol should not be nil");
#else
    if (!service || !protocol) return;
#endif

    
    if (![service conformsToProtocol:protocol]) {
        
        if ([BHServiceManager sharedInstance].enbaleDebugLog) NSLog(@" '%@' module does not conforms to '%@' protocol", NSStringFromClass(service), NSStringFromProtocol(protocol));
        return;
    }
    
    if ([BHServiceManager isModuleHasBeenRegistedWithProtocol:protocol]) {
        
        if ([BHServiceManager sharedInstance].enbaleDebugLog) NSLog(@"protocol '%@' has been registed", NSStringFromProtocol(protocol));
        return;
    }
    
    void(^registServiceBlock)(void);
    registServiceBlock = ^{
        NSString *key = NSStringFromProtocol(protocol);
        NSString *value = NSStringFromClass(service);
        NSString *navValue = nil;
        if (navClass) navValue = NSStringFromClass(navClass);
        
        if (key.length > 0 && value.length > 0) {
            [self.lock lock];
            if (navValue.length) [self.protocolNavDict addEntriesFromDictionary:@{key : navValue}];
            [self.protocolServiceRecordDict addEntriesFromDictionary:@{key : value}];
            [self.lock unlock];
        }
    };
    
    if ([service respondsToSelector:@selector(async)]) {
        BOOL async = [service async];
        if (async) {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                registServiceBlock();
            });
        }else{
            registServiceBlock();
        }
    }else{
        dispatch_async(dispatch_get_main_queue(), ^{
            
            registServiceBlock();
        });
    }
}

//  url注册服务
+ (void)registerServiceWithUrlString:(NSString *)urlString service:(Class)service {
    [[BHServiceManager sharedInstance] registerServiceWithUrlString:urlString service:service params:nil];
}

- (void)registerServiceWithUrlString:(NSString *)urlString service:(Class)service {
    
    [self registerServiceWithUrlString:urlString service:service params:nil];
}

- (void)registerServiceWithUrlString:(NSString *)urlString service:(Class)service params:(id)params {
    
    
    NSAssert(service != nil, @"service should not be nil");
    NSAssert(urlString != nil, @"urlString should not be nil");
    
    if ([BHServiceManager isModuleHasBeenRegistedWithUrlString:urlString]) {
        //        @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:[NSString stringWithFormat:@"urlString '%@' has been registed", urlString] userInfo:nil];
        if ([BHServiceManager sharedInstance].enbaleDebugLog) NSLog(@"urlString '%@' has been registed", urlString);
        return;
    }
    
    void(^registServiceBlock)(void);
    registServiceBlock = ^{
        NSString *key = urlString;
        NSString *value = NSStringFromClass(service);
        
        if (key.length > 0 && value.length > 0) {
            [self.lock lock];
            [self.urlServiceRecordDict setObject:value forKey:key];
            [self.lock unlock];
        }
    };
    if ([service respondsToSelector:@selector(async)]) {
        BOOL async = [service async];
        if (async) {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                registServiceBlock();
            });
        }else{
            registServiceBlock();
        }
    }else{
        dispatch_async(dispatch_get_main_queue(), ^{
            
            registServiceBlock();
        });
    }
}

+ (void)enableDebugLog {
    [[BHServiceManager sharedInstance] setEnbaleDebugLog:YES];
}

#pragma mark-
#pragma mark-   private method
+ (Class)serviceWithProtocol:(Protocol *)protocol {
    NSString *serviceStr = [[BHServiceManager sharedInstance].protocolServiceRecordDict objectForKey:NSStringFromProtocol(protocol)];
    if ([BHServiceManager sharedInstance].enbaleDebugLog) {
        if (!NSClassFromString(serviceStr)) {
            NSLog(@"Class '%@' does not exist for protocol '%@'", serviceStr, NSStringFromProtocol(protocol));
        }
    }

//#if DEBUG
//        NSAssert(serviceStr.length != 0, @"service '%@' has not been registed", serviceStr);
//        NSAssert(NSClassFromString(serviceStr) != nil, @"Class '%@' does not exist for protocol '%@'", serviceStr, NSStringFromProtocol(protocol));
//#else
//#endif
    if (serviceStr.length > 0) return NSClassFromString(serviceStr);
    return nil;
}

+ (Class)navServiceWithProtocol:(Protocol *)protocol {
    NSString *navStr = [[BHServiceManager sharedInstance].protocolNavDict objectForKey:NSStringFromProtocol(protocol)];
    if (navStr.length > 0) return NSClassFromString(navStr);
    return nil;
    
}

+ (Class)serviceWithUrlString:(NSString *)urlString {
    NSString *serviceStr = [[BHServiceManager sharedInstance].urlServiceRecordDict objectForKey:urlString];
    if (serviceStr.length > 0) return NSClassFromString(serviceStr);
    return nil;
}

+ (BOOL)isModuleHasBeenRegistedWithProtocol:(Protocol *)protocol {
    
    NSString *serviceStr = [[BHServiceManager sharedInstance].protocolServiceRecordDict objectForKey:NSStringFromProtocol(protocol)];
    if (serviceStr.length > 0) return YES;
    return NO;
}

+ (BOOL)isModuleHasBeenRegistedWithUrlString:(NSString *)urlString {
    
    NSString *serviceStr = [[BHServiceManager sharedInstance].urlServiceRecordDict objectForKey:urlString];
    if (serviceStr.length > 0) return YES;
    return NO;
}

#pragma mark-
#pragma mark-   setter and getter
- (NSMutableDictionary *)protocolServiceRecordDict {
    if (!_protocolServiceRecordDict) {
        _protocolServiceRecordDict = [NSMutableDictionary dictionary];
    }
    return _protocolServiceRecordDict;
}

- (NSMutableDictionary *)protocolNavDict {
    if (!_protocolNavDict) {
        _protocolNavDict = [NSMutableDictionary dictionary];
    }
    return _protocolNavDict;
}

- (NSMutableDictionary *)urlServiceRecordDict {
    if (!_urlServiceRecordDict) {
        _urlServiceRecordDict = [NSMutableDictionary dictionary];
    }
    return _urlServiceRecordDict;
}

- (NSRecursiveLock *)lock
{
    if (!_lock) {
        _lock = [[NSRecursiveLock alloc] init];
    }
    return _lock;
}

@end

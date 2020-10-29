#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <objc/runtime.h>
#import <IOKit/IOKitLib.h>

#import <SpringBoard/SpringBoard.h>
#import <SpringBoard/SBApplication.h>
#import <SpringBoard/SBApplicationController.h>

#ifdef DEBUG
#define NSLog(...) NSLog(__VA_ARGS__)
#else 
#define NSLog(...) (void)0
#endif

@interface GrapherLogger : NSObject
- (void)startObserving;
- (void)getAndSave;
-(float)getTemperature;
-(int)getAmperage;
@end

@interface NSUserDefaults (Grapher)
-(id)objectForKey:(NSString *)key inDomain:(NSString *)domain;
-(void)setObject:(id)value forKey:(NSString *)key inDomain:(NSString *)domain;
@end
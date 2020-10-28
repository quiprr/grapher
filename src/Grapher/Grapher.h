#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <objc/runtime.h>
#import <IOKit/IOKitLib.h>

#ifdef DEBUG
#define NSLog(...) NSLog(__VA_ARGS__)
#else 
#define NSLog(...) (void)0
#endif

@interface SpringBoard : UIApplication
- (void)startObserving;
- (void)getAndSave;
-(float)getTemperature;
-(int)getAmperage;
@property int value;
@end
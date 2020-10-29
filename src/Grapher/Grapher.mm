//
// Grapher.mm
// Grapher
//
// Created October 2020
// Author: quiprr
//

#import "Grapher.h"

// static method to read preference value
id readPreferenceValue(id key, id fallback)
{
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:@"/var/mobile/Library/Preferences/com.charliewhile.grapher.plist"];
    id value = [dict valueForKey:key] ? [dict valueForKey:key] : fallback; // This allows for a fallback value if the plist doesn't exist/doesn't have the value it's looking for
    NSLog(@"Grapher: readPreferenceValue: key: %@ value: %@", key, value);
    return value;
}

@implementation GrapherLogger 

+(void)load
{
	[self sharedInstance];
}

+(instancetype)sharedInstance
{
	static dispatch_once_t onceToken = 0;
	__strong static GrapherLogger* sharedInstance = nil;
	dispatch_once(&onceToken, ^{
		sharedInstance = [[self alloc] init];
	});
	return sharedInstance;
}

-(instancetype)init
{
	if ((self = [super init]))
	{
        id enabled = readPreferenceValue(@"enableTweak", @"NO");
        if (enabled)
        {
            NSLog(@"Grapher: is enabled");
            [self startObserving];
        }
	}
	return self;
}

- (void)startObserving
{
    NSLog(@"Grapher: startObserving");
    [NSTimer scheduledTimerWithTimeInterval:15.0 target:self selector:@selector(getAndSave) userInfo:nil repeats:YES];
}

- (void)getAndSave
{

    float currentTemp = [self getTemperature];
    int currentAmperage = [self getAmperage];
    NSString *bundleID;

    SpringBoard *app = (SpringBoard *)[UIApplication sharedApplication];
	SBApplication *frontmostApp = app._accessibilityFrontMostApplication;
    if (frontmostApp.bundleIdentifier) {
        bundleID = frontmostApp.bundleIdentifier;
    } else {
        bundleID = @"com.apple.springboard";
    }

    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithContentsOfFile:@"/var/mobile/Library/Preferences/com.charliewhile.grapher.plist"];
    NSMutableDictionary *log = dict[@"log"] ?: [NSMutableDictionary new];
    NSMutableArray *appLog = log[bundleID] ?: [NSMutableArray new];

    NSMutableDictionary *logItem = [NSMutableDictionary new];
    logItem[@"temperature"] = @(currentTemp);
    logItem[@"amperage"] = @(currentAmperage);
    [appLog addObject: logItem];

    [log setObject:appLog forKey:bundleID];
    [dict setObject:log forKey:@"log"];
    [dict writeToFile:@"/var/mobile/Library/Preferences/com.charliewhile.grapher.plist" atomically:YES];
    NSLog(@"Grapher: getAndSave: currentTemp: %f, currentAmperage: %d", currentTemp, currentAmperage);

}

-(float)getTemperature
{
    io_service_t powerSource = IOServiceGetMatchingService(kIOMasterPortDefault, IOServiceMatching("IOPMPowerSource"));
    float temperature = -1;
    
    CFNumberRef temperatureNum = (CFNumberRef)IORegistryEntryCreateCFProperty(powerSource, CFSTR("Temperature"), kCFAllocatorDefault, 0);
    CFNumberGetValue(temperatureNum, kCFNumberFloatType, &temperature);
    CFRelease(temperatureNum);
    
    return temperature/100.0f;
}

-(int)getAmperage
{
    io_service_t powerSource = IOServiceGetMatchingService(kIOMasterPortDefault, IOServiceMatching("IOPMPowerSource"));
    int amperage = -1;
    
    CFNumberRef amperageNum = (CFNumberRef)IORegistryEntryCreateCFProperty(powerSource, CFSTR("InstantAmperage"), kCFAllocatorDefault, 0);
    CFNumberGetValue(amperageNum, kCFNumberIntType, &amperage);
    CFRelease(amperageNum);
    
    return amperage;
}

@end


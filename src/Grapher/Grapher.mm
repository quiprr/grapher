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

%group SpringBoard

%hook SpringBoard

%property int value;

- (void)applicationDidFinishLaunching:(id)args
{
    %orig;
    NSLog(@"Grapher: SpringBoard didFinishLaunching and we are go");
    id enabled = readPreferenceValue(@"enableTweak", @"NO");
    if (enabled)
    {
        NSLog(@"Grapher: is enabled");
        self.value = 0;
        [self startObserving];
    }
}

%new

- (void)startObserving
{
    NSLog(@"Grapher: startObserving");
    [NSTimer scheduledTimerWithTimeInterval:15.0 target:self selector:@selector(getAndSave) userInfo:nil repeats:YES];
}

%new

- (void)getAndSave
{
    self.value = self.value + 1;
    float currentTemp = [self getTemperature];
    int currentAmperage = [self getAmperage];

    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithContentsOfFile:@"/var/mobile/Library/Preferences/com.charliewhile.grapher.plist"];
    NSString *key1 = [NSString stringWithFormat:@"temperatureValue%d", self.value];
    NSString *key2 = [NSString stringWithFormat:@"amperageValue%d", self.value];
    [dict setObject:@(currentTemp) forKey:key1];
    [dict setObject:@(currentAmperage) forKey:key2];
    [dict writeToFile:@"/var/mobile/Library/Preferences/com.charliewhile.grapher.plist" atomically:YES];
    NSLog(@"Grapher: getAndSave: currentTemp: %f, currentAmperage: %d", currentTemp, currentAmperage);

}

%new

-(float)getTemperature
{
    io_service_t powerSource = IOServiceGetMatchingService(kIOMasterPortDefault, IOServiceMatching("IOPMPowerSource"));
    float temperature = -1;
    
    CFNumberRef temperatureNum = (CFNumberRef)IORegistryEntryCreateCFProperty(powerSource, CFSTR("Temperature"), kCFAllocatorDefault, 0);
    CFNumberGetValue(temperatureNum, kCFNumberFloatType, &temperature);
    CFRelease(temperatureNum);
    
    return temperature/100.0f;
}

%new

-(int)getAmperage
{
    io_service_t powerSource = IOServiceGetMatchingService(kIOMasterPortDefault, IOServiceMatching("IOPMPowerSource"));
    int amperage = -1;
    
    CFNumberRef amperageNum = (CFNumberRef)IORegistryEntryCreateCFProperty(powerSource, CFSTR("InstantAmperage"), kCFAllocatorDefault, 0);
    CFNumberGetValue(amperageNum, kCFNumberIntType, &amperage);
    CFRelease(amperageNum);
    
    return amperage;
}

%end

%end

%ctor
{
    NSLog(@"Grapher: constructor");
    if([NSBundle.mainBundle.bundleIdentifier isEqualToString:@"com.apple.springboard"])
    {
        NSLog(@"Grapher: Injected into SpringBoard, initializing SpringBoard hooks...");
        %init(SpringBoard)
        NSLog(@"Grapher: Done initializing SpringBoard hooks!");
    }
}
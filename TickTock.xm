#import <Foundation/Foundation.h>
#import <CoreFoundation/CoreFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import <UIKit/UIKit.h>

@interface UIKeyboardLayout : UIView
-(UIKBKey*)keyHitTest:(CGPoint)point;
@end

@interface UIKeyboardLayoutStar : UIKeyboardLayout
// iOS 7
-(id)keyHitTest:(CGPoint)arg1;
-(id)keyHitTestWithoutCharging:(CGPoint)arg1;
-(id)keyHitTestClosestToPoint:(CGPoint)arg1;
-(id)keyHitTestContainingPoint:(CGPoint)arg1;
@end

@interface UIKBKey : NSObject
@property(copy) NSString * representedString;
@end

%hook UIKeyboardLayoutStar
- (void)playKeyClickSound { }
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	UITouch *touch = [touches anyObject];

	UIKBKey *keyObject = [self keyHitTest:[touch locationInView:touch.view]];
	NSString *key = [[keyObject representedString] lowercaseString];
	NSURL* file;
	//NSLog(@"key=[%@]", key);

	if ([key isEqualToString:@"delete"]) {
		file = [[NSURL alloc] initWithString:@"/System/Library/Audio/UISounds/TickTock/key_press_delete.caf"];
	}
	else if ([key isEqualToString:@"more"] || [key isEqualToString:@"\n"] || [key isEqualToString:@" "] || [key isEqualToString:@"shift"] || [key isEqualToString:@"international"]) {
		file = [[NSURL alloc] initWithString:@"/System/Library/Audio/UISounds/TickTock/key_press_modifier.caf"];
	}
	else {
		file = [[NSURL alloc] initWithString:@"/System/Library/Audio/UISounds/TickTock/key_press_click.caf"];
	}

	SystemSoundID soundID;
	AudioServicesCreateSystemSoundID((CFURLRef)file, &soundID);
	AudioServicesPlaySystemSound(soundID);

	%orig;
}

%end

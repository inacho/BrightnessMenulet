#import <Cocoa/Cocoa.h>

@interface AppController : NSResponder <NSMenuDelegate> {
    IBOutlet NSMenu *statusMenu;

    IBOutlet NSTextField *valueMenu;
    IBOutlet NSMenuItem *quitMenu;
    IBOutlet NSSlider *mySlider;

    NSStatusItem *statusItem;
}


- (IBAction) sliderUpdate:(id)sender;
- (void) setBrightness:(int)newBrightness;
- (int) getBrightness;

@end

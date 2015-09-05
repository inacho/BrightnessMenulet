#import "ddc.h"
#import "AppController.h"
#include <IOKit/graphics/IOGraphicsLib.h>


@implementation AppController
const int kMaxDisplays = 16;
const CFStringRef kDisplayBrightness = CFSTR(kIODisplayBrightnessKey);

- (void) awakeFromNib
{
    int initialBrightness;

    // Create the NSStatusBar and set its length
    statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSSquareStatusItemLength];

    NSImage *image = [NSImage imageNamed:@"icon"];
    [image setTemplate:YES];

    // Sets the images in our NSStatusItem
    [statusItem setImage:image];

    // Tells the NSStatusItem what menu to load
    [statusItem setMenu:statusMenu];

    [statusMenu setDelegate:self];

    // Sets the tooptip for our item
    [statusItem setToolTip:@"Brightness Menulet"];

    initialBrightness = [self getBrightness];

    // [mySlider setIntValue:[self get_brightness]];
    [self setBrightness:initialBrightness];
    [mySlider setIntValue:initialBrightness];

    // Enables highlighting
    [statusItem setHighlightMode:YES];

    [mySlider setFocusRingType:NSFocusRingTypeNone];

    [mySlider becomeFirstResponder];
}

- (void) menuWillOpen:(NSMenu *)menu
{
    NSLog(@"click = %lu",(unsigned long)[NSEvent pressedMouseButtons]);

    if ([NSEvent pressedMouseButtons] == 1) { // left click
        [quitMenu setHidden:YES];
    } else {
        [quitMenu setHidden:NO];
    }
}

- (int) getBrightness
{
    int value = [[NSUserDefaults standardUserDefaults] integerForKey:@"brightness"];
    NSLog(@"brillo = %d", value);
    return value == 0 ? 90 : value;
}

- (void) setBrightness:(int) newBrightness
{
    struct DDCWriteCommand write_command;
    write_command.control_id = 0x10;
    write_command.new_value = newBrightness;
    ddc_write(0, &write_command);

    [valueMenu setStringValue:[NSString stringWithFormat:@"%i", newBrightness]];

    [[NSUserDefaults standardUserDefaults] setInteger:newBrightness forKey:@"brightness"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (IBAction) sliderUpdate:(id)sender
{
    int value = [sender intValue];
    NSLog(@"Got brightness %d", value);
    [self setBrightness:value];
}

- (IBAction) exit:(id)sender
{
    exit(1);
}

@end

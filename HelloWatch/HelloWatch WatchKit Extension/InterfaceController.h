//
//  InterfaceController.h
//  HelloWatch WatchKit Extension
//
//

#import <WatchKit/WatchKit.h>
#import <Foundation/Foundation.h>
@import WatchConnectivity;

@interface InterfaceController : WKInterfaceController<WCSessionDelegate>

@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceLabel *ipAddress;
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceImage *image;

@end

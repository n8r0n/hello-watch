//
//  ViewController.h
//  HelloWatch
//
//

#import <UIKit/UIKit.h>
@import WatchConnectivity;

@interface ViewController : UIViewController<WCSessionDelegate>

@property (weak, nonatomic) IBOutlet UILabel *ipAddress;
@property (weak, nonatomic) IBOutlet UIImageView *webcam;

- (IBAction)pushImageTapped:(id)sender;

@end


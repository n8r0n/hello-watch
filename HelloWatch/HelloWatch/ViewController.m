//
//  ViewController.m
//  HelloWatch
//
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
   [super viewDidLoad];
   // Do any additional setup after loading the view, typically from a nib.
   dispatch_async(dispatch_get_main_queue(), ^() {
      [self updateIpAddress];
   });
   
   if ([WCSession isSupported]) {
      WCSession *session = [WCSession defaultSession];
      session.delegate = self;
      [session activateSession];
   }
}

#pragma mark - Business Logic

- (void)updateIpAddress {
   NSError *error;
   NSURL *URL = [NSURL URLWithString: @"http://checkip.dyndns.com"];
   NSString *content = [NSString stringWithContentsOfURL: URL encoding: NSUTF8StringEncoding error: &error];
   NSString *startTag = @"Address:";
   NSRange start = [content rangeOfString: startTag];
   if (start.location != NSNotFound) {
      NSRange end = [content rangeOfString: @"</body>"];
      if (end.location > start.location) {
         NSRange range = NSMakeRange(start.location + startTag.length, end.location - start.location - startTag.length);
         NSString *address = [content substringWithRange: range];
         [self updateWatchIp: address];
         self.ipAddress.text = [address stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
      }
   }
}

- (void)updateWatchIp: (NSString*)address {
   if ([WCSession isSupported]) {
      WCSession *session = [WCSession defaultSession];
      if (session.reachable) {
         NSError *error;
         NSDictionary *context = @{ @"ip_address" : address };
         [session updateApplicationContext: context error: &error];
         if (error) {
            NSLog(@"error updating watch: %@", [error localizedDescription]);
         }
      }
   }
}

- (void)updateImage {
   WCSession *session = [WCSession defaultSession];
   NSURL *imageURL = [NSURL URLWithString:@"http://images.wsdot.wa.gov/nw/090vc00508.jpg"];
   
   dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
      NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
      
      dispatch_async(dispatch_get_main_queue(), ^{
         UIImage *img = [UIImage imageWithData:imageData];
         self.webcam.image = img;
         UIImage *scaledImg = [self scaleImage:img scaledToSize:CGSizeMake(150.0f, 200.0f)];
         NSData *data = UIImagePNGRepresentation(scaledImg);
         NSURL *file = [session.watchDirectoryURL URLByAppendingPathComponent: @"image.png"];
         BOOL success = [data writeToFile: file.path atomically:NO];
         if (success) {
            [session transferFile: file metadata: nil];
         } else {
            NSLog(@"unable to write image file for xferring: %@", file.path);
         }
      });
   });
}

#pragma mark - WCSessionDelegate

- (void) session:(WCSession *)session didReceiveMessage:(NSDictionary<NSString *,id> *)message {
   NSString *method = message[@"method"];
   if ([method isEqualToString: @"update_address"]) {
      // run this on the main thread, as if initiated by app UI
      dispatch_async(dispatch_get_main_queue(), ^() {
         [self updateIpAddress];
      });
   } else if ([method isEqualToString: @"update_image"]) {
      [self updateImage];
   }
}

- (void) session:(WCSession *)session didReceiveMessage:(NSDictionary<NSString *,id> *)message replyHandler:(void (^)(NSDictionary<NSString *,id> * _Nonnull))replyHandler {
   [self session:session didReceiveMessage: message];
   replyHandler(@{ @"status" : @"ok" });
}

#pragma mark - Actions

- (IBAction)pushImageTapped:(id)sender {
   [self updateImage];
}

#pragma mark - Image Processing

- (UIImage*)scaleImage:(UIImage*)image scaledToSize:(CGSize)newSize {
   //UIGraphicsBeginImageContext(newSize);
   // In next line, pass 0.0 to use the current device's pixel scaling factor (and thus account for Retina resolution).
   // Pass 1.0 to force exact pixel size.
   UIGraphicsBeginImageContextWithOptions(newSize, YES, 1.0);
   [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
   UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
   UIGraphicsEndImageContext();
   return newImage;
}

#pragma mark -

- (void)didReceiveMemoryWarning {
   [super didReceiveMemoryWarning];
   // Dispose of any resources that can be recreated.
}

@end

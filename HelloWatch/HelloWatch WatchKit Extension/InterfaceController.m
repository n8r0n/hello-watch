//
//  InterfaceController.m
//  HelloWatch WatchKit Extension
//
//

#import "InterfaceController.h"

@interface InterfaceController()

@end


@implementation InterfaceController

- (void)awakeWithContext:(id)context {
   [super awakeWithContext:context];
   
   // Configure interface objects here.
   WCSession *session = [WCSession defaultSession];
   session.delegate = self;
   [session activateSession];
}

- (void)willActivate {
   // This method is called when watch view controller is about to be visible to user
   [super willActivate];
   [self updateIp];
   [self updateImage];
}

- (void)didDeactivate {
   // This method is called when watch view controller is no longer visible
   [super didDeactivate];
}

- (void)updateIp {
   WCSession *session = [WCSession defaultSession];
   if (session.reachable) {
      [session sendMessage: @{ @"method" : @"update_address" }
              replyHandler: ^(NSDictionary<NSString*,id>* reply) {
                 NSLog(@"updateIp received: %@", reply[@"status"]);
                 self.ipAddress.text = reply[@"status"];
              }
              errorHandler: ^(NSError* error) {
                 if (error) {
                    NSLog(@"updateIp error: %@", [error localizedDescription]);
                    self.ipAddress.text = [error localizedDescription];
                 }
              }];
   }
}

- (void)updateImage {
   WCSession *session = [WCSession defaultSession];
   if (session.reachable) {
      [session sendMessage: @{ @"method" : @"update_image" }
              replyHandler: ^(NSDictionary<NSString*,id>* reply) {
                 NSLog(@"updateImage received: %@", reply[@"status"]);
              }
              errorHandler: ^(NSError* error) {
                 if (error) {
                    NSLog(@"updateImage error: %@", [error localizedDescription]);
                    self.ipAddress.text = [error localizedDescription];
                 }
              }];
   }
}

#pragma mark - WCSessionDelegate

- (void)sessionReachabilityDidChange:(WCSession *)session {
   [self updateIp];
   [self updateImage];
}

- (void)session:(WCSession *)session didReceiveApplicationContext:(NSDictionary<NSString *,id> *)applicationContext {
   NSString *address = applicationContext[@"ip_address"];
   if (address) {
      // update the UI on the main thread
      dispatch_async(dispatch_get_main_queue(), ^() {
         self.ipAddress.text = address;
      });
   }
}

- (void)session:(WCSession *)session didFinishFileTransfer:(WCSessionFileTransfer *)fileTransfer error:(NSError *)error {
   if (error) {
      NSLog(@"error transferring image: %@", [error localizedDescription]);
   }
}

- (void)session:(WCSession *)session didReceiveFile:(WCSessionFile *)file {
   NSData *imgData = [[NSData alloc] initWithContentsOfURL: file.fileURL];
   NSLog(@"Rx'd %d bytes of image data", imgData.length);
   // update UI on the main thread:
   dispatch_async(dispatch_get_main_queue(), ^() {
      [self.image setImageData:imgData];
   });
}

@end




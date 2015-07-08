//
//  ViewController.h
//  ChatTest
//
//  Created by Cesar Guirao on 3/6/15.
//  Copyright (c) 2015 TokBox. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "OTKTextChatComponent.h"

@interface ViewController : UIViewController <OTKTextChatDelegate>

@property (strong) OTKTextChatComponent *textChat;
@property (weak) IBOutlet UILabel *connectingLabel;

@end


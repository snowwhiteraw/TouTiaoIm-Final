//
//  SceneDelegate.h
//  TouTiao_IMERVERSE
//
//  Created by 123 on 2021/6/16.
//

#import <UIKit/UIKit.h>
#import <FWSideMenu/FWSideMenu-Swift.h>
#import "LoginViewController.h"
#import "RegisterViewController.h"

@interface SceneDelegate : UIResponder <UIWindowSceneDelegate>

@property (strong, nonatomic) UIWindow * window;
@property (strong, nonatomic) FWSideMenuContainerViewController *sideMenuContainer;

@property (strong,nonatomic) LoginViewController * revc;
@end


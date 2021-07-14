//
//  SceneDelegate.m
//  TouTiao_IMERVERSE
//
//  Created by 123 on 2021/6/16.
//

#import "SceneDelegate.h"
#import "TabsbarViewController.h"
#import "NotificationViewController.h"
#import "CollectionViewController.h"
#import "SlideMenuView.h"
#import "TouTiao_IMERVERSE-Bridging-Header.h"
#import "TouTiao_IMERVERSE-Swift.h" //让OC类调用此项目中的swift类
#import <FWSideMenu/FWSideMenu-Swift.h>
#import "MasonryDemoViewController.h"
#import "TagViewController.h"

@interface SceneDelegate ()

@end

@implementation SceneDelegate


- (void)scene:(UIScene *)scene willConnectToSession:(UISceneSession *)session options:(UISceneConnectionOptions *)connectionOptions {
    
    
//    self.window.backgroundColor = UIColor.whiteColor;
//    self.window.rootViewController = [[MasonryDemoViewController alloc]init];
    

    TabsbarViewController * vc = [[TabsbarViewController alloc]init]; //标签页
    MenuViewController * leftviewcontroller = [[MenuViewController alloc]init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController: vc];
    UINavigationController *navleft = [[UINavigationController alloc] initWithRootViewController: leftviewcontroller];
    //FWSideMenuContainerViewController仅仅用于建立一个容器，可以左滑右滑出现新页面，预先定义好
    self.sideMenuContainer = [FWSideMenuContainerViewController containerWithCenterViewController:nav centerLeftPanViewWidth:20 centerRightPanViewWidth:0 leftMenuViewController:navleft rightMenuViewController:nil]; //注意这里TabsbarViewController的vc是被放入nav的
    self.sideMenuContainer.leftMenuWidth = UIScreen.mainScreen.bounds.size.width * 1; //侧滑后的页面宽度

    self.window.rootViewController = self.sideMenuContainer;


//    RegisterViewController * vc = [[RegisterViewController alloc]init];
//    self.window.rootViewController = vc;

//        self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]]; //这行不能加，加了黑屏
    
    

    // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
    // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
    // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
}


- (void)sceneDidDisconnect:(UIScene *)scene {
    
    
    
    // Called as the scene is being released by the system.
    // This occurs shortly after the scene enters the background, or when its session is discarded.
    // Release any resources associated with this scene that can be re-created the next time the scene connects.
    // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
}


- (void)sceneDidBecomeActive:(UIScene *)scene {
    // Called when the scene has moved from an inactive state to an active state.
    // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
}


- (void)sceneWillResignActive:(UIScene *)scene {
    // Called when the scene will move from an active state to an inactive state.
    // This may occur due to temporary interruptions (ex. an incoming phone call).
}


- (void)sceneWillEnterForeground:(UIScene *)scene {
    // Called as the scene transitions from the background to the foreground.
    // Use this method to undo the changes made on entering the background.
}


- (void)sceneDidEnterBackground:(UIScene *)scene {
    // Called as the scene transitions from the foreground to the background.
    // Use this method to save data, release shared resources, and store enough scene-specific state information
    // to restore the scene back to its current state.
}


@end

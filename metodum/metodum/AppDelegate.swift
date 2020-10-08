//
//  AppDelegate.swift
//  metodum
//
//  Created by João Guilherme on 21/09/20.
//  Copyright © 2020 metodum. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // Firebase configures
        FirebaseApp.configure()
        
        // Push Notification Configuration
        UNUserNotificationCenter.current().delegate = self

        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization( options: authOptions, completionHandler: {_, _ in })
        
        Messaging.messaging().delegate = self

        application.registerForRemoteNotifications()
        
        // podemos também fazer um subscribe desse usuário a um grupo, para, se quisermos, mandarmos um push notification só esse determinado grupo, exemplo
        
        /*let group = "professores"
        Messaging.messaging().subscribe(toTopic: group)
         */
        
        // com o código acima, esse usuário fica inscrito nesse grupo 'professores', então lá no servidor podemos direcionar as push notification para esse grupo se quisermos
        
        // mas se quisermos mandar um push notification direcionado somente para um usuário podemos fazer o seguinte:
        
        //Messaging.messaging().delegate = self
        
        // dizemos que o delegate do messeging é o nosso AppDelegate, então fazemos uma extension, pq existe uma funcao que nos dá um idMesseging, que é um indentificador único desse usuário no servidor do Push Notification, a partir dele , podemos direcionar o push notification para usuários específicos
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
}

extension AppDelegate: MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        print("token")
        print(fcmToken)
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        print("recebeu")
        
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        print("recebeu")
    }
}

func application(application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
    Messaging.messaging().apnsToken = deviceToken as Data
}

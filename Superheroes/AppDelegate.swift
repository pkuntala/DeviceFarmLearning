//
//  AppDelegate.swift
//  Superheroes
//
//  Created by Chris Davis J on 13/12/21.
//

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        loadInitialData()
        loadAppAttributes()
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

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "Superheroes")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    private func loadInitialData(){
        let context = persistentContainer.viewContext

            if UserDefaults.standard.bool(forKey: "isDataLoaded") == false{
                let internals :AppInternalsStatesMO  = AppInternalsStatesMO(context: context)
                internals.accessibilitySpeech = false
                internals.userLogged=nil
                guard let path = Bundle.main.url(forResource: "initUsersData", withExtension: "plist") else { return  }
                let backgroundContext = ((UIApplication.shared.delegate) as! AppDelegate).persistentContainer.newBackgroundContext()

                context.automaticallyMergesChangesFromParent = true
                backgroundContext.perform {
                    
                    if let contents = NSDictionary(contentsOf: path) as? [String:NSArray]{
                        if let users = contents["Users"] as? [NSDictionary]{
                            for item in users {
                                let user : UserMO = UserMO(context: backgroundContext)
                                user.userId = item["userId"] as? String
                                user.password = item["password"] as? String
                                user.userName = item["userName"] as? String
                                user.userPh = item["userPh"] as? String
                                user.userDp = item["userDp"] as? Data
                                user.report = item["report"] as? Data
                            }
                        }
                        do{
                            try backgroundContext.save()
                            UserDefaults.standard.set(true, forKey: "isDataLoaded")
                        }catch{
                            print(error)
                        }

                    }

                }

            }

        }
    private func loadAppAttributes()
    {
        let fetchRequest: NSFetchRequest<AppInternalsStatesMO> = AppInternalsStatesMO.fetchRequest()
        fetchRequest.sortDescriptors = []
        let context = persistentContainer.viewContext
        let temp = try? context.fetch(fetchRequest)
        checkAPIAlive{(result) in
            if result.hasPrefix("Network Error") {
                AppInternalStates.networkAvailability=false
            }
        }
        AppInternalStates.internals = temp?.first
    }
    private func checkAPIAlive(completion: @escaping (String) -> Void){
        guard let url = URL(string: "https://mocki.io/v1/903123fb-fb28-4b4e-9adc-a8ca10a44cf1")else{return}
        
        let task = URLSession.shared.dataTask(with: url){ (data, response, error) in
            if error != nil {
                print("\(error!)")
                completion(String("Network Error"))
                return
            }
            if data == nil{
                completion(String("Network Error"))
            }
            let res = response as! HTTPURLResponse
            if res.statusCode == 200 {
                completion(String("Success"))
            }else{
                completion(String("Network Error"))
            }
        }
        task.resume()
    }
    
}


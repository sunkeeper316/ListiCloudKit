import UIKit
import CoreData
import Foundation

var showItemList = [ShowItem]()

func saveShowItem(name:String) {
    //    var id : NSManagedObjectID?
    if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
        let context = appDelegate.persistentContainer.viewContext
        if let showItem = NSEntityDescription.insertNewObject(forEntityName: "ShowItem", into: context) as? ShowItem {
            showItem.name = name
            do {
                if context.hasChanges {
                    try context.save()
                    print("save ok")
                    //                    return resultData
                }
            } catch let error {
                print(error.localizedDescription)
            }
        }
    }
    
}
func loadShowItem() -> [ShowItem]? {
    if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<ShowItem>(entityName: "ShowItem")
        do {
            let resultDatas = try context.fetch(request)
            
            return resultDatas
        }catch let error {
            print(error.localizedDescription)
        }
    }
    return nil
}

func deleteShowItem()  {
    if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<ShowItem>(entityName: "ShowItem")
        do {
            let resultDatas = try context.fetch(request)
            resultDatas.forEach { context.delete($0) }
            
            if context.hasChanges {
                try context.save()
                print("delete ok")
            }
        }catch let error {
            print(error.localizedDescription)
        }
    }
    
}


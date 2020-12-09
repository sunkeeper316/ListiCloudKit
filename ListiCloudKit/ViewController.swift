
import CloudKit
import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var btSwitch: UISwitch!
    @IBOutlet weak var tfInput: UITextField!
    @IBOutlet weak var lbshow: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        check()
        tableView.delegate = self
        tableView.dataSource = self
        setToolbar(textfield : tfInput)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            if let items = loadShowItem() {
                
                showItemList = items
                self.tableView.reloadData()
                
            }
        }
        
    }
    func check() {
        CKContainer.default().accountStatus { (accountStatus, error) in
            DispatchQueue.main.async {
                switch accountStatus {
                case .available:
                    print("iCloud Available")
                    self.lbshow.text = "iCloud Available"
                case .noAccount:
                    print("No iCloud account")
                    self.lbshow.text = "No iCloud account"
                case .restricted:
                    print("iCloud restricted")
                    self.lbshow.text = "iCloud restricted"
                case .couldNotDetermine:
                    print("Unable to determine iCloud status")
                    self.lbshow.text = "Unable to determine iCloud status"
                }
            }
            
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let ison = NSUbiquitousKeyValueStore.default.bool(forKey: "icloud_sync")
        let test = NSUbiquitousKeyValueStore.default.string(forKey: "test")
        btSwitch.isOn = ison
        print(ison)
        print("")
        print("")
        print("\(test)")
    }
    
    @IBAction func clickSwitch(_ sender: UISwitch) {
        
        NSUbiquitousKeyValueStore.default.set(sender.isOn, forKey: "icloud_sync")
        NSUbiquitousKeyValueStore.default.synchronize()
        let ison = NSUbiquitousKeyValueStore.default.bool(forKey: "icloud_sync")
        print("NSUbiquitousKeyValueStore:\(ison)")
        print(sender.isOn)
        print("")
        print("")
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.persistentContainer = setupContainer(withSync: sender.isOn)
        // delete the zone in iCloud if user switch off iCloud sync
            if(!sender.isOn){
                // replace the identifier with your container identifier
                let container = CKContainer(identifier: "iCloud.charder.SaveList")

                let database = container.privateCloudDatabase

                // instruct iCloud to delete the whole zone (and all of its records)
                database.delete(withRecordZoneID: .init(zoneName: "_defaultZone"), completionHandler: { (zoneID, error) in
                    if let error = error {
                        print("deleting zone error \(error.localizedDescription)")
                    }
                })
            }

    }
    @IBAction func clickSave(_ sender: UIButton) {
        let name = tfInput.text!
        saveShowItem(name : name)
        
        if let items = loadShowItem() {
            
            showItemList = items
            self.tableView.reloadData()
            
        }
        NSUbiquitousKeyValueStore.default.set(name, forKey: "test")
        NSUbiquitousKeyValueStore.default.synchronize()
    }
    @IBAction func clickdelete(_ sender: UIButton) {
        deleteShowItem()
        if let items = loadShowItem() {
            
            showItemList = items
            self.tableView.reloadData()
            
        }
    }
    func setToolbar(textfield : UITextField){
        let toolBarHeight:CGFloat = 150
        //製作鍵盤上方幫手
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.bounds.width , height: toolBarHeight))
        //左邊空白處
        let flexSpace: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        //想製作的按鈕及用途
        let doneBotton: UIBarButtonItem = UIBarButtonItem(title: "OK", style: .done, target: self, action: #selector(doneButtonAction))
        toolBar.setItems([flexSpace,doneBotton], animated: false)
        toolBar.sizeToFit()
        textfield.inputAccessoryView = toolBar
    }
    @objc func doneButtonAction() {
        view.endEditing(true)
    }
}

extension ViewController : UITableViewDelegate , UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return showItemList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "show")!
        
        let showItem = showItemList[indexPath.row]
        cell.textLabel?.text = showItem.name
        
        return cell
        
    }
    
    
}


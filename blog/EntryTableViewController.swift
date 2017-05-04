import UIKit

class EntryTableViewController: UITableViewController {
    
    // MARK: - Properties
    
    private var entryList: [Entry] = []
    
    // MARK: -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        reloadEntryList()
        
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(EntryTableViewController.reload(_:)), for: .valueChanged)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return entryList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "EntryTableViewCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        guard let entryCell = cell as? EntryTableViewCell else {
            // do nothing
            return cell
        }
        
        let entry = entryList[indexPath.row]
        
        entryCell.titleLabel.text = entry.title
        entryCell.detailLabel.text = entry.date
        
        return cell
    }
    
    // MARK: - Actions
    
    @IBAction func reload(_ sender: UIBarButtonItem) {
        reloadEntryList()
    }
    
    // MARK: - Private Methods
    
    private func reloadEntryList() {
        EntryListRequest().send() { entries in
            guard let entries = entries else {
                return
            }
            
            DispatchQueue.main.async {
                self.entryList = entries
                self.tableView.reloadData()
                self.refreshControl?.endRefreshing()
            }
        }
    }
    
}

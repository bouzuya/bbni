import UIKit

class EntryDetailViewController: UIViewController {
    
    // MARK: Properties
    
    @IBOutlet weak var entryDetailWebView: UIWebView!
    
    var date: String?
    
    // MARK: -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let date = date else {
            return
        }
        
        EntryDetailRequest(date).send() { html in
            guard let html = html else {
                return
            }
            
            DispatchQueue.main.async {
                self.entryDetailWebView.loadHTMLString(html, baseURL: nil)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}

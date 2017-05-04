import UIKit

class EntryDetailRequest {
    
    // MARK: - Properties
    
    private var date: String
    
    // MARK: - Initialization
    
    public init(_ date: String) {
        self.date = date
    }
    
    // MARK: - Public Methods
    
    public func send(completionHandler: @escaping (String?) -> Void) -> Void {
        fetchEntryDetail(date: date, completionHandler: completionHandler)
    }
    
    // MARK: - Private Methods
    
    private func fetchEntryDetail(date: String, completionHandler: @escaping (String?) -> Void) -> Void {
        let path = "/" + date.replacingOccurrences(of: "-", with: "/") + ".json"
        let urlString = "https://blog.bouzuya.net" + path
        guard let url = URL(string: urlString) else {
            return completionHandler(nil)
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, _, _ in
            do {
                let html = try self.parseEntryDetail(data)
                return completionHandler(html)
            } catch {
                return completionHandler(nil)
            }
        }
        task.resume()
    }
    
    private func parseEntryDetail(_ data: Data?) throws -> String  {
        guard let data = data else {
            throw EntryError.parse
        }
        
        let json = self.tryq() { try JSONSerialization.jsonObject(with: data, options: []) }
        guard let entryData = json as? NSDictionary else {
            throw EntryError.parse
        }
        
        guard let html = entryData.value(forKey: "html") as? String else {
            throw EntryError.parse
        }
        
        return html
    }
    
    // try?
    private func tryq<T>(f: () throws -> T) -> T? {
        do {
            return try f()
        } catch {
            return nil
        }
    }
    
}

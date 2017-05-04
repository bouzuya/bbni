import UIKit

class EntryListRequest {
    
    // MARK: - Public Methods
    
    public func send(completionHandler: @escaping ([Entry]?) -> Void) -> Void {
        fetchAllEntryList(completionHandler: completionHandler)
    }
    
    // MARK: - Private Methods
    
    private func fetchAllEntryList(completionHandler: @escaping ([Entry]?) -> Void) -> Void {
        let urlString = "https://blog.bouzuya.net/posts.json"
        guard let url = URL(string: urlString) else {
            return completionHandler(nil)
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, _, _ in
            do {
                let entries = try self.parseEntryList(data)
                return completionHandler(entries)
            } catch {
                return completionHandler(nil)
            }
        }
        task.resume()
    }
    
    private func parseEntryList(_ data: Data?) throws -> [Entry]  {
        guard let data = data else {
            throw EntryError.parse
        }
        
        let json = self.tryq() { try JSONSerialization.jsonObject(with: data, options: []) }
        guard let entriesData = json as? NSArray else {
            throw EntryError.parse
        }
        
        return try entriesData.map({ entryAny -> Entry in
            guard let entryData = entryAny as? NSDictionary else {
                throw EntryError.parse
            }
            
            guard let title = entryData.value(forKey: "title") as? String else {
                throw EntryError.parse
            }
            
            guard let date = entryData.value(forKey: "date") as? String else {
                throw EntryError.parse
            }
            
            return Entry(title: title, date: date)
        }).sorted(by: { e1, e2 in
            e1.date > e2.date
        })
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

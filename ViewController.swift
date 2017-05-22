//
//  TableViewController.swift
//  Lazy Loading Table Swifty
//
//  Created by Xiaoping Jia on 1/13/17.
//  Copyright © 2017 DePaul University. All rights reserved.
//

import UIKit
import SwiftyJSON


let feed = "http://ax.itunes.apple.com/WebObjects/MZStoreServices.woa/ws/RSS/toppaidapplications/limit=75/json"

class ViewController: UITableViewController {

    class Record {
        var title: String = ""
        var artist: String = ""
        var imageURL: URL?
        var icon: UIImage?
    }



    enum SerializationError: Error {
        case missing(String)
        case invalid(String, Any)
    }

    var dataAvailable = false
    var records: [Record] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()


        loadData()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        for r in records {
            r.icon = nil
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // if there's no data yet, return enough rows to fill the screen
        return dataAvailable ? records.count : 15
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (dataAvailable) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "LazyTableCell", for: indexPath)
            // Configure the cell...
            let record = records[indexPath.row]
            cell.textLabel?.text = record.title
            cell.detailTextLabel?.text = record.artist
            if let icon = record.icon {
                cell.imageView?.image = icon
            } else {
                cell.imageView?.image = UIImage(named: "Placeholder")
                loadImage(for: record, in: cell.imageView)
            }
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "LazyTableCell", for: indexPath)
            return cell
        }

    }

    //
    //
    //

    func loadData() {
        guard let feedURL = URL(string: feed) else {
            return
        }
        let request = URLRequest(url: feedURL)
        let session = URLSession.shared
        session.dataTask(with: request) { data, response, error in
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
            guard let data = data else { return }

            print(data)
            let json = JSON(data: data)
            for (_, e) in json["feed"]["entry"] {
                if let title = e["im:name"]["label"].string,
                    let artist = e["im:artist"]["label"].string,
                    //let imageURL = e["im:image"][0]["label"].string {
                    let imageURL = e["im:image"].array?.last?["label"].string {
                    print("Title: \(title)\nArtist: \(artist)\nImage: \(imageURL)")
                    let record = Record()
                    record.title = title
                    record.artist = artist
                    record.imageURL = URL(string:imageURL)
                    self.records.append(record)
                }

            }
            self.dataAvailable = true
            DispatchQueue.main.async{
                self.tableView.reloadData()
            }

            }.resume()

    }

    func loadImage(for record: Record, in imageView: UIImageView?) {
        let request = URLRequest(url: record.imageURL!)
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let imageData = data {
                let image = UIImage(data: imageData)
                record.icon = image
                if let imageView = imageView {
                    DispatchQueue.main.async {
                        imageView.image = image
                    }
                }
            }
            }.resume()
    }

    /*
     override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

     // Configure the cell...

     return cell
     }
     */

    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */

    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */

    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

     }
     */

    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */

    /*
     // MARK: - Navigation

     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}

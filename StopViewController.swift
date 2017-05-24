//
//  StopViewController.swift
//  TrainTrack
//
//  Created by Lew Flauta on 5/20/17.
//  Copyright © 2017 Lew Flauta. All rights reserved.
//

import UIKit
import SwiftyJSON

class StopViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {



    let cellID = "stopsCell"


    @IBOutlet weak var stopViewController: UITableView!

    var selectedStop :String = ""
    var feed = "http://lapi.transitchicago.com/api/1.0/ttarrivals.aspx?key=3247f1d04cc9437b92fa8313c6a7e91c&outputType=JSON&mapid="


    class Destinations {
        lazy var destination: String = ""
        lazy var time: String = ""
        lazy var isApproaching: String = ""
        lazy var stpDe: String = ""
        lazy var route: String = ""
        lazy var stopDestination: String = ""

    }



    var records = [Destinations]()

    override func viewDidLoad() {
        super.viewDidLoad()
        feed += selectedStop

        parseData()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func segueToAllLines(_ sender: Any) {
        performSegue(withIdentifier:
            "allLines", sender: nil)
    }

    //MARK: JSON
    func parseData() {
        guard let feedURL = URL(string: feed) else {
            return
        }
        let request = URLRequest(url: feedURL)
        let task = URLSession.shared.dataTask(with: request) {(data, response, error) in
            if error != nil
            {
                print("Error")
            }
            else {
                if let content = data {

                    do {
                        let json = try JSONSerialization.jsonObject(with: content, options: []) as? [String:Any] ?? [:]
                        print(json)

                        if let ctattimetable = json["ctatt"] as? [String:Any] {
                            if let estArrivalTime = ctattimetable["eta"] as? [[String:Any]] {
                                for item in estArrivalTime{


                                    if let headingTowards = item["staNm"] as? String,
                                        let arrivalTime = item["arrT"] as? String, let isApproaching = item["isApp"] as? String, let stpDestination = item["stpDe"] as? String, let route = item["rt"] as? String{
                                        let record = Destinations()
                                        let index = arrivalTime.index(arrivalTime.startIndex, offsetBy:11)
                                        let atime = arrivalTime.substring(from: index)
                                        record.isApproaching = isApproaching
                                        record.stpDe = stpDestination
                                        record.destination = headingTowards
                                        record.time = atime
                                        record.route = route
                                        self.records.append(record)
                                    }
                                    self.stopViewController.reloadData()


                                }

                            }
                        }
                    }
                    catch {

                    }
                }
            }
        }
        task.resume()
    }

    // MARK: TABLEVIEW

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return records.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var status = ""
        let cell = stopViewController.dequeueReusableCell(withIdentifier: cellID, for: indexPath)

        let destinationRow = records[indexPath.row]

        cell.textLabel?.text = destinationRow.destination
        if destinationRow.isApproaching == "1" {
            status = "Approaching"
        } else {status = "Scheduled"}
        cell.textLabel?.text = (destinationRow.route + " " + destinationRow.stpDe)
        cell.detailTextLabel?.text = destinationRow.time
        //cell.textLabel?.text = "A"

        return cell
    }

 /*

     // MARK: - Navigation

     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        performSegue(withIdentifier: "stopView", sender: nil)
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
*/
    
}

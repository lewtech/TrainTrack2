//
//  LineViewController.swift
//  TrainTrack
//
//  Created by Lew Flauta on 5/20/17.
//  Copyright © 2017 Lew Flauta. All rights reserved.
//

import UIKit
import SwiftyJSON

class LineViewController: UIViewController , UITableViewDataSource, UITableViewDelegate{

    let cellID = "lineCell"


    @IBOutlet weak var lineTableView: UITableView!


    class Destinations {
        lazy var destination: String = ""
        lazy var time: String = ""
    }




    var feed = "http://lapi.transitchicago.com/api/1.0/ttarrivals.aspx?key=3247f1d04cc9437b92fa8313c6a7e91c&mapid=41320&outputType=JSON&rt="



     


    //let feed2 = "http://lapi.transitchicago.com/api/1.0/ttpositions.aspx?key=3247f1d04cc9437b92fa8313c6a7e91c&rt=red"

    var records = [Destinations]()

    override func viewDidLoad() {
        super.viewDidLoad()
        var line = "red"
        feed += line

        parseData()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

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
                                    //if let stationName = item["staNm"] as? String {
                                    //print(stationName)
                                    //}

                                    if let headingTowards = item["destNm"] as? String,
                                        let arrivalTime = item["arrT"] as? String {
                                        let record = Destinations()
                                        record.destination = headingTowards
                                        record.time = arrivalTime
                                        self.records.append(record)
                                    }
                                    self.lineTableView.reloadData()


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

        let cell = lineTableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        let destinationRow = records[indexPath.row]
        cell.textLabel?.text = destinationRow.destination
        cell.detailTextLabel?.text = destinationRow.time
        //cell.textLabel?.text = "A"

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "stopView", sender: nil)
    }
    /*
     // MARK: - Navigation

     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}

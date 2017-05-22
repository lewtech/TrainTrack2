//
//  DestinationsViewController.swift
//  TrainTrack
//
//  Created by Lew Flauta on 5/19/17.
//  Copyright © 2017 Lew Flauta. All rights reserved.
//

import UIKit
import SwiftyJSON





    class TableViewController: UITableViewController {

        class Destinations {
            lazy var destination: String = ""
            lazy var time: String = ""
        }

    let feed = "http://lapi.transitchicago.com/api/1.0/ttarrivals.aspx?key=3247f1d04cc9437b92fa8313c6a7e91c&mapid=41320&outputType=JSON"

        var records = [Destinations]()

        override func viewDidLoad() {
            super.viewDidLoad()

            // Uncomment the following line to preserve selection between presentations
            // self.clearsSelectionOnViewWillAppear = false

            // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
            // self.navigationItem.rightBarButtonItem = self.editButtonItem()
            parseData()
        }

        override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
            // Dispose of any resources that can be recreated.
        }

        // MARK: - Table view data source

        override func numberOfSections(in tableView: UITableView) -> Int {
            // #warning Incomplete implementation, return the number of sections
            return 1
        }

        override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            // #warning Incomplete implementation, return the number of rows
            return 2
        }


        override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

            // Configure the cell...
            let destinationRow = records[indexPath.row]
            cell.textLabel?.text = destinationRow.destination
            cell.detailTextLabel?.text = destinationRow.time
            cell.textLabel?.text = "A"
            cell.detailTextLabel?.text = "B"
            return cell
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
                                        self.tableView.reloadData()
                                        
                                        
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



        func parseDatatest() {
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
                                        self.tableView.reloadData()


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

}

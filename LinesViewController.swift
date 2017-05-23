//
//  LinesViewController.swift
//  TrainTrack
//
//  Created by Lew Flauta on 5/17/17.
//  Copyright © 2017 Lew Flauta. All rights reserved.
//

import UIKit

class LinesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var linesTableView: UITableView!
    let cellID = "cell"
    let lines = ["brown","red","blue"]
    var selectedLine : String!

    class Train  {
        var color: String = ""
        var line: String = ""
        var code: String = ""

        init (color:String?, line:String?, code:String?){
            self.color = color!
            self.line = line!
            self.code = code!
        }
    }

    let brownLine = Train(color: "brown", line: "Brown Line", code: "brn")
    let redLine = Train(color: "red", line: "Red Line", code: "red")
    let blueLine = Train(color: "blue", line: "Blue Line", code: "blue")
    let greenLine = Train(color: "green", line: "Green Line", code: "g")
    let orangeLine = Train(color: "orange", line: "Orange Line", code: "org")
    let purpleLine = Train(color: "purple", line: "Purple Line", code: "p")
    let pinkLine = Train(color: "pink", line: "Pink Line", code: "pink")
    let yellowLine = Train(color: "yellow", line: "Yellow Line", code: "y")
    var trains: [Train] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        linesTableView.delegate = self
        linesTableView.dataSource = self
        trains = [brownLine,redLine,blueLine,greenLine,orangeLine,purpleLine,pinkLine,yellowLine]
        //print (trains[1].line)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return trains.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = linesTableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)

        let train = trains[indexPath.row]
        cell.textLabel?.text = train.line
        cell.detailTextLabel?.text = train.line
        //cell.textLabel?.text = "A"
        switch train.color {
            case "brown":
                cell.backgroundColor = .brown
                cell.textLabel?.textColor = .white
            case "red":
                cell.backgroundColor = .red
            case "blue":
                cell.backgroundColor = .blue
                cell.textLabel?.textColor = .white
            case "green":
                cell.backgroundColor = .green
            case "orange":
                cell.backgroundColor = .orange
            case "purple":
                cell.backgroundColor = .purple
                cell.textLabel?.textColor = .white
            case "pink":
                cell.backgroundColor = .magenta
            case "yellow":
                cell.backgroundColor = .yellow
            default:
                cell.backgroundColor = .white

        }

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedLine = trains[indexPath.row].code

        performSegue(withIdentifier: "lineStops", sender: selectedLine)
    }




    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        let selectedLine = segue.destination as! LineStopsTableViewController

        if segue.identifier == "lineStops" {
            selectedLine.selectedLine = sender as! String!
        }


    }


}

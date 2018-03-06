// I created application for iPad, becose I don't work with MAC-development early. It can take many time.
// If grafics don't load, please run application one more. any problrm whit "create real.time"

import UIKit
import Charts
import Realm
import RealmSwift

class ChartsViewController: UIViewController {
    
    @objc dynamic var open: Double = 0.0
    @objc dynamic var close: Double = 0.0
    @objc dynamic var low: Double = 0.0
    @objc dynamic var high: Double = 0.0
    @objc dynamic var time: Int64 = 0
    
    var realm: Realm!
    
    var candleArray: [Double] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createRealm()
        
        setDataCount(count: 50 , time: self.time)
    }
// MARK: Realm
    func createRealm ()  {
        
        let createRealm = DataObject(value: ["open": open, "close": close,"low": low, "high": high])
        let min = 19.0
        let max = 20.0
        
        createRealm.open = Double(arc4random()) / 0xFFFFFFFF  * (max - min) + min
        createRealm.close = Double(arc4random()) / 0xFFFFFFFF  * (max - min) + min
        createRealm.high = Double(arc4random()) / 0xFFFFFFFF  * (max - min) + min
        createRealm.low = Double(arc4random()) / 0xFFFFFFFF  * (max - min) + min
        
        let date = 1519979000 
        let endDate = 1519979070
        var dateArray: [Int64] = []
        
        for i in date...endDate {
            dateArray.append(Int64(i))
        }
        
        let randomIndex = Int(arc4random_uniform(UInt32(dateArray.count)))
        createRealm.time = Int64(dateArray[randomIndex])
        //dateArray.remove(at: randomIndex)
        
        let realm = try! Realm()
        
        try! realm.write {
            realm.add(createRealm)
            
            self.open = createRealm.open
            self.close = createRealm.close
            self.high = createRealm.high
            self.low = createRealm.low
            self.time = createRealm.time
      
            candleArray.append(contentsOf: [open, close])
            
        }
        DispatchQueue.global().async {
            autoreleasepool {
                let realm = try! Realm()
                
                let results = realm.objects(DataObject.self).sorted(byKeyPath: "time", ascending: true)
                print(results)
                do {
                    try FileManager.default.removeItem(at: Realm.Configuration.defaultConfiguration.fileURL!)
                } catch {}
            }
        }
    }

// MARK: CandleStickChart
    
    @IBOutlet var chartView: CandleStickChartView!
    
    func setDataCount(count: Int, time: Int64) {
        let yVals1 = (0..<count).map { (time) -> CandleChartDataEntry in
            createRealm()
   
            return CandleChartDataEntry(x: Double(self.time) , shadowH: high, shadowL: low, open: open, close: close)
        }

        let set1 = CandleChartDataSet(values: yVals1, label: "open>close")

        set1.axisDependency = .left
        set1.drawIconsEnabled = false
        set1.shadowWidth = 1.5
        set1.decreasingFilled = true
        set1.increasingFilled = true
        set1.showCandleBar = true
        
        candleArray.sort {
            
            switch ($0 > $1) {
            case true:
                set1.increasingColor = .red
                set1.decreasingColor = .blue
                set1.shadowColor = .blue
            case false:
                set1.increasingColor = .blue
                 set1.decreasingColor = .red
                set1.shadowColor = .red
                
            }
            return (set1.shadowColor == set1.decreasingColor)
        }
      
        let data = CandleChartData(dataSet: set1)
        chartView.data = data
    }
}



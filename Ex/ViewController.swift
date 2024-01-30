

import RMQClient
import Foundation
import RMQClient
import UIKit
import CocoaAsyncSocket
import UIKit
import RMQClient
import UIKit
import RMQClient



class ViewController: UIViewController {
    @Published var company : String = ""


    
    override func viewDidLoad() {
        super.viewDidLoad()
        
      

        
            self.receiveLogs(company: "yangcompany1")
            self.receiveLogs(company: "yangcompany1")
            sleep(1)
            self.emitLog(company: "yangcompany1")
        
        
        
    }
        func createConnection() -> RMQConnection {

//        http://username:password@yoursitename.com
            let uri = "amqp://neo:01579@112.219.138.170:5672"
            let delegate = RMQConnectionDelegateLogger()
            let connection = RMQConnection(/*uri:uri,*/delegate: delegate)
            return connection
        }
    
    func emitLog(company : String) {
        
        let conn = createConnection()
        conn.start()
        let ch = conn.createChannel()
        let x = ch.fanout("logs")
        let msg = "Hello World!"
        let q = ch.queue(company)
        ch.defaultExchange().publish(msg.data(using: .utf8)!,routingKey: q.name)
        
        
//        x.publish(msg.data(using: String.Encoding.utf8)!)
        print("Sent \(msg)")
       // conn.close()
    }

    func receiveLogs(company : String) {
        let conn = createConnection()
        conn.start()
        let ch = conn.createChannel()
        
        let x = ch.fanout("logs")
        let q = ch.queue(company)
        q.bind(x)
        print("Waiting for logs.")
        
        q.subscribe({(_ message: RMQMessage) -> Void in
            print("Received \(String(data: message.body, encoding: String.Encoding.utf8)!)")
        })
        

    }
    
   
}
//
//import UIKit
//import RMQClient
//
//class ViewController: UIViewController {
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        self.receiveLogs(exchangeName: "logs") // Receiver 설정 추가
//        sleep(1)
//        self.emitLog()
//    }
//
//    func createConnection() -> RMQConnection {
//        let uri = "amqp://neo:01579@112.219.138.170:5672"
//        let delegate = RMQConnectionDelegateLogger()
//        let connection = RMQConnection(/*uri: uri,*/ delegate: delegate)
//        return connection
//    }
//
//    func emitLog() {
//        let conn = createConnection()
//        conn.start()
//        let ch = conn.createChannel()
//        let x = ch.fanout("logs")
//        let msg = "Hello World!"
//        let q = ch.queue("neotest")
//        ch.defaultExchange().publish(msg.data(using: .utf8)!, routingKey: q.name)
//        print("Sent \(msg)")
//    }
//
//    func receiveLogs(exchangeName: String) {
//        let conn = createConnection()
//        conn.start()
//        let ch = conn.createChannel()
//        let x = ch.fanout("logs")
//        let q = ch.queue("neotest", options: .exclusive)
//        q.bind(x)
//
//        print("Waiting for logs.")
//
//        q.subscribe({(_ message: RMQMessage) -> Void in
//            if let messageString = String(data: message.body, encoding: .utf8) {
//                print("Received \(messageString)")
//
//            }
//        })
//    }
//}
////func receiveLogs() {
////        let conn = createConnection()
////        conn.start()
////        let ch = conn.createChannel()
////
////        let x = ch.fanout("logs")
////        let q = ch.queue("neotest")
////        q.bind(x)
////        print("Waiting for logs.")
////
////        q.subscribe({(_ message: RMQMessage) -> Void in
////            print("Received \(String(data: message.body, encoding: String.Encoding.utf8)!)")
////        })
////
////



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


    override func viewDidLoad() {
        super.viewDidLoad()
        self.receiveLogs()
        self.receiveLogs()
        sleep(1)
        self.emitLog()
    }
        func createConnection() -> RMQConnection {
//            let hostName = "112.219.138.170" // 호스트명
//            let userName = "neo" // 유저 이름
//            let password = "01579" // 비밀번호
//            let virtualHost = "/" // 가상 호스트 (기본값인 "/"를 사용하려면 변경하지 마세요)
    
//            let uri = "amqp://\(userName):\(password)@\(hostName):5672\(virtualHost)"
//        http://username:password@yoursitename.com
            let uri = "amqp://neo:01579@112.219.138.170:5672"
            let delegate = RMQConnectionDelegateLogger()
            let connection = RMQConnection(uri:uri,delegate: delegate)
            return connection
        }
    
    func emitLog() {
        
        let conn = createConnection()
        conn.start()
        let ch = conn.createChannel()
        let x = ch.fanout("logs")
        let msg = "Hello World!"
        let q = ch.queue("neotest")
        ch.defaultExchange().publish(msg.data(using: .utf8)!,routingKey: q.name)
        
        
//        x.publish(msg.data(using: String.Encoding.utf8)!)
        print("Sent \(msg)")
       // conn.close()
    }

    func receiveLogs() {
        let conn = createConnection()
        conn.start()
        let ch = conn.createChannel()
        
        let x = ch.fanout("logs")
        let q = ch.queue("neotest")
        q.bind(x)
        print("Waiting for logs.")
        
        q.subscribe({(_ message: RMQMessage) -> Void in
            print("Received \(String(data: message.body, encoding: String.Encoding.utf8)!)")
        })
        
//                q.subscribe({(_ message: RMQMessage) -> Void in
//                    if let messageString = String(data: message.body, encoding: .utf8) {
//                        print("Received \(messageString)")
//        
//                    }
//                })
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

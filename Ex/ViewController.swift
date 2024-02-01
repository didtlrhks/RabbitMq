

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
        
      

        
            self.receiveLogs()
            self.receiveLogs()
            sleep(1)
            self.emitLog()
        
        
        
    }
        func createConnection() -> RMQConnection {


            let uri = "amqp://neo:01579@112.219.138.170:5672"
            let delegate = RMQConnectionDelegateLogger()
            let connection = RMQConnection(/*uri:uri,*/delegate: delegate)
            return connection
        }
    
    func emitLog() {
        
        let conn = createConnection()
        conn.start()
        let ch = conn.createChannel()
        let x = ch.fanout("logs99yang123")
        let msg = "Hello World!"
        let q = ch.queue("",options : .exclusive)
        ch.defaultExchange().publish(msg.data(using: .utf8)!,routingKey: q.name)
        
        
//        x.publish(msg.data(using: String.Encoding.utf8)!)
        print("Sent \(msg)")
        print(q.name)
       // conn.close()
    }

    func receiveLogs() {
        let conn = createConnection()
        conn.start()
        let ch = conn.createChannel()
        
        let x = ch.fanout("logs99yang123")
        let q = ch.queue("",options: .exclusive)
        
      
        q.bind(x)
        print("Waiting for logs.")//여기 까지왔자나
        
        q.subscribe({(_ message: RMQMessage) -> Void in
            print("Received \(String(data: message.body, encoding: String.Encoding.utf8)!)")
            print("여기까진 오니?")
           print(message)
        })
        

    }
    
   
}
//amqp://neo:01579@112.219.138.170:5672

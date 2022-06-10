//
//  ViewController.swift
//  app
//
//  Created by Ryu on 2022/06/10.
//

import UIKit
import Starscream

class ViewController: UIViewController {
    
    @IBOutlet private weak var connectLabel: UILabel!
    @IBOutlet private weak var connectButton: UIButton!
    @IBOutlet weak var linkButton: UIButton! {
        didSet {
            linkButton.setTitle("", for: .normal)
        }
    }
    @IBOutlet private weak var textField: UITextField!
 
    let request = URLRequest(url: URL(string: "http://192.168.0.56:8765")!)
    var socket: WebSocket!
    var isConnected = false
    var textCount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        socket = WebSocket(request: request)
        didReceive()
    }
    
    private func didReceive() {
        socket.onEvent = {[unowned self] event in
            switch event {
            case .connected(_):
                connectLabel.text = "接続完了"
                connectButton.setTitle("接続解除", for: .normal)
                socket.write(string: "client:connected")
                isConnected = !isConnected
            case .disconnected(_, _):
                connectLabel.text = "接続していません"
                connectButton.setTitle("接続", for: .normal)
                isConnected = !isConnected
            case .text(let received):
                let data = received.components(separatedBy: ":")
                if let device = data[safe: 0],
                   let message = data[safe: 1],
                   device == "server" {
                    textField.text = message
                }
            case .error(let error):
                guard let error = error else { return }
                print(error)
            default:
                break
            }
        }
    }
    
    @IBAction func connectButtonDidPress(_ sender: Any) {
        if isConnected {
            socket.disconnect()
            connectLabel.text = "接続解除中"
        }
        else {
            socket.connect()
            connectLabel.text = "接続中"
        }
    }
    
    @IBAction func linkButtonDidPress(_ sender: Any) {
        socket.write(string: "client:link")
    }
    
    @IBAction func textFieldDidChange(_ sender: Any) {
        defer { textCount = textField.text?.count ?? 0 }
        guard isConnected else { return }
        let text = textField.text ?? ""
        if let last = text.last, text.count > textCount {
            socket.write(string: "client:\(String(last))")
        }
        else {
            socket.write(string: "client:delete:\(text)")
        }
    }
    
}

extension Array {
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

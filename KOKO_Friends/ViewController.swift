//
//  ViewController.swift
//  KOKO_Friends
//
//  Created by EmmaRuan on 2022/6/15.
//

import UIKit
import Foundation

class ViewController: UIViewController {
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblKoKoID: UILabel!
    @IBOutlet weak var segmentedFriend: UISegmentedControl!
    @IBOutlet weak var segScrollView: UIScrollView!
    @IBOutlet weak var noFriendStack: UIStackView!
    @IBOutlet weak var FriendTableView: UITableView!
    @IBOutlet weak var btnAddFriend: UIButton!
    
    var coverView = UIView()
    var noFrinend = UIButton()
    var friendsNoInvited = UIButton()
    var friendsInvited = UIButton()
    var btnClose = UIButton()
    var seperatorLineView = UIView()
    
    var arrayInvitedName = [String]()
    var arrayInvitedisTop = [String]()
    var arrayStatus = [Int]()
    
    let noFriendURL = "https://dimanyen.github.io/friend4.json"
    let noInvitedURL = "https://dimanyen.github.io/friend3.json"
    let InvitedURL1 = "https://dimanyen.github.io/friend1.json"
    let InvitedURL2 = "https://dimanyen.github.io/friend2.json"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        segScrollView.isHidden = true
        noFriendStack.isHidden = true
        FriendTableView.delegate = self
        FriendTableView.dataSource = self
        
        setUpUI()
        //取得使用者資料
        if let url = URL(string: "https://dimanyen.github.io/man.json"){
            URLSession.shared.dataTask(with: url) {(data, res, error) in
                DispatchQueue.main.async{ [self] in
                    if let data = data{
                        if  let JsonData = try? JSONDecoder().decode(Profile.self, from: data){
                            lblName.text = "\(JsonData.response[0].name)"
                            lblKoKoID.text = "KOKO ID: \(JsonData.response[0].kokoid)"
                        }
                    }
                }
            }.resume()
        }
        
    }
    
    deinit{
        print("Deinit Done~")
    }
    
    func setUpUI(){
        coverView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        coverView.backgroundColor = .black
        
        noFrinend.frame = CGRect(x: 30, y: 50, width: 330, height:  100)
        friendsNoInvited.frame = CGRect(x: 30, y: noFrinend.bounds.height*1.7, width: 330, height:  100)
        friendsInvited.frame = CGRect(x: 30, y: friendsNoInvited.bounds.height*2.9, width: 330, height:  100)
        
        noFrinend.backgroundColor = .systemPink
        friendsNoInvited.backgroundColor = .systemGreen
        friendsInvited.backgroundColor = .systemBlue
        
        noFrinend.setTitle("無好友", for: .normal)
        friendsNoInvited.setTitle("好友列表無邀請", for: .normal)
        friendsInvited.setTitle("好友列表含邀請好友", for: .normal)
        
        noFrinend.titleLabel?.textColor = .black
        friendsNoInvited.titleLabel?.textColor = .black
        friendsInvited.titleLabel?.textColor = .black
        
        self.view.addSubview(coverView)
        coverView.addSubview(noFrinend)
        coverView.addSubview(friendsInvited)
        coverView.addSubview(friendsNoInvited)
        
        noFrinend.addTarget(self, action: #selector(noFriendInfo), for: .touchUpInside)
        friendsNoInvited.addTarget(self, action: #selector(friendsNoInvitedInfo), for: .touchUpInside)
        friendsInvited.addTarget(self, action: #selector(friendsInvitedInfo), for: .touchUpInside)
        
        //畫條水平線
        seperatorLineView = UIView(frame: CGRect(x: 0, y: segmentedFriend.bounds.height * 6.9, width: self.view.bounds.width, height: 1))
        seperatorLineView.layer.borderWidth = 1
        seperatorLineView.layer.borderColor = UIColor.lightGray.cgColor
        seperatorLineView.layer.shadowColor = UIColor.black.cgColor
        seperatorLineView.layer.opacity = 0.2
        seperatorLineView.layer.shadowRadius = 10
        seperatorLineView.layer.shadowOffset = CGSize(width: 0, height: 2)
        seperatorLineView.layer.masksToBounds = true
        self.view.addSubview(seperatorLineView)
        seperatorLineView.isHidden = true
        
        //btn加好友
        btnAddFriend.titleLabel?.textColor = .white
        btnAddFriend.layer.borderColor = UIColor.lightGray.cgColor
        btnAddFriend.layer.borderWidth = 0.2
        btnAddFriend.layer.shadowColor = UIColor.green.cgColor
        btnAddFriend.layer.cornerRadius = 20
        btnAddFriend.layer.shadowRadius = 5
        btnAddFriend.layer.opacity = 1
        btnAddFriend.layer.shadowOffset = CGSize(width: 0, height: 2)
    }
    
    @objc func noFriendInfo(){
        //arrayNoFrinend
        coverView.isHidden = true
        segScrollView.isHidden = true
        noFriendStack.isHidden = false
        seperatorLineView.isHidden = false

        arrayInvitedName = []
        arrayInvitedisTop = []
        arrayStatus = []
        
        if let url = URL(string: noFriendURL){
            URLSession.shared.dataTask(with: url) {(data, res, error) in
                DispatchQueue.main.async{[self] in
                    if let data = data{
                        guard let JsonData = try? JSONDecoder().decode(Friends.self, from: data) else{ return }
                        print(JsonData)
                        if  JsonData.response.isEmpty{ return }

                        for i in 0..<JsonData.response.count{
                            let name = JsonData.response[i].name as String
                            let status = JsonData.response[i].status as Int
                            let isTop = JsonData.response[i].isTop as String
                            let fid = JsonData.response[i].fid as String
                            let updateDate =  JsonData.response[i].updateDate as String
                            arrayInvitedName.append(name)
                            arrayInvitedisTop.append(isTop)
                            arrayStatus.append(status)
                            
                        }
                        var newArray = [String]()
                        var newTop = [String]()
                        var newStatus = [Int]()

                        //排除重複的姓名
                        for value in arrayInvitedName {
                            if (newArray.contains(value)) {
                                continue
                            }
                            newArray.append(value)
                        }
                        arrayInvitedName = newArray
                    }
                }
            }.resume()
        }
        FriendTableView.reloadData()
    }
    
    @objc func friendsNoInvitedInfo(){
        //arrayFriendsNoInvited
        coverView.isHidden = true
        noFriendStack.isHidden = true
        segScrollView.isHidden = false
        seperatorLineView.isHidden = false

        arrayInvitedName = []
        arrayInvitedisTop = []
        if let url = URL(string: noInvitedURL){
            URLSession.shared.dataTask(with: url) {(data, res, error) in
                DispatchQueue.main.async{[self] in
                    if let data = data{
                        guard let JsonData = try? JSONDecoder().decode(Friends.self, from: data) else{ return }
                        print(JsonData)
                        if  JsonData.response.isEmpty{ return }

                        for i in 0..<JsonData.response.count{
                            let name = JsonData.response[i].name as String
                            let status = JsonData.response[i].status as Int
                            let isTop = JsonData.response[i].isTop as String
                            let fid = JsonData.response[i].fid as String
                            let updateDate =  JsonData.response[i].updateDate as String
                            arrayInvitedName.append(name)
                            arrayStatus.append(status)
                            
                        }
                        var newArray = [String]()
                        var newTop = [String]()
                        var newStatus = [Int]()

                        //排除重複的姓名
                        for value in arrayInvitedName {
                            if (newArray.contains(value)) {
                                continue
                            }
                            newArray.append(value)
                        }
                        arrayInvitedName = newArray
                    }
                    FriendTableView.reloadData()
                }
            }.resume()
        }
    }
    
    @objc func friendsInvitedInfo(){
        //arrayfriendsInvited
        coverView.isHidden = true
        noFriendStack.isHidden = true
        segScrollView.isHidden = false
        seperatorLineView.isHidden = false

        arrayInvitedName = []
        arrayInvitedisTop = []
        //合併兩個好友列表
        if let url = URL(string: InvitedURL1){
            URLSession.shared.dataTask(with: url) {(data, res, error) in
                DispatchQueue.main.async{ [self] in
                    if let data = data{
                        guard let JsonData = try? JSONDecoder().decode(Friends.self, from: data) else{ return }
                        print(JsonData)
                        if  JsonData.response.isEmpty{ return }

                        for i in 0..<JsonData.response.count{
                            let name = JsonData.response[i].name as String
                            let status = JsonData.response[i].status as Int
                            let isTop = JsonData.response[i].isTop as String
                            let fid = JsonData.response[i].fid as String
                            let updateDate =  JsonData.response[i].updateDate as String
                            arrayInvitedName.append(name)
                            arrayInvitedisTop.append(isTop)
                            arrayStatus.append(status)
                        }
                    }
                }
            }.resume()
        }
        if let url2 = URL(string: InvitedURL2){
            URLSession.shared.dataTask(with: url2) {(data, res, error) in
                DispatchQueue.main.async{ [self] in
                    if let data = data{
                        guard let JsonData = try? JSONDecoder().decode(Friends.self, from: data) else{ return }
                        print(JsonData)
                        if  JsonData.response.isEmpty{ return }

                        for i in 0..<JsonData.response.count{
                            let name = JsonData.response[i].name as String
                            let status = JsonData.response[i].status as Int
                            let isTop = JsonData.response[i].isTop as String
                            let fid = JsonData.response[i].fid as String
                            let updateDate =  JsonData.response[i].updateDate as String
                            arrayInvitedName.append(name)
                            arrayInvitedisTop.append(isTop)
                            arrayStatus.append(status)
                            
                        }
                        var newArray = [String]()
                        var newTop = [String]()
                        var newStatus = [Int]()

                        //排除重複的姓名
                        for value in arrayInvitedName {
                            if (newArray.contains(value)) {
                                continue
                            }
                            newArray.append(value)
                        }
                        arrayInvitedName = newArray
                    }
                    FriendTableView.reloadData()
                }
            }.resume()
        }
        
    }
    
    @IBAction func segmentedChanged(_ sender: UISegmentedControl) {
        //好友
        if sender.selectedSegmentIndex == 0 {
            print("0")
        }
        //聊天
        if sender.selectedSegmentIndex == 1 {
            print("1")
            coverView.isHidden = false
            noFriendStack.isHidden = true
            sender.selectedSegmentIndex = 0
        }
    }
}


extension ViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !arrayInvitedName.isEmpty{
            return arrayInvitedName.count
        }
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "friendTableViewCell") as! FriendTableViewCell
        cell.TopStar.isHidden = true
        cell.btnTransfer.layer.borderColor = UIColor(red: 236/255, green: 0, blue: 140/255, alpha: 1).cgColor
        cell.btnTransfer.layer.borderWidth = 1
        
        if !arrayInvitedName.isEmpty{
        
             cell.cellName.text = arrayInvitedName[indexPath.row]
        }

        if !arrayInvitedisTop.isEmpty && arrayInvitedisTop[indexPath.row] == "1"{
            cell.TopStar.isHidden = false
        }
        
        if !arrayStatus.isEmpty && arrayStatus[indexPath.row] == 2{
            cell.btnInvited.layer.borderColor = UIColor(red: 153/255, green: 153/255, blue: 153/255, alpha: 1).cgColor
            cell.btnInvited.layer.borderWidth = 1

            cell.btnInvited.setImage(nil, for: .normal)
            cell.btnInvited.setImage(UIImage(named: ""), for: .normal)
            cell.btnInvited.imageView?.image = nil
            
            cell.btnInvited.backgroundColor = .white
            cell.btnInvited.setTitle("邀請中", for: .normal)
        }else{
            cell.btnInvited.layer.borderColor = UIColor.white.cgColor
            cell.btnInvited.layer.borderWidth = 0
            cell.btnInvited.setImage(UIImage(named: "icFriendsMore"), for: .normal)
            cell.btnInvited.setTitle("", for: .normal)
        }
        
        return cell
    }
    
}

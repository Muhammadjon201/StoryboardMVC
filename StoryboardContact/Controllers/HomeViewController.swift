//
//  HomeViewController.swift
//  StoryboardContact
//
//  Created by Muhammadjon Mamarasulov on 1/26/22.
//

import UIKit

class HomeViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableLabel: UITableView!
    var items: Array<Post> = Array()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initViews()
        
    }
    
    func refreshTableView(posts: [Post]){
        self.items = posts
        self.tableLabel.reloadData()
    }
    
    func apiPostList(){
        showProgress()
        AFHttp.get(url: AFHttp.API_POST_LIST, params: AFHttp.paramsEmpty(), handler: { response in
            self.hideProgress()
            switch response.result {
                case .success:
                    let posts = try! JSONDecoder().decode([Post].self, from: response.data!)
                    self.refreshTableView(posts: posts)
            case let .failure(error):
                print(error)
            }
        })
    }
    
    func apiPostDelete(post:Post){
        showProgress()
        AFHttp.del(url: AFHttp.API_POST_DELETE + post.id!, params: AFHttp.paramsEmpty(), handler: {response in
            self.hideProgress()
            switch response.result {
            case .success:
                print(response.result)
                self.apiPostList()
            case let .failure(error):
                print(error)
            }
        })
        
    }
    
    

    // MARK: - Method

    func initViews(){
        tableLabel.delegate = self
        tableLabel.dataSource = self
        
        
        initNavigation()
        apiPostList()
       

    }
    func initNavigation(){
        let refresh = UIImage(named: "ic_refresh")
        let add = UIImage(named: "ic_add")
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: refresh, style: .plain, target: self, action: #selector(leftTapped))
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: add, style: .plain, target: self, action: #selector(rightTapped))
        title = "MVC Pattern"
    }
    
    // Opens page with push
    func callCreateViewController(){
        let vc = CreateViewController(nibName: "CreateViewController", bundle: nil)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    // Open new page with present
    func callEditViewController(){
        let homeView = EditViewController(nibName: "EditViewController", bundle: nil)
        let navigationController = UINavigationController(rootViewController: homeView)
        self.present(navigationController, animated: true, completion: nil)
    }
        
    // MARK: - Action
    @objc func leftTapped(){
        apiPostList()
    }
    @objc func rightTapped(){
        callCreateViewController()
    }
    
    
    // MARK: - tableView
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = items[indexPath.row]
        
        let cell = Bundle.main.loadNibNamed("PostTableViewCell", owner: self, options: nil)?.first as!
            PostTableViewCell
        
        cell.titleLabel.text = item.title
        cell.bodyLabel.text = item.body
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        return UISwipeActionsConfiguration(actions: [makeCompleteContextualAction(forRowAt: indexPath, post: items[indexPath.row])])
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        return UISwipeActionsConfiguration(actions: [makeDeleteContextualAction(forRowAt: indexPath, post: items[indexPath.row])])
    }
    
    // MARK: - Contextual Actions
    
    private func makeDeleteContextualAction(forRowAt indexPath: IndexPath, post: Post) -> UIContextualAction {
        return UIContextualAction(style: .normal, title: "Delete") {(action, swipeButton, completion) in
            print ("DELETE HERE")
            completion(true)
            self.apiPostDelete(post: post)
        }
    }
    
    private func makeCompleteContextualAction(forRowAt indexPath: IndexPath, post: Post) -> UIContextualAction {
        return UIContextualAction(style: .normal, title: "Edit") {(action, swipeButton, completion) in
            print ("COMPLETE HERE")
            completion(true)
            self.callEditViewController()
        }
    }
   

}

//
//  CreateViewController.swift
//  StoryboardContact
//
//  Created by Muhammadjon Mamarasulov on 1/26/22.
//

import UIKit

class CreateViewController: BaseViewController {
    @IBOutlet weak var titleText: UITextField!
    
    @IBOutlet weak var bodyText: UITextField!
    
    var home = HomeViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func apiPostCreate(post: Post) {
           showProgress()
           AFHttp.post(url: AFHttp.API_POST_CREATE, params: AFHttp.paramsPostCreate(post: post), handler: {response in
               self.hideProgress()
               switch response.result {
               case .success:
                   print(response.result)
                   self.home.self.apiPostList()
               case let .failure(error):
                   print(error)
               }
           })
       }
    
    @IBAction func AddButton(_ sender: Any) {
             let nameTitle = titleText.text
             let nameBody = bodyText.text
             self.apiPostCreate(post: Post(title: nameTitle!, body: nameBody!))
             
             let homeView = HomeViewController(nibName: "HomeViewController", bundle: nil)
             self.navigationController?.pushViewController(homeView, animated: true)
             
             if nameTitle != nil && nameBody != nil {
                 titleText.text = nil
                 bodyText.text = nil
             }
    }
    
   
    
}


    

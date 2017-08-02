
import UIKit

class AboutThisAppViewController: UIViewController {

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.navigationItem.leftBarButtonItem =
            
            UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelButtonTapped))
            
            
        self.navigationItem.rightBarButtonItem?.tintColor = .white
        
    }
    
    func cancelButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
    

}

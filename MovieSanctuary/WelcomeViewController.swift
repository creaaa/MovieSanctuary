
// https://ashfurrow.com/blog/putting-a-uicollectionview-in-a-uitableviewcell-in-swift/

import UIKit

class WelcomeViewController: UIViewController {

    let model: [[UIColor]] = generateRandomData()
    var storedOffsets      = [Int:CGFloat]()

    var img: UIImage?

    
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        tableView.delegate   = self
        tableView.dataSource = self
        
        self.img = try! fetchImgFromUrlStr(urlStr: "https://pbs.twimg.com/media/Cwf3zVcUUAA61Wi.jpg")
        
        // tableView.reloadData()
        
    }
    
    
    enum FetchImgError: Error {
        case urlCreationFailed
        case dataCreationFailed
        case imageCreationFailed
    }
        
    func fetchImgFromUrlStr(urlStr: String) throws -> UIImage? {
        
        guard let url  = URL(string: urlStr) else {
            throw FetchImgError.urlCreationFailed
        }
        
        guard let data = try? Data(contentsOf: url) else {
            throw FetchImgError.dataCreationFailed
        }
        
        guard let image = UIImage(data: data) else {
            throw FetchImgError.imageCreationFailed
        }
        
        return image
        
    }
    
}


extension WelcomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int { return 6 }
    
    // 10個
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { return 1 }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell",
                                                 for: indexPath) as! WelcomeViewControllerCell
        
        // ↑ 実はこのas! サブクラスが持つプロパティを使いたい、とかじゃなければ別にやらんでもよい。
        // 問題なく描画される。@IBOutletを持つ場合でもいける。。奇妙やけど。まぁやめとこう
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        guard let cell = cell as? WelcomeViewControllerCell else { return }
        
        cell.setCollectionViewDataSourceDelegate(self, forRow: indexPath.row)
        
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        guard let tableViewCell = cell as? WelcomeViewControllerCell else { return }
        
        storedOffsets[indexPath.row] = tableViewCell.collectionViewOffset
    }
    
    
    /// header ///
    
    // 注意) おそらく、↓のviewForHeaderを実装した場合は、こっちはシカトされる
    /*
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    }
    */
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
     
        let view = UIView()
        view.backgroundColor = .black
        
        let label = UILabel(frame: .zero)
        label.text = {
            switch section {
            case 0:
                return "NOW ON AIR"
            case 1:
                return "MASTERPIECE"
            case 2:
                return "MADE 4 YOU"
            case 3:
                return "ACTION"
            case 4:
                return "SUSPENSE"
            case 5:
                return "KIDS"
            default:
                fatalError()
            }
        }()
        label.font = UIFont(name: "Quicksand", size: 18)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(label)
        
        label.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        label.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        return view
        
    }
    
    /*
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    */
    
    /// footer
    /*
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return "ffff"
    }
 
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 30
    }
    */
    
}


extension WelcomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    // 20個
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.model[collectionView.tag].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // UICollectionViewCell
        let item = collectionView.dequeueReusableCell(withReuseIdentifier: "Item",
                                                      for: indexPath) as! CollectionViewCell
        
        // item.backgroundColor = model[collectionView.tag][indexPath.item]
        
        item.imageView.image = self.img
        
        return item
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Collection view at row \(collectionView.tag) selected index path \(indexPath)")
    }
    
}


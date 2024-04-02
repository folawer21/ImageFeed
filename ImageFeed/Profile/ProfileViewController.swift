import UIKit
import Kingfisher

class ProfileViewController: UIViewController & ProfileViewControllerProtocol {
  
    
    private lazy var profileImageView = UIImageView()
    private lazy var nameLabel = UILabel()
    private lazy var nicknameLabel = UILabel()
    private lazy var  descriptionLabel = UILabel()
//    private lazy var profileService = ProfileService.shared
//    private lazy var logoutService = ProfileLogoutService.shared
    var presenter: ProfilePresenterProtocol?
    private lazy var tokenStorage = OAuth2TokenStorage()
    private var profileImageServiceObserver: NSObjectProtocol?
    private  var exitButton = UIButton.systemButton(with: UIImage(named: "exitButton")!, target: self, action: #selector(exitButtonTapped))
    override func viewDidLoad() {
        super.viewDidLoad()
        configureScreen()
        setProfileData()
        setObserver()
//        profileImageServiceObserver = NotificationCenter.default.addObserver(
//            forName: ProfileImageService.didChangeNotification, object: nil, queue: .main){ [weak self] _ in
//                guard let self = self else {return }
//                self.updateAvatar()
//            }
//        updateAvatar()
    }
    func updateAvatar(with url: URL){
//        guard
//            let profileImageURL = ProfileImageService.shared.avatarURL,
//            let url = URL(string: profileImageURL)
//        else {return}
        let processor = RoundCornerImageProcessor(cornerRadius: 32)
        profileImageView.kf.setImage(with: url,options: [.processor(processor)])
    }
    func setObserver(){
        presenter?.setObserverForViewController()
    }
    func setProfileData(){
        guard let profile = presenter?.getProfile() else {return}
        self.nameLabel.text = profile.name
        self.nicknameLabel.text = profile.loginName
        self.descriptionLabel.text = profile.bio
    }
    func configureScreen(){
        buildScreen()
        addSubViews()
        activateConstraints()
    }
    @objc
    private func exitButtonTapped(){
        let alert = UIAlertController(title: "Пока, Пока!", message: "Уверены что хотите выйти?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Да", style: .default){ _ in
            self.presenter?.exitAccount()
        })
        alert.addAction(UIAlertAction(title: "Нет", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func buildScreen(){
        self.view.backgroundColor = UIColor(named: "YPBlack")
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.layer.masksToBounds = true
        profileImageView.layer.cornerRadius = 40
        profileImageView.backgroundColor = UIColor(named: "YPBlack")
        profileImageView.image = UIImage(named: "ekaterina")
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.text = "Екатерина Новикова"
        nameLabel.textColor = UIColor(named: "YPWhite")
        nameLabel.font = UIFont(name: "System Font Regular", size: 23.0)
       
        nicknameLabel.translatesAutoresizingMaskIntoConstraints = false
        nicknameLabel.textColor = UIColor(named: "YPGray")
        nicknameLabel.text = "@ekaterina_nov"
        nicknameLabel.font = UIFont(name: "System Font Regular", size: 13)
      
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.textColor  = UIColor(named: "YPWhite")
        descriptionLabel.text = "Hellow, world!"
        descriptionLabel.font = UIFont(name: "System Font Regular", size: 13)
        
        exitButton.translatesAutoresizingMaskIntoConstraints = false
        exitButton.accessibilityIdentifier = "exitButton"
        exitButton.tintColor = UIColor(named: "YPRed")
    }
    
    func addSubViews(){
        view.addSubview(profileImageView)
        view.addSubview(nameLabel)
        view.addSubview(nicknameLabel)
        view.addSubview(descriptionLabel)
        view.addSubview(exitButton)
    }
    
    func activateConstraints(){
        NSLayoutConstraint.activate([
            profileImageView.widthAnchor.constraint(equalToConstant: 70),
            profileImageView.heightAnchor.constraint(equalToConstant: 70),
            profileImageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            profileImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32)
        ])
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 8),
            nameLabel.leadingAnchor.constraint(equalTo: profileImageView.leadingAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            nameLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor , constant: -15)
        ])
        NSLayoutConstraint.activate([
            nicknameLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            nicknameLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            nicknameLabel.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor),
            nicknameLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16)
        ])
        
        NSLayoutConstraint.activate([
            descriptionLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            descriptionLabel.topAnchor.constraint(equalTo: nicknameLabel.bottomAnchor, constant: 8),
            descriptionLabel.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor),
            descriptionLabel.leadingAnchor.constraint(equalTo:  view.safeAreaLayoutGuide.leadingAnchor, constant: 16)
        ])
        
        NSLayoutConstraint.activate([
            exitButton.widthAnchor.constraint(equalToConstant: 24),
            exitButton.heightAnchor.constraint(equalToConstant: 24),
            exitButton.leadingAnchor.constraint(greaterThanOrEqualTo: profileImageView.trailingAnchor),
            exitButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor,constant: -24),
            exitButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 55)
        ])
    }
}


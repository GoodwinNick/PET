import UIKit

class MenuViewController: BaseViewController<MenuViewModel> {
    
    @IBOutlet weak var itemsStackView      : UIStackView!
    @IBOutlet weak var scrollView          : UIScrollView! { didSet { configScrollView() } }
    @IBOutlet weak var tapGestureRecognizer: UITapGestureRecognizer!
    @IBOutlet weak var mainBackgroundView  : UIView!
    
}

// MARK: - Standard overriding
extension MenuViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addGestureRecognizer(tapGestureRecognizer)
        tapGestureRecognizer.addTarget(self, action: #selector(tapGesture))
        self.view.setBGColor(.transparentMenuView(alpha: 0))
    }
    
}


// MARK: - UI
extension MenuViewController {
    
    override func configUI() {
        super.configUI()
        itemsStackView.spacing = 16
    }
    
    override func configColors() {
        super.configColors()
        self.mainBackgroundView.setBGColor(.secondaryBackground)
    }
    
    override func configStrings() {
        super.configStrings()
        configButtons()
    }
    
}


// MARK: - UI helpers
extension MenuViewController {
    
    private func configScrollView() {
        scrollView.contentInset.top    = 16
        scrollView.contentInset.bottom = UIApplication.safeAreaInsets.bottom
    }
    
    private func configButtons() {
        itemsStackView.arrangedSubviews.forEach { if $0.tag != 999 { $0.removeFromSuperview() } }
        MenuItem.allCases
            .filter { $0 != viewModel.fromMenuItem }
            .enumerated()
            .forEach { self.configButton($0) }
    }
    
    private func configButton(_ value: EnumeratedSequence<[MenuItem]>.Iterator.Element) {
        let buttonAction: (UIAction) -> Void = { _ in
            self.viewModel.completion()
            self.hidingAnimation()
            value.element.action()
        }
        let button = UIButton(type: .custom)
        button.tag = value.offset
        button.addAction(UIAction(handler: buttonAction), for: .touchUpInside)
        button.setButtonAttributedTitle(value.element.string, .medi(size: 23, .bgButtonText))
        button.config(bgColor: .buttonBackground, borderColor: .buttonBorder, borderWidth: 2, cornerRadius: 8)
        button.addConstraint(button.heightAnchor.constraint(equalToConstant: 50))
        itemsStackView.addArrangedSubview(button)
    }
}


// MARK: - Actions
extension MenuViewController {
    @objc func tapGesture() {
        viewModel.completion()
        UIView.transition(with: self.view, duration: 0.25) {
            self.view.setBGColor(.transparentMenuView(alpha: 0.01))
        }
    }
}

// MARK: - Helpers
extension MenuViewController {
    func startShowViewAnimation() {
        UIView.transition(with: self.view, duration: 1) {
            self.view.setBGColor(.transparentMenuView(alpha: 0.25))
        }
    }
    
    func hidingAnimation() {
        UIView.transition(with: self.view, duration: 0.1) {
            self.view.setBGColor(.transparentMenuView(alpha: 0))
        }
    }
}

// MARK: - MenuView
extension MenuViewController: MenuView {
    
}

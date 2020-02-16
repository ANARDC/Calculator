# Calculator
iOS Calculator App
## Архитектура
![Alt text](https://sun9-15.userapi.com/c206616/v206616116/709bc/kMVmSAxV54E.jpg?raw=true "Architecture")
  Архитектурой является улучшенный мною VIPER с помощью использования наследования протоколов, 
а также паттерна "Фабричный метод".

В данном приложении имеется несколько элементов View: 
* Главный View, содержащий калькулятор, а также кнопки
* UICollectionView's калькулятора
* View, отображающееся при нажатии на кнопку Info
* View, отображающееся при нажатии на кнопку Operations

Поскольку создавать отдельные Presenter's для каждого такого элемента было бы слишком затруднительно из-за большого 
количества зависимостей между множеством классов, то я решил оставить концепцию одного Presenter-элемента. 
Однако, каким-то образом необходимо предоставлять разным элементам View разные интерфейсы взаимодействия с элементом Presenter 
причем так чтобы методы одного интерфейса не имели место в другом.

Чтобы реализовать такой подход я создаю протоколы для разбиения Presenter'а, по каждому на каждый элемент View, а также еще
общий протокол, наследуемый от всех вышеупомянутых протоколов, который нам понадобится в дальнейшем в конфигураторе и для того 
чтобы задавать Presenter'у какие-либо общие свойства и методы, которые будут доступны для всех 
протоколов-делегатов (не совсем). Каждый элемент View при этом имеет сильную ссылку на соответствующий ему Presenter-делегат.
```
final class CalculatorViewController: UIViewController, CalculatorViewDelegate {
  var presenter: CalculatorPresenterDelegate!
  ...
}
 
final class InfoViewController: UIViewController, InfoViewDelegate {
  var presenter: CalculatorInfoViewPresenterDelegate!
  ...
}

final class OperationsViewController: UIViewController, OperationsViewDelegate {
  var presenter: CalculatorOperationsViewPresenterDelegate!
  ...
}

final class CalculatorCollectionViewCell: UICollectionViewCell, CalculatorCollectionViewCellDelegate {
  var presenter: CalculatorCollectionViewCellPresenterDelegate!
  ...
}
```

Такая же схема применяется и для элемента Interactor. Он разбивается протоколами для того чтобы предоставить интерфейсы для 
каждого Presenter-делегата (кроме Presenter'ов для UICollectionViewCell's так как в данном случае это не понадобилось). 
Каждый Presenter-делегат имеет сильную ссылку на соответствующий ему Interactor-делегат, а каждый Interactor-делегат имеет 
слабую ссылку на соответствующий ему Presenter-делегат.
```
final class CalculatorPresenter: CalculatorPresenterGeneralProtocol {
  var calculatorViewInteractor : CalculatorInteractorDelegate!
  var infoViewInteractor       : CalculatorInfoViewInteractorDelegate!
  var operationsViewInteractor : CalculatorOperationsViewInteractorDelegate!
  ...
}

final class CalculatorInteractor: CalculatorInteractorGeneralProtocol {
  weak var calculatorViewPresenter : CalculatorPresenterDelegate!
  weak var infoViewPresenter       : CalculatorInfoViewPresenterDelegate!
  weak var operationsViewPresenter : CalculatorOperationsViewPresenterDelegate!
  ...
}
```

Presenter-делегат главного View имеет сильную ссылку на ComputingFactoryDelegate для осуществления всех расчетов. 
ComputingFactoryDelegate в свою очередь держит слабую ссылку на Presenter.
```
final class CalculatorPresenter: CalculatorPresenterGeneralProtocol {
  var computingFactory: ComputingFactoryDelegate!
  ...
}

final class ComputingFactory: ComputingFactoryDelegate {
  weak var presenter: CalculatorPresenterGeneralProtocol! // По-хорошему такого делать не стоит, нужно выделить отдельный делегат
  ...
}
```

CalculatorConfigurator представляет собой класс, который производит всю инициализацию, присвоение свойств и отвечает за 
создание необходимых взаимосвязей между классами. Он держит слабую ссылку на главный View посколько последний имеет сильную 
ссылку на конфигуратор, а также хранит сильные ссылки на остальные View-элементы (кроме UICollectionViewCell's так как эти 
элементы будут присваиваться в соответствующий Presenter-делегат с помощью метода), ComputingFactoryDelegate и 
общие протоколы элементов Presenter и Interactor.
```
final class CalculatorConfigurator: CalculatorConfiguratorDelegate {
  weak var calculatorView : CalculatorViewDelegate!
  let infoView            : InfoViewDelegate!
  let operationsView      : OperationsViewDelegate!
  
  let presenter        : CalculatorPresenterGeneralProtocol!
  let interactor       : CalculatorInteractorGeneralProtocol!
  let computingFactory : ComputingFactoryDelegate!
  ...
}
```

Router-элемент из архитектуры VIPER в данном приложении не пригодился из-за наличия всего одного экрана и отсутствия навигации.

Такая схема с протоколами обеспечивает гибкость и имеет преимущество в том что может неограниченно масштабироваться 
для любого количества View-элементов на экране, сохраняя при этом целостность какого-либо элемента (Presenter, Interactor, etc) 
и предоставляя только необходимые части для определенных других элементов архитектуры. 
Необходимо лишь создавать соответствующие интерфейсы для View-элементов и добавлять эти 
интерфейсы как протоколы-родители для общего протокола.

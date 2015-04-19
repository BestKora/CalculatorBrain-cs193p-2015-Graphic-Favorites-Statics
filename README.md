# Стэнфорд cs193p 2015. Задание 2.

Cтэнфордский курс "Разработка iOS 8 приложений с Swift" cs193p 2015. Задание 2 "Умный калькулятор".

Для Xcode 6.2 iOS 8.2 Swift 1.1

Отдельные пункты Задания 2 доступны через Releases и Tags

[Окончательный вариант](http://bestkora.com/IosDeveloper/zadanie-2-reshenie-vozvrashhaem-enum-result-dopolnitelnye-punkty-2-3/)-> [Assigment2ExtraCredit3New](https://github.com/BestKora/CalculatorBrain-cs193p-2015-2/tree/Assigment2ExtraCredit3New)

[Дополнительные пункты 2 и 3](http://bestkora.com/IosDeveloper/zadanie-2-reshenie-vozvrashhaem-enum-result-dopolnitelnye-punkty-2-3/)-> [Assigment2ExtraCredit3New](https://github.com/BestKora/CalculatorBrain-cs193p-2015-2/tree/Assigment2ExtraCredit3New)

[Дополнительный пункт 1](http://bestkora.com/IosDeveloper/zadanie-2-reshenie-prodolzhenie-dopolnitelnye-punkty-1-3/)-> [Assigment2ExtraCredit2New](https://github.com/BestKora/CalculatorBrain-cs193p-2015-2/tree/Assigment2ExtraCredit2New) 

[Обязательные пункты 9 -12](http://bestkora.com/IosDeveloper/zadanie-2-reshenie-prodolzhenie-obyazatelnye-punkty-9-12/)-> [Assigment2Task9](https://github.com/BestKora/CalculatorBrain-cs193p-2015-2/tree/Assigment2Task9) 

[Обязательные пункты 5 -8](http://bestkora.com/IosDeveloper/zadanie-2-reshenie-prodolzhenie-obyazatelnye-punkty-5-8/)-> [Assigment2Task8](https://github.com/BestKora/CalculatorBrain-cs193p-2015-2/tree/Assigment2Task8) 

[Обязательные пункты 1 -4](http://bestkora.com/IosDeveloper/zadanie-2-nachalo/)-> [Assigment2Task4New](https://github.com/BestKora/CalculatorBrain-cs193p-2015-2/tree/Assigment2Task4New) 

 Для  Xcode 6.3 iOS 8.3 Swift 1.2
 
 [Окончательный вариант Swift 1.2](http://bestkora.com/IosDeveloper/zadanie-2-reshenie-vozvrashhaem-enum-result-dopolnitelnye-punkty-2-3/)-> [Assigment2AllSwift12](https://github.com/BestKora/CalculatorBrain-cs193p-2015-2/tree/Assignment2AllSwift12)
 
 Заменяем countElements на count в коде
 
  ```swift
   @IBAction func backSpace(sender: AnyObject) {
       .  .  .  .  .  .  .  .  .
            if count(display.text!) > 1 {
                display.text = dropLast(display.text!)
            } else {
       .  .  .  .  .  .  .  .  .  
            }

    }
```
Singleton для NSNumberFormatter - дополнение к Заданию 2 стэнфордского курса CS193P "Разработка iOS 8 приложений в Swift"

[Singleton для NSNumberFormatter](http://bestkora.com/IosDeveloper/kak-sozdat-nsnumberformatter-singleton-v-swift/) -> [Assignment2Singleton](https://github.com/BestKora/CalculatorBrain-cs193p-2015-2/tree/Assignment2Singleton)

 ```swift
class CalculatorFormatter: NSNumberFormatter {
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init() {
        super.init()
        self.locale = NSLocale.currentLocale()
        self.numberStyle = .DecimalStyle
        self.maximumFractionDigits = 10
        self.notANumberSymbol = "Error"
        self.groupingSeparator = " "
        
    }
    
    // Swift 1.2 or above
    static let sharedInstance = CalculatorFormatter()
    
    /*    class var sharedInstance: CalculatorFormatter {
    struct Static {
    static let instance = CalculatorFormatter()
    }
    return Static.instance
    }*/
}
```
[Singleton для NSNumberFormatter Глобальная константа] (http://bestkora.com/IosDeveloper/kak-sozdat-nsnumberformatter-singleton-v-swift/) -> [Assignment2SingletonGlobal](https://github.com/BestKora/CalculatorBrain-cs193p-2015-2/tree/Assignment2SingletonGlobal)

 ```swift
 let formatter = CalculatorFormatter()
 ```



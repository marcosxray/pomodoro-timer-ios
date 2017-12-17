# README #

Pomodoro Timer.

### Instalação ###

Este projeto utiliza o Cocoapods como gerenciador de dependências.
Após baixar o código-fonte, rodar o comando 'pod install' na pasta do projeto.

### Considerações sobre o projeto ###

* Acredito que a interface é auto-explicativa, em termos de funcionamento
* O Aplicativo funciona em iPhones, rodando iOS 8 e superior (inclusive 4S)
* Utilizei o UserDefaults para guardar a lista de pomodoros executados (achei que seria overkill utilizar Core Data)
* Fiz alguns testes unitátios básicos
* Fiz alguns testes de interface básicos. Para rodar o teste de interface, a contante "timeout" deve receber um valor superior ao valor de 'PTConstants.initialTaskTime', para que seja feita a correta contabilização de uma task completa (pomodoro.ststus = finished)


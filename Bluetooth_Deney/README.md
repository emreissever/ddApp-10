# Bluetooth Sensörü 

Bu uygulamada, mobil telefondan veya tablet üzerinden uygulama seti üzerindeki HC-05 modülüne bağlanılacak ve bağlanılan cihazdan gönderilen verilere göre Basys3 üzerindeki LED yakılacak ve söndürülecektir. 

## Modülün Çalışma Prensibi 

UART seri haberleşme esasında çalışır. Üzerinde bulunan RX ve TX pinleri sayesinde iletişim sağlanır. Ayrıca bu pinler aracılığıyla Çalışma modu olarak komut (AT) modu ve veri iletim modu olmak üzere iki farklı mod sunar. Komut modunda, modül yapılandırılırken; veri iletim modunda, Bluetooth üzerinden kablosuz veri aktarımı sağlanır. 

**Ancak bu uygulamada HC-05 Bluetooth modülünün herhangi bir AT komutu ile konfigüre edildiğine dair bir işlem bulunmamaktadır.** AT komutları, HC-05 modülünün çalışma modunu, isimlendirmesini, PIN kodunu, baud rate değerini ve diğer parametrelerini ayarlamak için kullanılır. Ancak bu kodda modül, varsayılan ayarlarıyla kullanılmaktadır. HC-05 modülü, varsayılan olarak slave (köle) modunda ve standart seri iletişim ayarlarıyla (9600 baud rate, 8 data bits, 1 stop bit, no parity) çalışır.

## Kodun Çalışma Prensibi

Hiçbir komut gönderilmediğinde modülün varsayılan olarak slave (köle) modunda ve standart seri iletişim ayarlarıyla (9600 baud rate, 8 data bits, 1 stop bit, no parity) çalışacağından daha önce bahsedilmişti. Bu şekilde çalıştığında modül kablosuz olarak teslim aldığı bütün verileri UART kanalından gönderecektir. Bu durumda yapılması gereken sürekli olarak bu kanalın dinlenmesi ve gelen veriye göre LED yakılması veya söndürülmesi olacaktır. Bunun için öncelikle ;

Bir tane UART RX Modülü `(UART_RX_CTRL.vhd)` tasarlanmıştır.

Daha sonra bu modül kullanılarak gelen verileri sürekli kontrol eden ve eğer "1" karakteri gelirse LD0 isimli LED’i yakan ve eğer "0" karakteri gelirse LD0 isimli LED’ini söndüren bir üst Modülün `(serialport.vhd)` tasarımı gereklidir.

```
serialport.vhd
└── UART_RX_CTRL.vhd
```

## Bağlantı Şeması 

<div align="center">
<img src="pinout.png" alt="Şematik" width="800">
</div>

FPGA çalışma gerilimi ile Bluetooth modülünün çalışma gerilimi farkından dolayı araya bir **Logic Level Converter** konulmuştur. 

## Kodun Çalıştırılması 

Deneyin Yapılışı 
1.	Uygulama setinin harici güç adaptörünün takınız.
2.	Uygulama seti üzerindeki BLUETOOTH isimli modülün DIP SWITCH-4 isimli anahtarın tümü aktif hale getirilmelidir.
3.	Daha sonra projenin .bit uzantılı dosyasını FPGA kartına yazdırın.
4.	Mobil telefonunuzdan veya tabletinizden "HC-05" ismindeki bluetooth cihazı ile eşleşin, şifreye varsayılan olarak "1234" girilmelidir. 
5.	Mobil telefonunuza veya tabletinize herhangi bir Bluetooth Seri Haberleşme (Terminal) uygulaması indiriniz ve HC-05 ile haberleşmek üzere eşleşin.
6.	Eşleşme başarıyla tamamlandıktan sonra seri haberleşme uygulamasından "1" karakterini gönderdiğinizde Basys3 üzerindeki LD0 isimli ledin yandığını göreceksiniz. "0" karakterini göndermeniz durumunda aynı led sönecektir. 

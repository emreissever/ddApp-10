# Wi-Fi Modülü

## Uygulama 

ESP-01 Modülü FPGA üzerinden bir TCP sunucuya bağlanacak şekilde konfigüre edilecektir. Bu sunucudan gelen verilere göre Basys3 Kartı üzerindeki ledler yakılacaktır. 

## Kazanımlar

* UART Protokolü : UART protokolünün temel prensipleri, veri alışverişi için kullanılan standartlar ve bu protokolün gerçek dünya uygulamaları.

* AT Komutları : AT komutları ile bir IoT cihazın konfigüre edilmesi veri gönderilmesi alınması ve gelen verilerin analiz edilip içeriğine göre bir çıkış oluşturulması. 

## Uygulama 

Deneyde kullanılan ESP-01 modülü üzerinde Wi-Fi özelliğine sahip ESP8266 mikrodenetleyicisini barındırır. Bu denetleyici cihazların birbiri ile haberleşmesini sağlayan dahili TCP/IP katmanlarına sahiptir. 

ESP8266 Wi-Fi bağlantısı sağlamak amacıyla tasarlanmış olan bütün RF yapılarını barındırır ve çok az harici devre elemanına ihtiyaç duyar. Wi-Fi özelliklerinin yanı sıra, ESP8266, Cadence firmasına ait olan Tensilica L106 Diamond serisinin gelişmiş bir versiyonu olan 32-bit işlemci ve dahili SRAM barındırmaktadır. ESP8266 mikrodenetleyicisi giriş/çıkış pinleri sayesinde sensörler ve diğer cihazlara bağlanabilmektedir. Bu özellikleri sayesinde ESP8266 tek başına bir sistemi kontrol edebilir. Ancak proje ihtiyaçlarına göre bir gömülü sisteme Wi-Fi özelliği kazandırmak amacıyla başka bir mikroişlemciye ek olarak da kullanılabilmektedir. Bir mikrodenetleyiciye Wi-Fi özelliği kazandırmak amacıyla Wi-Fi adaptörü olarak eklendiğinde UART veya SPI ara yüzleri aracılığı ile bağlantı sağlanabilir.

Bu uygulamada ESP8266 Wi-Fi modülün uygulanması gösterilecektir. Modülün uygulanması için UART haberleşmesi kullanılacaktır. UART haberleşmesi ile AT komutlarını kullanarak Wi-Fi modülünü konfigürasyonu yapılacaktır. Bu sayede Wi-Fi modülün ağa bağlanması gerçekleşecek ve TCP server oluşturabilen bir program aracılığı ile Basys3 üzerindeki LD12, LD13, LD14 ve LD15 ledlerini sırasıyla D, C, B, A harfleriyle yakılıp d, c, b, a harflerini kullanarak söndürülecektir. 

## Kodun Çalıştırılması

1. **Uygulama Kartının Adaptörünü Bağlayıp Üzerindeki Güç Anahtarını Açınız! (Unutmayın!)**
2. Uygulama seti üzerindeki **_WI-FI_** isimli modülün **_DIP SWITCH-10_** isimli anahtarın tümü açık hale getirilmelidir.
3. Daha sonra projenin **_.bit_** uzantılı dosyasını FPGA kartına yazdırın.

## Referanslar

[TR]

HDL modülleri, _(WifiTopLevel.vhd, i_esp8266.vhd, i_tx.vhd, i_rx.vhd)_ Mike Field'ın "Session setup and sending packets of data using ESP8266" projesinden alınmıştır. Ticari bir amaçla değil kullanılan donanımın çalışılabilirliğini kanıtlama amacıyla kullanılmıştır. 

[EN]

HDL modules: (WifiTopLevel.vhd, i_esp8266.vhd, i_tx.vhd, i_rx.vhd) have been taken from Mike Field's project "Session setup and sending packets of data using ESP8266." They are used not for commercial purposes but to demonstrate the workability of the hardware.
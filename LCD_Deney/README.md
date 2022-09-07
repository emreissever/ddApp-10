# LCD Ekran 8x2

## Uygulama 

Bu uygulamada önceden belirlenmiş ASCII karakterler _"FPGA ddApp-10"_ ekrana yazdırılır.

## Kazanımlar



## Modülün Çalışma Prensibi

Bu uygulamada kullanılan LCD (Liquid Crystal Display) modülü üzerinde sürücü olarak bir LSI denetleyicisi bulunmaktadır. Bu entegrenin 8 adet veri bacağı ve 3 adet kontrol bacağı vardır. Ekrana bir şey yazdırmak istediğinde kullanıcı bu entegrenin bacakları ile bir arayüz oluşturur. 

Ekrana bir şey yazdırmak istediğimizde aslında biz bu entegre bacakları ile bir arayüz oluşturuyoruz. 

Bu denetleyicinin kendine has bazı komutları (Instructions) vardır. Yukarıda bahsi geçen 8 adet veri bacağı ve 3 adet kontrol bacağı olmak üzere toplamda 11 bacak üzerinden bu komutlar gönderilerek. Ekrana yazı yazılabilir temizlenebilir bu işlemler sağlanır. 

| Pin No |  Pin Adı  | Pin Tanıtımı                                   |
| :----- | :-------: | ---------------------------------------------: |
| 1      |    Vss    | (Ground)                                       |
| 2      |    Vdd    | Güç Kaynağı (5 V)                              |
| 3      |    Vo     | Ekran'ın Kontrast Bacağı                       |
| 4      |    RS     | Veri / Komut alışverişi Modu Seçimi            |
| 5      |    R/W    | Okuma / Yazma Modu seçimi                      |
| 6      |     E     | Aktifleştirici Sinyal                          |
| 7-14   | DB7 - DB0 | Veri portları                                  |
| 15     |     A     | Arkaplan aydınlatması için güç kaynağı         |
| 16     |     K     | Arkaplan aydınlatması için topraklama (Ground) |



### Bağlantılar 

## Kodun Çalıştırılması


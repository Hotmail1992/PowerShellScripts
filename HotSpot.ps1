# Скрипт создания точки доступа на компьютере (ноутбуке)

# задание параметров точки доступа
netsh wlan set hostednetwork mode = allow `
ssid = "HotSpot" key = "12345"

# активация точки доступа
netsh wlan start hostednetwork

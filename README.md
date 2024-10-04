# monitoring_hidroponik_flutter

TA Sistem Monitoring Instalasi Hidroponik menggunakan LoRaWAN dan Framework Flutter

## Icon Credit
Hydroponic icons created by Freepik - Flaticon
https://www.flaticon.com/free-icon/hydroponic_3227829?term=hydroponic&page=1&position=9&origin=tag&related_id=3227829

## Clean
flutter clean

## Build WEB
flutter build web (already exist in predeploy)
firebase deploy --only hosting

## Build ANDROID
flutter build appbundle
flutter build appbundle --release (Play Store)

## Build CLOUD FUNCTIONS
firebase deploy --only functions